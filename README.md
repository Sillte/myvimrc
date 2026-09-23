## myvimrc

Configuration of below applications 

* GIT (global config of ignore)
* VIM  
* NVIM  
* VSCODE   

## Git

Install the global ignore configuration from the `GIT` folder:

```powershell
cd GIT
python install.py
```

The installer preserves existing entries and adds only missing ones.

## Note

* When you install VSCode configuration, you must install NVIM configuration beforehand.  

## Discussion (2026/09/23)

* `<leader>R` / `<leader>A`: Decide whether VS Code should use the same keys as Neovim for rename and code actions.
* `gD`: Decide whether to add the declaration-jump mapping to the regular Neovim LSP configuration for consistency.
* Completion: Consider `editor.suggestSelection: "first"` and `editor.tabCompletion: "on"` to align VS Code with blink.cmp.



