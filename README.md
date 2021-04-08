## Requirement

* git (For installment of `dein`)
* python3.6+ 

### Quick Tips for installment.
This `vimrc` assumes to use `python`. 
Hence,  In `site.vim`

For example, if you use python 3.8, add `site.vim` as follows.   
```
set pythonthreedll=python38.dll
```

## global variable, functions, and mappings

* `g:myvim_folder`: Refer to the fullpath of `.vim` folder.
 
## Description of folder and files

#### `dein.vim` / `dein` / `dein.toml`
Configuration for [dein](https://github.com/Shougo/dein.vim).  
It's related to plugin management.

### `site.vim`
Use to write settings specific to each computers. 
For example, `pythonthreedll` may be different over each computer,  
and it is important to call `py3`.

#### `_plugins` 

Plugins under development for personal usage.    
`runtimepath` for those plugins has the highest priority.   
`_plugins/_plugins.vim` is expected to be called at the end of `_vimrc.`



