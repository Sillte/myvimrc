python3 << EOF
try:
    import pytoy
except ImportError:
    pass

from pytoy.command import CommandManager

@CommandManager.register(name="SampleMockCommand")
def func():
    print("This is a sample.")

EOF
