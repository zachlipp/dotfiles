# dotfiles

Personal configuration.

The repo is laid out as [GNU Stow](https://www.gnu.org/software/stow/) packages — each
top-level directory mirrors the paths it should occupy under `$HOME`.

## What's in here

- [`claude -> ~/.claude`](claude)
- [`neovim -> ~/.config/nvim`](neovim) (This has its own [`README`](neovim/.config/nvim/README.md))
- [`starship -> ~/.config/starship.toml`](starship)
- [`zsh -> ~/.zshrc + ~/.aliases.zsh`](zsh)
- [`vale -> ~/.vale.ini`](vale)
- [`not_stowed`](not_stowed): You're not going to believe this - this is configuration I do not manage with GNU Stow.

## Installing on a new machine

```bash
git clone https://github.com/zachlipp/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow zsh neovim starship claude vale
```

Then we have the `not_stowed` files:

```sh
# macOS system preferences (some changes need a logout to take effect)
sh macos/.macos

# Vale style packages, downloaded into ~/styles per StylesPath
vale sync
