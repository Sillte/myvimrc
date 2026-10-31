if exists('$XDG_CACHE_HOME')
    let s:cache = $XDG_CACHE_HOME . '/vim'
else
    let s:cache = expand('~/.cache/vim')
endif

let s:json_file = s:cache . "/pytoy_reboot.json"
if filereadable(s:json_file)
  let s:data = json_decode(join(readfile(s:json_file), "\n"))
  if has_key(s:data, 'debug_venv_path')
    let $VIM_PYTHON_VENV = s:data.debug_venv_path
  endif
endif

