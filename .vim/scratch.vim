let s:folder = expand('<sfile>:p:h') 

function! MyvimArrange() abort
execute "tabe " . $MYVIMRC
execute "vert new " . s:folder . "/scratch.vim"
execute "new " . s:folder . "/dein.toml"
endfunction


" Python Setting
"jupyter-vim
let g:jupyter_mapkeys = 0
let g:jupyter_monitor_console = 1
function! JupyterAssureFunc()
python3 << PYTHON
import vim
import jupyter_vim
from jupyter_vim import send

if not jupyter_vim.check_connection():
    try:
        ret = jupyter_vim.connect_to_kernel(jupyter_vim.vim2py_str(vim.current.buffer.vars['jupyter_kernel_type']),
                                      filename='*.json')
        if not jupyter_vim.check_connection():
            raise ValueError()
    except Exception as e:
        vim.command("term ++hidden jupyter console")
        jupyter_vim.connect_to_kernel(jupyter_vim.vim2py_str(vim.current.buffer.vars['jupyter_kernel_type']),
                                      filename='*.json')
        # assert jupyter_vim.check_connection() is True
PYTHON

endfunction
nnoremap  <C-Space> :call JupyterAssureFunc()<CR>V:JupyterSendRange<CR>:JupyterUpdateShell<CR>
vnoremap  <C-Space> :call JupyterAssureFunc()<CR>gv:JupyterSendRange<CR>:JupyterUpdateShell<CR>

""Personal commands. 
map  \fp :!python %<CR>

