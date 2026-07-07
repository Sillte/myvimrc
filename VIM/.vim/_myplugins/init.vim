function! s:AddRuntime(path) abort
    if isdirectory(a:path)
        execute 'set runtimepath^=' . fnameescape(a:path)
    endif
endfunction

let s:plugins_folder = expand('<sfile>:p:h')

for s:path in split(glob(s:plugins_folder . '/*'), '\n')
    if isdirectory(s:path)
        call s:AddRuntime(s:path)
    endif
endfor
