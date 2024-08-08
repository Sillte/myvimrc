" dein's installment.
" * `.vim/dein.toml`: loading plugins
" * `.vim/dein_lazy.toml`: lazily loading plugins.
"
"" TIPS:
" * `dein#check_lazy_plugins` tells you what plugins are not compatible with `lazy-loading` (Existence of `plugin`) 
" * 
" Ref:https://qiita.com/kawaz/items/ee725f6214f91337b42b
" Suppose that you can use `git` unless you have already installed `dein`. `
let s:folder = expand('<sfile>:p:h')
let s:dein_dir = s:folder . "/dein"  
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
let s:dein_toml = s:folder . "/dein.toml"
let s:dein_site_toml = s:folder . "/dein_site.toml"
let s:dein_lazy_toml = s:folder . "/dein_lazy.toml"
" runtimepath's addition is required.
let &runtimepath = s:dein_repo_dir .",". &runtimepath

" When expected files are not existent, file is output.
if !isdirectory(s:dein_repo_dir)
  "call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
  call system('git clone https://github.com/Shougo/dein.vim ' . '"' . s:dein_repo_dir . '"')
endif
if !filereadable(s:dein_toml)
  call writefile(["# (Eagerly loaded)"], s:dein_toml)
endif  
if !filereadable(s:dein_site_toml)
  call writefile(["# (Eagerly loaded (For site-specific.))"], s:dein_site_toml)
endif  
if !filereadable(s:dein_lazy_toml)
  call writefile(["# (Lazily loaded)"], s:dein_lazy_toml)
endif  

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
  call dein#load_toml(s:dein_toml)
  call dein#load_toml(s:dein_site_toml)
  call dein#load_toml(s:dein_lazy_toml, {"lazy": 1})
  call dein#end()
  call dein#save_state()
endif

" Assure installments.
if has('vim_starting') && dein#check_install()
  call dein#install()
endif


" Uninstall command.
"call map(dein#check_clean(), "delete(v:val, 'rf')")
"call dein#recache_runtimepath()
