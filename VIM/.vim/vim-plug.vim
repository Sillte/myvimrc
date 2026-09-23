if exists('$XDG_CACHE_HOME')
      let s:plug_home = $XDG_CACHE_HOME . '/vim/plugged'
else
      let s:plug_home = expand('~/.cache/vim/plugged')
endif

if !filereadable(expand('<sfile>:p:h') . '/autoload/plug.vim')
    finish
endif

call plug#begin(s:plug_home)

Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'w0ng/vim-hybrid'
Plug 'itchyny/lightline.vim'
Plug 'dhruvasagar/vim-table-mode'
Plug 'godlygeek/tabular'
Plug 'tpope/vim-fugitive'
Plug 'cespare/vim-toml'
Plug 'psf/black'
Plug 'sillte/vim-pytoy'

Plug 'davidhalter/jedi-vim', { 'for': 'python' }
Plug 'vim-python/python-syntax', { 'for': 'python' }
Plug 'preservim/vim-markdown', { 'for': 'markdown' }
Plug 'iamcco/markdown-preview.nvim', {
      \ 'for': 'markdown',
      \ 'do': 'cd app && npx --yes yarn install'
      \ }

call plug#end()

let g:jedi#rename_command = "<Leader>R"
let g:jedi#auto_initializtion = 1
let g:jedi#completion_enabled = 1
let g:jedi#popup_on_dot = 0
let g:jedi#popup_select_first = 0
let g:jedi#show_call_signatures = 0
let g:jedi#documentation_command = "<Leader><SPACE>K"

let g:lsp_settings_filetype_python = ['pyright-langserver']
let g:lsp_settings_filetype_markdown = ['marksman']

command! -nargs=0 Qsort python3 import pytoy; pytoy.quickfix_timesort()

unlet s:plug_home