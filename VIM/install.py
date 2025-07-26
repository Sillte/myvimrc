"""
Install the target files to `$HOME` folder.

* `$HOME/_vimrc` 

"""

import utils

if __name__ == "__main__":
    homepath = utils.get_home_path()
    target_paths = utils.get_relative_paths()
    for path in target_paths:
        src = utils.THIS_FOLDER / path
        dst = homepath / path
        utils.copy(src, dst)

    # if `site-specific` does not exist, 
    # then empty files are generated.

    for target in utils.SITE_SPECIFICS:
        path = homepath / target
        if not path.exists():
            print(f"Empty `{path}` file is generated. ")
            path.write_text("", encoding="utf8")


