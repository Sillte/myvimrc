"------------------------------------------------------------------------------
" Pytoy debugging support.
"
" This file is intended for plugin developers only.
" It modifies 'runtimepath' before plugins are loaded in order to restore
" debugging sessions.
"
" For the folder, you must specify the parent folder of `pytoy_reboot.json`.
"
" You must load this file from _vimrc before loading plugins.
"------------------------------------------------------------------------------
"

function! OverridePytoyRuntime(folder)
    if exists('g:pytoy_loaded')
        return
    endif
    let l:json_file = a:folder . "/pytoy_reboot.json"
    let l:session_file = a:folder . "/pytoy_reboot.vim"
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
      execute 'silent! source' fnameescape(l:session_file)
    endif
endfunction

