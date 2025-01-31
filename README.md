# Dotfiles by Stephen Darling

## Setup

I'm using [stow](https://medium.com/quick-programming/managing-dotfiles-with-gnu-stow-9b04c155ebad) to symlink these dotfiles to my home directory.

```sh
# Install
brew install stow

# Add a package
stow -t ~/ -S <package-name>
```

Stow will maintain the directory structure beneath `<package-name>` while symlinking to your target directory

### Example with karabiner-elements

```sh
cd ~/dev/dotfiles                   # This workspace
stow -t ~/ -S karabiner-elements

ls -la ~/.config
> ...
> karabiner -> ../dev/dotfiles/karabiner-elements/.config/karabiner
> ...
```

## Package-specific setup

- [aerospace](https://nikitabobko.github.io/AeroSpace/guide)
- [sketchybar](https://github.com/FelixKratz/SketchyBar)
- [janky-borders](https://github.com/FelixKratz/JankyBorders)