## myvimrc

Configuration of below applications 

* GIT (global config of ignore)
* VIM
* NVIM
* VSCODE

## Note

* Firstly, you install [uv](https://docs.astral.sh/uv/#installation) in a binary manner.
* When you install VSCode configuration, you must install NVIM configuration beforehand.

## Install all configurations

From the repository root, install the Git, VIM, NVIM, and VSCode configurations in order:

```powershell
uv run install_config_all.py
```

## Discussion (2026/09/23)

* `<leader>R` / `<leader>A`: Decide whether VS Code should use the same keys as Neovim for rename and code actions.
* `gD`: Decide whether to add the declaration-jump mapping to the regular Neovim LSP configuration for consistency.
* Completion: Consider `editor.suggestSelection: "first"` and `editor.tabCompletion: "on"` to align VS Code with blink.cmp.
* `<C-PageUp>` / `<C-PageDown>` are used for zoom-in and zoom-out. Do you feel they are comfortable?
    * Rule that `CTRL-` keymap is not used for direct movement of `cursor` may be appropriate.


