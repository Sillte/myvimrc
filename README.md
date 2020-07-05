# vimrc repository

## Summary

Repository for personal `_vimrc` repository.    

### Requirements

* `git`   
* `python` command activate `python3.6+ `
* `vim8.0+` (?)   


### Target files and folders. 
* `$HOME/.vim` 
* `$HOME/_vimrc` 

As for the over-written files, refer to [.utils.py](./utils.py)   


### Install

[DANGER] the following command rewrite the `vim` configuration file.
```bat
python install.py
```
In some cases, you have to specify the version of python.
Please specify it in `.vim/site.vim`.

For example in n my home's environment for using python3.8,  

```
set pythonthreedll=python38.dll
```

### Fetch

Fetch the target files into this folder. 

```bat
python fetch.py
```
