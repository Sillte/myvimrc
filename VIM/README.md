## Requirement

* git (For installment of `dein`)
* python3.13+ 

### Quick Tips for installment.
This `vimrc` assumes to use `python`. 
Hence,  In `site.vim`

For example, if you use python 3.11, add `site.vim` as follows.   
```
set pythonthreedll=python313.dll
```
At first, it requires long time for installment of plugins. 

 
## Description of folder and files

#### `dein.vim` / `dein` / `dein.toml`
Configuration for [dein](https://github.com/Shougo/dein.vim).  
It's related to plugin management.

### `site.vim`
Use to write settings specific to each computers. 
For example, `pythonthreedll` may be different over each computer,  
and it is important to call `py3`.

#### `_myplugins` 

Plugins under development for personal usage.    
`runtimepath` for those plugins has the highest priority.   
`_myplugins/init.vim` is expected to be called at the end of `_vimrc.`


