let s:script_path = expand('<sfile>:p')
let s:base_dir = fnamemodify(s:script_path, ':h')
let s:plugin_dir = s:base_dir . '/_plugins'

for file in sort(globpath(s:plugin_dir, '**/*.vim', 0, 1))
  execute 'source' fnameescape(file)
endfor
