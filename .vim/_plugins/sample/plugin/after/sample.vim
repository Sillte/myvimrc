python3 << EOF
import vim
try:
    import pytoy
    vim.vars["import_pytoy"] = 1 
except ImportError as e:
    vim.vars["import_pytoy"] = 0
    pass
EOF
if g:import_pytoy == 0
    finish
endif
python3 << EOF


from pytoy.command_manager import CommandManager
from pathlib import Path
import vim

@CommandManager.register("PytoySample", exist_ok=True)
def func():
    path = Path(__name__).absolute().parent
    vim.command("""echo 'hogehoge' """)
EOF


