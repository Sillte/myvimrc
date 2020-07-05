" File Structures
" ------------
" All of the settings and backups are placed under the following folder.
" * `{Folder under which _vimrc exists}` / `.vim` 
" [IMPORTANT] When you transport the environment, `.vim` should  also be copyied.
"
let g:myvim_folder = expand('<sfile>:p:h') . "/.vim"  

filetype plugin indent on
syntax on

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
nnoremap [w <C-W><C-W>
nnoremap ]w <C-W><C-P>

noremap <F2> :execute ":edit " . g:myvim_folder <CR>

" PC(site) specific settings.
if filereadable(g:myvim_folder . "/site.vim")
    execute "source " g:myvim_folder . "/site.vim"
endif

" dein settings.
execute "source " g:myvim_folder . "/dein.vim"


" Experimental settings.
if filereadable(g:myvim_folder . "/scratch.vim")
    execute "source " g:myvim_folder . "/scratch.vim"
endif

" Files related to undo, backups and swap files.
let &undodir = g:myvim_folder . "/backups/undo"
let &backupdir = g:myvim_folder . "/backups/backup"
let &directory = g:myvim_folder . "/backups/swap"
call mkdir(&undodir,"p") 
call mkdir(&backupdir,"p") 
call mkdir(&directory,"p") 

" Add all the directory under `_plugins` to 
" Notice of the priorities.
" In addition to that, `_plugins.vim` is read here, if exists.
"
let s:plugins_folder = g:myvim_folder . "/_plugins"
for s:path in split(glob(s:plugins_folder . '/*'), '\n')
  if s:path !~# '\~$' && isdirectory(s:path)
    let &runtimepath = s:path .  ',' . &runtimepath
  endif
endfor

let s:myplugins_vim = s:plugins_folder . '/_plugins/_plugins.vim'
if filereadable(s:myplugins_vim)
    execute 'source '  s:myplugins_vim
endif
