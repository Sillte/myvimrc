import os
import subprocess
from subprocess import PIPE
import re
import shutil
from pathlib import Path
import platform 

_this_folder = Path(__file__).absolute().parent
_win_folder = _this_folder / "host"
_remote_folder = _this_folder / "remote"


def get_vscode_user_dir() -> Path:
    system = platform.system().lower()
    if system == "windows":
        return Path(os.environ["APPDATA"]) / "Code" / "User"
    elif system == "linux":
        return Path.home() / ".vscode-server/data/Machine"
    elif system == "darwin":
        return Path.home() / "Library" / "Application Support" / "Code" / "User"
    else:
        raise OSError(f"Unsupported system: {system}")

def get_repo_folder() -> Path:
    system = platform.system().lower()
    if system == "windows":
        return _win_folder
    else:
        return _remote_folder


def get_names() -> list[str]:
    return ["settings.json", "keybindings.json"] 


def copy_with_backup(src_path: Path,  dst_path: Path):
    if dst_path.exists():
        shutil.copy(dst_path, dst_path.parent / f"{dst_path.name}.bak")
    shutil.copy(src_path, dst_path)


def _get_neovim_path() -> str:
    system = platform.system().lower()
    if system == "windows":
        command = "where"
    else:
        command = "which"
    ret = subprocess.run(f"{command} nvim", stdout=PIPE, shell=True, text=True)
    if ret.returncode != 0:
        return ""
    lines = [line.strip() for line in ret.stdout.split("\n") if line.strip()]
    if lines:
        return lines[0]
    return ""

def is_remote_environment():
    system = platform.system().lower()
    if system == "windows":
        return False
    return True


def override_neovim_if_possible(path: str | Path):
    """If possible, `neovim` path is over-ridden, preserving the original line's indentation."""
    path = Path(path)
    assert path.name == "settings.json"

    pattern_str = r"""
(\s*)["|']vscode-neovim\.neovimExecutablePaths\.linux["|']\s*:\s*["|'](.+)["|']
""".strip().replace('\n', '')
    pattern = re.compile(pattern_str)

    nvim_path = _get_neovim_path()
    if not nvim_path:
        print("NVIM is not installed")
    else:
        print(f"The path to `nvim` is  `{nvim_path}`")

    found = False
    try:
        lines = path.read_text().split("\n")
    except FileNotFoundError:
        print(f"Error: File not found at {path}")
        return

    output = []
    
    for line in lines:
        s = pattern.search(line)
        if s:
            new_line = f'{s.group(1)}"vscode-neovim.neovimExecutablePaths.linux": "{nvim_path}", '
            output.append(new_line)
            found = True
        else:
            output.append(line)
            
    if found:
        print("Succeeded to override the settings of `vscode-neovim.neovimExecutablePaths.linux`.")
        output = [line.rstrip() for line in output]
        path.write_text("\n".join(output))
    else:
        print("Cannot set `vscode-neovim.neovimExecutablePaths.linux`. The setting was not found. Please check your `settings.json`")
