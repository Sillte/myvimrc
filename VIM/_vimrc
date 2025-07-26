" File Structures
" ------------
" All of the settings and backups are placed under the following folder.
" * `{Folder under which _vimrc exists}` / `.vim` 
" [IMPORTANT] When you transport the environment, `.vim` should  also be
" copied.
"
"
set noswapfile
set number
set signcolumn=yes

set updatetime=2000
let g:myvim_folder = expand('<sfile>:p:h') . "/.vim"  

" Languate Server Protocol setting.
"language en_US.UTF-8
nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

nnoremap <silent><nowait>K :call CocActionAsync("doHover")<CR>
nnoremap <C-k> :call CocActionAsync("showSignatureHelp")<CR>
inoremap <silent><C-k>  <C-r>=CocActionAsync('showSignatureHelp')<CR>

nnoremap <silent>gd :call CocAction("jumpDefinition")<CR>
nnoremap <silent>gD :call CocAction("jumpDeclaration")<CR>
nnoremap <silent>gi :call CocAction("jumpImplementation")<CR>
nnoremap <silent>gy :call CocAction("jumpTypeDefinition")<CR>
nnoremap <silent>gr :call CocAction("jumpReferences")<CR>

nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> [g <Plug>(coc-diagnostic-prev)

nnoremap <F11> :call CocAction("diagnosticToggle")<CR>

inoremap <silent><expr> <c-x><c-j> coc#refresh()
inoremap <silent><expr> <c-j> coc#refresh()
nmap <leader>qf  <Plug>(coc-fix-current)

xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

command! CocRoot execute "CocCommand workspace.workspaceFolders"


set laststatus=2
set shellslash
set autochdir
set helplang=en,jp
set tabstop=8 expandtab shiftwidth=4 softtabstop=4
set hidden
" I do not know the reason, but to prevent moji-bake,
" encoding setting should  come first.
set encoding=utf8
set fileencoding=utf8
set clipboard+=unnamed
set smartindent
set backspace=start,eol,indent
set visualbell t_vb=
set noerrorbells 

"When you leave insert mode, always `IM` becomes off.
inoremap <ESC> <ESC>:set iminsert=0<CR>

nmap j gj
nmap k gk

inoremap jj <ESC>

" Moving between buffers, tabs, windows.
nnoremap [b :bnext<CR>
nnoremap ]b :bprevious<CR>
nnoremap [t :tabnext<CR>
nnoremap ]t :tabprevious<CR>
nnoremap [l :lnext<CR>
nnoremap ol :lprevious<CR>
nnoremap [w <C-W><C-W>
nnoremap ]w <C-W><C-P>

noremap <F2> :execute ":edit " . $MYVIMRC <CR>
noremap <F3> :execute ":edit " . g:myvim_folder <CR>


" Files related to undo, backups and swap files.
let &undodir = g:myvim_folder . "/backups/undo"
if !isdirectory(&undodir)
    call mkdir(&undodir, "p") 
endif
let &backupdir = g:myvim_folder . "/backups/backup"
if !isdirectory(&backupdir)
    call mkdir(&backupdir, "p") 
endif
let &directory = g:myvim_folder . "/backups/swap"
if !isdirectory(&directory)
    call mkdir(&directory,"p") 
endif


"echo &runtimepath

" Add all the directory under `_plugins` to 
" Notice of the priorities.
" In addition to that, `_plugins.vim` is read here, if exists.
"
"
" PC(site) specific settings.
"
if filereadable(g:myvim_folder . "/site.vim")
    execute "source " g:myvim_folder . "/site.vim"
endif

let s:plugins_folder = g:myvim_folder . "/_plugins"
for s:path in split(glob(s:plugins_folder . '/*'), '\n')
  if s:path !~# '\~$' && isdirectory(s:path)
    let &runtimepath = s:path .  ',' . &runtimepath
  endif
endfor

let s:myplugins_vim = s:plugins_folder . '/_plugins.vim'
if filereadable(s:myplugins_vim)
    execute 'source '  s:myplugins_vim
endif

" Experimental settings.
if filereadable(g:myvim_folder . "/scratch.vim")
    execute "source " g:myvim_folder . "/scratch.vim"
endif


syntax enable
filetype plugin indent on


function s:inject_pytoy_reboot_debug()
    if exists('g:pytoy_loaded')
        return
    endif
    let l:cache_folder = exists('$XDG_CACHE_HOME') ? $XDG_CACHE_HOME : expand('~/.cache')
    let l:json_file = l:cache_folder . "/pytoy_reboot.json"
    let l:session_file = l:cache_folder . "/pytoy_reboot.vim"
    if filereadable(l:json_file)
      let l:data = json_decode(join(readfile(l:json_file), "\n"))
      call delete(l:json_file)
      if has_key(l:data, 'plugin_folder')
        execute 'let &runtimepath = "' . escape(l:data.plugin_folder, '"') . '," . &runtimepath'
        let l:plugin_dir = l:data.plugin_folder. '/plugin'
        if isdirectory(l:plugin_dir)
          for file in split(globpath(l:plugin_dir, '*.vim'), '\n')
            execute 'source' fnameescape(file)
          endfor
        endif
      endif
      execute 'source' fnameespace(l:session_file)
    endif
endfunction

call s:inject_pytoy_reboot_debug()

" dein settings.
execute "source " g:myvim_folder . "/dein.vim"

let g:jedi#documentation_command="<Leader><SPACE>K"


