""" Fetch. 
"""

import utils

if __name__ == "__main__":
    homepath = utils.get_home_path()
    target_paths = utils.get_relative_paths()
    for path in target_paths:
        src = homepath / path
        dst = utils.THIS_FOLDER / path
        utils.copy(src, dst)
