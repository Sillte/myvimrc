import os 
import subprocess 
from typing import List
from pathlib import Path
import re 
import shutil

THIS_FOLDER = Path(__file__).absolute().parent

EXCLUDES = [ ".gitignore",
             ".vim/site.vim",
             ".vim/scratch.vim",
             "fetch.py",
             "install.py",
             "utils.py",
             "README.md"]

SITE_SPECIFICS = [".vim/site.vim",
                  ".vim/scratch.vim"]

def copy(src, dst, non_exist_ok=True) -> None:
    """ Copy `src` (folder or file) to `dst`.  
    Notice that `dst` is over-written.
    """
    src = Path(src)
    dst = Path(dst)

    if not src.exists():
        if non_exist_ok:
            print(f"`{src}` is not existent.")
            return 
        else:
            raise ValueError(f"`{src}` is not existent.")

    if src.is_dir():
        assert dst.is_dir(), "`dst` is not a folder."
        if dst.exists():
            print(f"`{dst}` is over-written.") 
            shutil.rmtree(dst)
        shutil.copytree(src, dst)
    else:
        assert (not dst.is_dir()), "`src` is not a file."
        dst.parent.mkdir(exist_ok=True, parents=True)
        if dst.exists():
            print(f"`{dst}` is over-written.") 
        shutil.copyfile(src, dst)


def get_home_path() -> Path:
    """Return `HOME` path.
    """
    env = os.environ
    path = env.get("HOME", env.get("USERPROFILE"))
    if path is None:
        raise ValueError("HOME path's environment variable is not found.")
    return Path(path)


def get_relative_paths() -> List[Path]:  
    """Return List of relative paths which are the target of copies. 
    """

    ret = subprocess.run("git ls-files", universal_newlines=True, stdout=subprocess.PIPE, check=True)
    lines = [line for line in ret.stdout.split("\n") if line]
    exclusions = [re.compile(elem) for elem in EXCLUDES] 

    def is_excluded(line):
        for exclusion in exclusions:
            if exclusion.match(line):
                return True
        return False
    paths = [Path(line) for line in lines if not is_excluded(line)]
    return paths
        
