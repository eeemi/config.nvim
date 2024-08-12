#!/bin/bash

# remove lazy plugins
rm -rfv ~/.local/share/nvim/lazy
rm -rfv ~/.local/state/nvim/lazy
rm -rfv ~/.config/nvim/lazy-lock.json

# remove plugin related data
rm -rfv ~/.local/share/nvim

# remove config/kickstart
rm -rfv ~/.config/nvim/


# remove neovim (comment out next row if binary is kept)
# sudo rm -rfv /opt/nvim


