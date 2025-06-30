python3 << EOF
try:
    import pytoy
except ImportError:
    pass

from pytoy.command import Command

@Command.register(name="SampleNVimPlyginCommand", exist_ok=True)
def func():
    from pytoy import TERM_STDOUT
    #print("This is a sample.")
    vim.command('CMD git --help & echo "HELLO!" ')
EOF
