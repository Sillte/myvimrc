# Repository purpose

This repository contains my personal development environment
configuration for Vim, Neovim, and VSCode.

The configuration is intended primarily for my own use.
Do not assume that every setting should be generalized for other users.
Do not optimize for generic best practices at the expense of familiarity.

# Structure

- VIM/   : Vim configuration
- NVIM/  : Neovim configuration
- VSCODE/: VSCode configuration
- OTHERS/: related environment configuration
- IMEOFFHOOKProject/: Using `無変換キー`, automatically set IME off. 

# Important principles

- Prefer small, understandable changes.
- Preserve existing behavior unless the requested change requires otherwise.
- Do not introduce abstractions merely for theoretical reuse.
- Consider compatibility with my existing Vim/Neovim/VSCode workflow.
- Before changing configuration, inspect nearby existing configuration.
- Avoid changing multiple editors at once unless explicitly requested.

# When proposing changes

Explain:
1. What the current configuration does.
2. What problem the proposed change solves.
3. Which files need to change.
4. Any compatibility or migration concerns.

When uncertain about my intended workflow, ask rather than inventing a new convention.
