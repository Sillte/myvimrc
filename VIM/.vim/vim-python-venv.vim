" ============================================================================
" vim-python-venv.vim
"
" Manage Vim's Python environment using uv.
"
" SSOT:
"   VIM_PYTHON_VENV
"
" Derived from pyvenv.cfg:
"   home
"   implementation
"   version_info
"
" Get default shared venv path
"
" Windows:
"   %LOCALAPPDATA%\vim-python-shared\.venv
"
" Unix:
"   $XDG_DATA_HOME/vim-python-shared/.venv
" ----------------------------------------------------------------------------
"
" ----------------------------------------------------------------------------
" Run uv pip command against the shared venv
"
" Usage:
"   :VimPythonVenvUv pip install requests
"   :VimPythonVenvUv pip list
"   :VimPythonVenvUv pip uninstall requests
" ----------------------------------------------------------------------------
" ============================================================================
"

if exists('g:loaded_vim_python_venv')
    finish
endif
let g:loaded_vim_python_venv = 1

" ----------------------------------------------------------------------------
" Configuration
" ----------------------------------------------------------------------------

if !exists('g:vim_python_venv_version')
    if exists('$VIM_PYTHON_VERSION') && !empty($VIM_PYTHON_VERSION)
        let g:vim_python_venv_version = $VIM_PYTHON_VERSION
    else
        let g:vim_python_venv_version = '3.13'
    endif
endif


" ----------------------------------------------------------------------------
" Get default venv path
" ----------------------------------------------------------------------------

function! s:get_default_venv_path() abort
    if has('win32') || has('win64')
        let l:base = $LOCALAPPDATA

        if empty(l:base)
            let l:base = expand('~')
        endif

        return l:base . '\vim-python-shared\.venv'
    endif

    let l:base = $XDG_DATA_HOME

    if empty(l:base)
        let l:base = expand('~') . '/.local/share'
    endif

    return l:base . '/vim-python-shared/.venv'
endfunction


" ----------------------------------------------------------------------------
" Get venv path from environment variable or default
" ----------------------------------------------------------------------------

function! s:get_venv_path() abort
    if exists('$VIM_PYTHON_VENV') && !empty($VIM_PYTHON_VENV)
        return fnamemodify($VIM_PYTHON_VENV, ':p')
    endif

    let $VIM_PYTHON_VENV = fnamemodify(s:get_default_venv_path(), ':p')
    return $VIM_PYTHON_VENV
endfunction


" ----------------------------------------------------------------------------
" Find uv
" ----------------------------------------------------------------------------

function! s:get_uv() abort
    if executable('uv')
        return exepath('uv')
    endif

    return ''
endfunction


" ----------------------------------------------------------------------------
" Get venv Python executable
" ----------------------------------------------------------------------------

function! s:get_python_executable(venv) abort
    if has('win32') || has('win64')
        return a:venv . '\Scripts\python.exe'
    endif

    return a:venv . '/bin/python'
endfunction


" ----------------------------------------------------------------------------
" Parse pyvenv.cfg
" ----------------------------------------------------------------------------

function! s:read_pyvenv_cfg(venv) abort
    let l:cfg_path = a:venv . '/pyvenv.cfg'

    if !filereadable(l:cfg_path)
        throw 'pyvenv.cfg not found: ' . l:cfg_path
    endif

    let l:cfg = {}

    for l:line in readfile(l:cfg_path)
        let l:line = trim(l:line)

        if empty(l:line) || l:line[0] ==# '#'
            continue
        endif

        let l:pos = stridx(l:line, '=')

        if l:pos < 0
            continue
        endif

        let l:key = trim(strpart(l:line, 0, l:pos))
        let l:value = trim(strpart(l:line, l:pos + 1))

        let l:cfg[l:key] = l:value
    endfor

    return l:cfg
endfunction


" ----------------------------------------------------------------------------
" Derive Python DLL path from pyvenv.cfg
" ----------------------------------------------------------------------------

function! s:get_python_dll(cfg) abort
    if !has_key(a:cfg, 'implementation')
        throw 'implementation is missing in pyvenv.cfg'
    endif

    if a:cfg.implementation !=# 'CPython'
        throw 'Unsupported Python implementation: ' . a:cfg.implementation
    endif

    if !has_key(a:cfg, 'home')
        throw 'home is missing in pyvenv.cfg'
    endif

    if !has_key(a:cfg, 'version_info')
        throw 'version_info is missing in pyvenv.cfg'
    endif

    let l:version = a:cfg.version_info

    " Convert 3.13 -> 313
    let l:version = substitute(l:version, '\.', '', 'g')

    let l:dll_name = 'python' . l:version . '.dll'
    let l:dll_path = a:cfg.home . '\' . l:dll_name

    return l:dll_path
endfunction


" ----------------------------------------------------------------------------
" Create venv using uv
" ----------------------------------------------------------------------------

