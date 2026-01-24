import sys
from pathlib import Path

_this_folder = Path(__file__).absolute().parent
_target_folder = _this_folder / "config_nvim"
sys.path.append(_this_folder.as_posix())
from utils_config import get_config_path, copyfiles_with_glob

def _kill_imeoffhook():
    import platform 
    if platform.system() != "Windows":
        return

    import subprocess
    from subprocess import PIPE, STDOUT

    target_name = "IMEOFFHOOK_EXE.exe"

    # プロセス一覧確認
    result = subprocess.run(
        f'chcp 65001 >nul & tasklist /FI "IMAGENAME eq {target_name}"',
        text=True,
        shell=True,
        stdout=PIPE,
        stderr=STDOUT,
        encoding="utf-8"
    )

    if target_name in result.stdout:
        print(f"Killing process {target_name}")
        subprocess.run(f'taskkill /F /IM {target_name}', shell=True)
    else:
        print(f"No process named {target_name} is running")


if __name__ == "__main__":
    _kill_imeoffhook()
    config_path = get_config_path()
    copyfiles_with_glob(_target_folder, config_path, exclude=["site/**/*.lua", ".git/**/*", ".venv/**/*"])
