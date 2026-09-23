import subprocess
import sys
from pathlib import Path

_this_folder = Path(__file__).absolute().parent
_installers = (
    _this_folder / "GIT" / "install.py",
    _this_folder / "VIM" / "install.py",
    _this_folder / "NVIM" / "install_config.py",
    _this_folder / "VSCODE" / "install.py",
)


def install_all() -> None:
    for installer in _installers:
        print(f"\n=== Installing {installer.parent.name} config ===")
        subprocess.run(
            [sys.executable, installer.name],
            cwd=installer.parent,
            check=True,
        )


if __name__ == "__main__":
    install_all()