function! s:create_venv(uv, venv) abort
    let l:parent = fnamemodify(a:venv, ':h')

    if !isdirectory(l:parent)
        call mkdir(l:parent, 'p')
    endif

    " system() receives a shell command string.
    " shellescape() quotes each argument.
    let l:cmd = shellescape(a:uv)
                \ . ' venv --python '
                \ . shellescape(g:vim_python_venv_version)
                \ . ' '
                \ . shellescape(a:venv)

    let l:output = system(l:cmd)

    if v:shell_error != 0
        throw 'uv venv failed: ' . l:output
    endif
endfunction


" ----------------------------------------------------------------------------
" Configure Vim's embedded Python
" ----------------------------------------------------------------------------

function! s:configure_vim_python(venv, cfg, dll) abort
    " Configure Python DLL and base Python home.
    if has('win32') || has('win64')
        if !filereadable(a:dll)
            throw 'Python DLL not found: ' . a:dll
        endif

        if !exists('&pythonthreedll')
            throw 'pythonthreedll option is unavailable'
        endif

        if !exists('&pythonthreehome')
            throw 'pythonthreehome option is unavailable'
        endif
    let &pythonthreedll = a:dll
    endif

    "let &pythonthreehome = a:cfg.home
endfunction


function! s:load_venv_dependencies(venv, cfg) abort
    " Determine venv site-packages.
    if has('win32') || has('win64')
        let l:site_packages = a:venv . '\Lib\site-packages'
    else
        let l:python_version = split(a:cfg.version_info, '\.')[0:1]->join('.')
        let l:site_packages = a:venv . '/lib/python'
                \ . l:python_version
                \ . '/site-packages'
    endif

    if !isdirectory(l:site_packages)
        throw 'site-packages not found: ' . l:site_packages
    endif

    " JSON string is a valid Python string literal.
    " This safely handles Windows paths and quotes.
    let l:python_path = json_encode(l:site_packages)

    execute 'py3 import site; site.addsitedir(' . l:python_path . ')'
endfunction

" ----------------------------------------------------------------------------
" Initialize
" ----------------------------------------------------------------------------

function! s:init() abort
    try
        let l:uv = s:get_uv()

        if empty(l:uv)
            throw 'uv was not found in PATH'
        endif

        let l:venv = s:get_venv_path()
        let l:python = s:get_python_executable(l:venv)

        " Create venv if Python executable is missing.
        if !filereadable(l:python)
            call s:create_venv(l:uv, l:venv)
        endif

        " Read venv metadata.
        let l:cfg = s:read_pyvenv_cfg(l:venv)

        " Derive Python DLL from pyvenv.cfg.
        let l:dll = s:get_python_dll(l:cfg)

        " Configure Vim's embedded Python.
        call s:configure_vim_python(l:venv, l:cfg, l:dll)

        " Resolve dependencies of virtual environment.
        call s:load_venv_dependencies(l:venv, l:cfg)

        " Publish resolved values.
        let g:vim_python_venv = l:venv
        let g:vim_python_executable = l:python
        let g:vim_python_dll = l:dll
    catch
        echohl ErrorMsg
        echom '[vim-python-venv] ' . v:exception
        echohl None
    endtry
endfunction


function! s:uv_pip(args) abort
    try
        let l:uv = s:get_uv()

        if empty(l:uv)
            throw 'uv was not found in PATH'
        endif

        let l:venv = s:get_venv_path()
        let l:python = s:get_python_executable(l:venv)

        if !filereadable(l:python)
            throw 'Python executable not found: ' . l:python
        endif

        " This command is intended for uv pip only.
        let l:args = split(a:args)

        if empty(l:args) || l:args[0] !=# 'pip'
            throw 'Usage: VimPythonVenvUv pip <uv pip arguments>'
        endif

        " Construct:
        " uv pip <arguments> --python <venv Python>
        let l:cmd = shellescape(l:uv)

        for l:arg in l:args
            let l:cmd .= ' ' . shellescape(l:arg)
        endfor

        let l:cmd .= ' --python ' . shellescape(l:python)

        echom '[vim-python-venv] Running: ' . l:cmd

        let l:output = system(l:cmd)

        if v:shell_error != 0
            echohl ErrorMsg
            echom '[vim-python-venv] uv pip failed:'
            echom l:output
            echohl None
            return
        endif

        if !empty(l:output)
            echom l:output
        endif

    catch
        echohl ErrorMsg
        echom '[vim-python-venv] ' . v:exception
        echohl None
    endtry
endfunction

" ----------------------------------------------------------------------------
" Command
" ----------------------------------------------------------------------------
"
command! -nargs=+ VimPythonVenvUv call <SID>uv_pip(<q-args>)
command! VimPythonVenvInit call <SID>init()

" ----------------------------------------------------------------------------
" Initialize
" ----------------------------------------------------------------------------

call s:init()
