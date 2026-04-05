import urllib.request
import zipfile
import os
import shutil
from pathlib import Path
import platform
import subprocess
import tarfile

_this_folder = Path(__file__).parent


# ------------------------
# URL
# ------------------------
def get_download_url(version: str | None = None) -> str:
    system = platform.system()

    if system == "Windows":
        asset = "nvim-win64.zip"
    elif system == "Linux":
        asset = "nvim-linux-x86_64.tar.gz"
    else:
        raise ValueError(f"Unsupported OS: {system}")

    if version is None:
        return f"https://github.com/neovim/neovim/releases/latest/download/{asset}"
    if not version.startswith("v"):
        version = f"v{version}"
    return f"https://github.com/neovim/neovim/releases/download/{version}/{asset}"


# ------------------------
# Installed dir detection
# ------------------------
def get_installed_directory() -> Path | None:
    system = platform.system()
    cmd = "where nvim" if system == "Windows" else "which nvim"

    result = subprocess.run(cmd, shell=True, text=True, stdout=subprocess.PIPE)

    for cand in result.stdout.splitlines():
        if system == "Windows":
            if cand.endswith("nvim.exe"):
                p = Path(cand)
                if p.parent.name == "bin":
                    return p.parent.parent
        else:
            if cand.endswith("nvim"):
                p = Path(cand)
                if p.parent.name == "bin" and p.parent.parent.name == "nvim":
                    return p.parent.parent
    return None


# ------------------------
# Default install dir
# ------------------------
def get_default_directory() -> Path:
    system = platform.system()

    if system == "Windows":
        return Path(os.environ["LOCALAPPDATA"]) / "nvim"

    elif system == "Linux":
        return Path.home() / ".local" / "opt" / "nvim"

    raise ValueError(f"{system=}")


# ------------------------
# Safe extract
# ------------------------
def safe_extract_tar(tar: tarfile.TarFile, path: Path) -> None:
    for member in tar.getmembers():
        member_path = path / member.name
        if not str(member_path.resolve()).startswith(str(path.resolve())):
            raise Exception("Unsafe tar file detected")

    tar.extractall(path)


def safe_extract_zip(zip_ref: zipfile.ZipFile, path: Path) -> None:
    for member in zip_ref.namelist():
        member_path = path / member
        if not str(member_path.resolve()).startswith(str(path.resolve())):
            raise Exception("Unsafe zip file detected")

    zip_ref.extractall(path)


def extract_file(path: Path, extract_dir: Path, kind: str) -> None:
    if kind == "zip":
        with zipfile.ZipFile(path, "r") as zip_ref:
            safe_extract_zip(zip_ref, extract_dir)

    elif kind == "tar.gz":
        with tarfile.open(path, "r:gz") as tar:
            safe_extract_tar(tar, extract_dir)

    else:
        raise ValueError(f"Unknown archive type: {kind}")


# ------------------------
# Main install
# ------------------------
def install(version: str | None = None) -> Path:
    install_dir = get_installed_directory() or get_default_directory()
    url = get_download_url(version)

    tmp_dir = _this_folder / "tmp"
    tmp_dir.mkdir(exist_ok=True)

    # ファイル名取得
    name = url.split("/")[-1]

    # 種類判定
    if name.endswith(".zip"):
        kind = "zip"
    elif name.endswith(".tar.gz"):
        kind = "tar.gz"
    else:
        raise ValueError(f"Unknown archive: {name}")

    compressed_path = tmp_dir / name
    extract_dir = tmp_dir / "extract"

    shutil.rmtree(extract_dir, ignore_errors=True)
    extract_dir.mkdir()

    print("Downloading...")
    urllib.request.urlretrieve(url, compressed_path)

    print("Extracting...")
    extract_file(compressed_path, extract_dir, kind)

    # 展開されたルートディレクトリを取得
    roots = list(extract_dir.iterdir())
    if not roots:
        raise RuntimeError("Extraction failed: no files found")

    root = next((p for p in roots if p.is_dir()), None)
    if root is None:
        raise RuntimeError("No valid directory found in archive")

    print(f"Installing to {install_dir} ...")

    install_dir.parent.mkdir(parents=True, exist_ok=True)

    if install_dir.exists():
        shutil.rmtree(install_dir)

    shutil.move(str(root), str(install_dir))

    shutil.rmtree(extract_dir)

    print("Done")
    return install_dir 


def ensure_path_in_bashrc(bin_path: Path):
    shell = os.environ.get("SHELL", "")

    if "zsh" in shell:
        rc = Path.home() / ".zshrc"
    else:
        rc = Path.home() / ".bashrc"

    line = f'export PATH="{bin_path}:$PATH"'

    if rc.exists():
        content = rc.read_text()

        if str(bin_path) in content:
            print("[INFO] PATH already configured")
            return
    else:
        print(f"`{rc=}` is not existent.")

    with rc.open("a") as f:
        f.write(f"\n# Added by nvim installer\n{line}\n")

    os.environ["PATH"] = f"{bin_path}:{os.environ['PATH']}"
    print(f"[INFO] `{bin_path=}`: PATH updated. Restart shell to take effect.")

if __name__ == "__main__":
    install_directory = install("0.11.7")
    bin_path = install_directory / "bin"
    if platform.system()  == "Linux":
        ensure_path_in_bashrc(bin_path)
