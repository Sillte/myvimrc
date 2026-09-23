## Git global ignore

Install the shared global ignore file with:

```powershell
uv run python install.py
```

The installer appends missing entries to `$XDG_CONFIG_HOME/git/ignore`, or to
`$HOME/.config/git/ignore` when `XDG_CONFIG_HOME` is unset or empty. Git reads
this default path automatically. It is safe to run repeatedly.
