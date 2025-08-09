import sys
from pathlib import Path

_this_folder = Path(__file__).absolute().parent
_target_folder = _this_folder / "config_nvim"
sys.path.append(_this_folder.as_posix())
from utils_config import get_config_path, copyfiles_with_glob


if __name__ == "__main__":
    config_path = get_config_path()
    copyfiles_with_glob(_target_folder, config_path, exclude=["site/**/*.lua", ".git/**/*", ".venv/**/*"])
