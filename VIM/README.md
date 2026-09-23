## Requirements

* git (For installation of plugins)
* python3.13+ 

### Quick Tips for installation
This `vimrc` assumes that Python is available.
In `site.vim`, configure the Python DLL if needed:

For example, if you use Python 3.13, add `site.vim` as follows.
```
set pythonthreedll=python313.dll
```
At first, run `:PlugInstall` to install the plugins. This may take some time.

For Python and Markdown LSP support, run `:LspInstallServer` while editing a
Python or Markdown file. The current configuration selects `pyright-langserver`
for Python and `marksman` for Markdown.

 
## Description of folder and files

#### `vim-plug.vim` / `plugged`
Configuration for [vim-plug](https://github.com/junegunn/vim-plug).
Run `:PlugInstall` after the first installation, then use `:PlugUpdate` and
`:PlugClean` to maintain the plugins.

### `vim-plug_site.vim`
Optional machine-specific plugin declarations. Add `Plug` lines here when a
plugin should only be installed on one machine. This file is not overwritten by
the installer.

### `site.vim`
Use to write settings specific to each computers. 
For example, `pythonthreedll` may be different over each computer,  
and it is important to call `py3`.

#### `_myplugins` 

Plugins under development for personal usage.    
`runtimepath` for those plugins has the highest priority.   
`_myplugins/init.vim` is expected to be called at the end of `_vimrc.`


