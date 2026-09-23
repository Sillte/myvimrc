import os
from pathlib import Path

_this_folder = Path(__file__).absolute().parent
_source_path = _this_folder / "ignore"


def get_global_ignore_path() -> Path:
    config_home = os.environ.get("XDG_CONFIG_HOME")
    if not config_home:
        config_home = str(Path.home() / ".config")
    return Path(config_home) / "git" / "ignore"


def normalize_pattern(pattern: str) -> str:
    """Normalize trailing whitespace for duplicate detection."""
    normalized = pattern.rstrip(" \t")
    trailing_whitespace = pattern[len(normalized):]
    backslashes = len(normalized) - len(normalized.rstrip("\\"))
    if trailing_whitespace and backslashes % 2:
        return pattern
    return normalized


def install_global_ignore() -> Path:
    target_path = get_global_ignore_path()
    target_path.parent.mkdir(parents=True, exist_ok=True)

    source_lines = _source_path.read_text(encoding="utf-8").splitlines()
    existing_text = target_path.read_text(encoding="utf-8") if target_path.exists() else ""
    existing_lines = {
        normalize_pattern(line) for line in existing_text.splitlines()
    }
    lines_to_add = [
        line for line in source_lines
        if line and normalize_pattern(line) not in existing_lines
    ]

    if lines_to_add:
        separator = "" if not existing_text or existing_text.endswith("\n") else "\n"
        with target_path.open("a", encoding="utf-8", newline="\n") as target:
            target.write(separator + "\n".join(lines_to_add) + "\n")

    print(f"Installed global git ignore to {target_path}")
    return target_path


if __name__ == "__main__":
    install_global_ignore()
