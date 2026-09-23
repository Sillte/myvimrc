let s:folder = expand('<sfile>:p:h') 

function! MyvimArrange() abort
execute "tabe " . $MYVIMRC
execute "vert new " . s:folder . "/scratch.vim"
execute "new " . s:folder . "/vim-plug.vim"
endfunction
