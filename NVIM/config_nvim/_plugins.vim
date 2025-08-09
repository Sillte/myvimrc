let s:script_path = expand('<sfile>:p')
let s:base_dir = fnamemodify(s:script_path, ':h')
let s:plugin_dir = s:base_dir . '/_plugins' 

echo s:plugin_dir 

let s:patterns = [
      \ s:plugin_dir . '/*.vim',
      \ s:plugin_dir . '/*/*.vim',
      \ ]

for pattern in s:patterns
  for file in split(glob(pattern), '\n')
      execute 'source' fnameescape(file)
  endfor
endfor
