from pathlib import Path
from utils import get_vscode_user_dir, get_names, copy_with_backup, override_neovim_if_possible, is_remote_environment, get_repo_folder

_this_folder = Path(__file__).absolute().parent

def install_settings() -> None:
    vscode_directory = get_vscode_user_dir()
    print("Installed to", vscode_directory)
    for name in get_names():
        src_path = vscode_directory / name
        if src_path:
            dst_path = get_repo_folder() / name
            copy_with_backup(src_path, dst_path)
        else:
            print("`src_path` does not exist", src_path)
    # If this is host, overriding path of `nvim` happens.
    if is_remote_environment():
        override_neovim_if_possible(vscode_directory / "settings.json")
    else:
        print("This is host environment, so no-overriding of  `nvim` path.")


if __name__ == "__main__":
    install_settings()

