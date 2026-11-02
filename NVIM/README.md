# neovim config fetch / installer

## Prerequisite

* python 
* neovim 
* uv

When creating a shared Python virtual environment, the Neovim config
automatically installs `pynvim` into it. Existing environments are not checked
or modified. The install excludes package releases uploaded within the last
3 days.

## Fetch config files


```python 
python fetch_config.py
```

## Install config files

```python 
python install_config.py
```



