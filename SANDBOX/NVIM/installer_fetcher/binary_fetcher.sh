#!/usr/bin/env bash
#
#
# This script prepares the following environment:
# * Python (via apt if needed)
#     - uv (installed via pip)
#     - requirements.txt for pynvim, etc.
# * Node.js via Volta (if not already installed)
# * Neovim binary (nvim.appimage), in a configurable `nvim-env` path
#     - Adds to PATH if not already present


# Neovim environment setup
#
NVIM_VERSION="${NVIM_VERSION:-0.11.2}"
NVIM_APPIMAGE_URL="https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim-linux-x86_64.appimage"
FORCE_NVIM="${FORCE_NVIM:-1}"

set -euo pipefail
trap 'echo "[ERROR] at line $LINENO: $BASH_COMMAND"; exit 1' ERR

# Configuration
ENV_NAME="${1:-.local}"
NVIM_HOME="$HOME/$ENV_NAME"
NVIM_BIN="$NVIM_HOME/bin"
NVIM_PATH="$NVIM_BIN/nvim"
VOLTA_HOME="$HOME/.volta"

# Ensure `path` of `.local/bin`. 
mkdir -p "$HOME/.local/bin"
if ! grep -q "$HOME/.local/bin" "$HOME/.bashrc"; then
  echo "export PATH=\"$HOME/.local/bin:\$PATH\"" >> "$HOME/.bashrc"
  export PATH="$HOME/.local/bin:$PATH"
fi

# Install pip if not present. 


# Install Python if not present
if ! command -v python3 >/dev/null && ! command -v python >/dev/null; then
  echo "[INFO] Python3 not found. Trying to install via apt..."
  sudo apt-get update && sudo apt-get install -y python3 python3-pip
fi

if ! command -v python3 >/dev/null && ! command -v python >/dev/null; then
  echo "[ERROR] Python not found. Please install Python manually on Windows."
  exit 1
fi

# [5.5] 0ptional: `python` for `python3`
if ! command -v python >/dev/null && command -v python3 >/dev/null; then
  echo "[INFO] Creating alias 'python' -> 'python3'..."
  ln -s "$(command -v python3)" "$HOME/.local/bin/python"
  export PATH="$HOME/.local/bin:$PATH"
fi

# Install of pip.
if ! command -v pip >/dev/null; then
    sudo apt-get update && sudo apt-get install -y python3-pip
fi 

if ! command -v uv >/dev/null; then
    echo "[INFO] Install UV"
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
    chmod +x "$HOME/.local/bin/uv"
fi


# Install Python dependencies
if [ -f "requirements.txt" ]; then
  echo "[INFO] Installing Python dependencies from requirements.txt..."
  python -m pip install --break-system-packages -r requirements.txt
fi


# Install Volta if not present
if ! command -v volta >/dev/null; then
  echo "[INFO] Installing Volta..."
  curl https://get.volta.sh | bash
  export PATH="$VOLTA_HOME/bin:$PATH"
else
  echo "[INFO] Volta already installed."
fi

# Confirmation of addition of PATH for volta..
if ! grep -q "$VOLTA_HOME/bin" "$HOME/.bashrc"; then
  echo "export PATH=\"$VOLTA_HOME/bin:\$PATH\"" >> "$HOME/.bashrc"
  export PATH="$VOLTA_HOME/bin:$PATH"
fi

# Install Node.js (via Volta)
if ! command -v node >/dev/null; then
  echo "[INFO] Installing Node.js via Volta..."
  volta install node
fi


# [XDG Paths] Set standard paths if not already in .bashrc
declare -A XDG_VARS=(
  [XDG_CONFIG_HOME]="$HOME/.config"
  [XDG_DATA_HOME]="$HOME/.local/share"
  [XDG_CACHE_HOME]="$HOME/.cache"
)

for VAR in "${!XDG_VARS[@]}"; do
  VALUE="${XDG_VARS[$VAR]}"
  if ! grep -q "^export $VAR=" "$HOME/.bashrc"; then
    echo "[INFO] Setting $VAR to $VALUE in .bashrc"
    echo "export $VAR=\"$VALUE\"" >> "$HOME/.bashrc"
  else
    echo "[INFO] $VAR already defined in .bashrc"
  fi
  if [ -z "${!VAR:-}" ]; then
    echo "[INFO] Exporting $VAR for current shell"
    export "$VAR"="$VALUE"
  fi
done

# Installment of Neovim, if necessary.
if [ "${FORCE_NVIM}" = "1" ] || ! command -v nvim >/dev/null; then
  printf "[INFO] Installing Neovim v%s\n" "$NVIM_VERSION"
  mkdir -p "$NVIM_BIN"
  curl -LO "$NVIM_APPIMAGE_URL"
  chmod +x nvim-linux-x86_64.appimage
  mv nvim-linux-x86_64.appimage "$NVIM_PATH"
  
  # PATH addition.
  if ! grep -q "$NVIM_BIN" "$HOME/.bashrc"; then
    echo "[INFO] Adding Neovim to PATH..."
    echo "export PATH=\"$NVIM_BIN:\$PATH\"" >> "$HOME/.bashrc"
    export PATH="$NVIM_BIN:$PATH"
  fi
else
  echo "[INFO] Existing Neovim found at: $(command -v nvim)"
fi

echo "✅ Setup complete. You can now run Neovim with: nvim"
