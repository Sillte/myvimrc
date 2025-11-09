from pathlib import Path
from utils import get_vscode_user_dir, get_names, copy_with_backup


_this_folder = Path(__file__).absolute().parent

def fetch_settings() -> None:
    vscode_directory = get_vscode_user_dir()
    for name in get_names():
        src_path = vscode_directory / name
        if src_path:
            dst_path = _this_folder / name
            copy_with_backup(src_path, dst_path)
        else:
            print("`src_path` does not exist", src_path)


if __name__ == "__main__":
    fetch_settings()
