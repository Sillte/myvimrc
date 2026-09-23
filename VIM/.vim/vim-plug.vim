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
Plug 'sillte/vim-pytoy'

Plug 'vim-python/python-syntax', { 'for': 'python' }
Plug 'preservim/vim-markdown', { 'for': 'markdown' }
Plug 'iamcco/markdown-preview.nvim', {
      \ 'for': 'markdown',
      \ 'do': 'cd app && npx --yes yarn install'
      \ }

let s:site_config = expand('<sfile>:p:h') . '/vim-plug_site.vim'
if filereadable(s:site_config)
      execute 'source' fnameescape(s:site_config)
endif

call plug#end()

unlet s:plug_home