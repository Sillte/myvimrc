from pathlib import Path
import subprocess 
import shutil
from subprocess import PIPE

def get_config_path() -> Path:
    ret = subprocess.run(
        ["nvim", "--headless", "-u", "NONE", "+echo stdpath('config')", "+q"],
        stdout=PIPE,
        stderr=subprocess.STDOUT, 
        text=True
    )
    config_path = Path(ret.stdout.strip())
    return config_path


def copyfiles_with_glob(src_base: Path | str, dst_base: Path | str, target: str = "**/*", exclude: list[str] | str | None = None):
    src_base = Path(src_base)
    dst_base = Path(dst_base)
    paths = [path.resolve() for path in src_base.glob(target) ]
    if exclude:
        if isinstance(exclude, str):
            excluded_paths = [path.resolve() for path in src_base.glob(exclude)]
        elif isinstance(exclude, list):
            excluded_paths = sum([[path.resolve() for path in src_base.glob(item)] for item in exclude], [])
    else:
        excluded_paths = []
    paths = list(set(paths) - set(excluded_paths))
    print("excluded_paths", excluded_paths)
    for path in paths:
        if path.is_dir():
            continue
        relpath = path.relative_to(src_base)
        dst_path = dst_base / relpath
        dst_path.parent.mkdir(exist_ok=True, parents=True)
        print("src", path, "dst", dst_path)
        shutil.copy2(path, dst_path)
