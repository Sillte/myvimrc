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
set -euo pipefail
trap 'echo "[ERROR] at line $LINENO: $BASH_COMMAND"; exit 1' ERR

# Configuration
ENV_NAME="${1:-mynvim}"
NVIM_HOME="$HOME/$ENV_NAME"
NVIM_BIN="$NVIM_HOME/bin"
NVIM_PATH="$NVIM_BIN/nvim"
VOLTA_HOME="$HOME/.volta"


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

PYTHON=$(command -v python3 2>/dev/null || command -v python 2>/dev/null)

# Install uv (for safe dependency management)
if ! $PYTHON -m uv --version >/dev/null 2>&1; then
  echo "[INFO] Installing uv..."
  $PYTHON -m pip install --user uv
fi

# Install Python dependencies
if [ -f "requirements.txt" ]; then
  echo "[INFO] Installing Python dependencies from requirements.txt..."
  $PYTHON -m pip install --user -r requirements.txt
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

# Installment of Neovim, if necessary.
if ! command -v nvim >/dev/null; then
  echo "[INFO] Neovim not found. Installing Neovim AppImage..."
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
  chmod +x nvim.appimage
  mv nvim.appimage "$NVIM_PATH"

  # Create folders
  mkdir -p "$NVIM_BIN"
  
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
