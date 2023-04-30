#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

sudo apt update
sudo apt install \
    git git-lfs \
    trash-cli \
    virtualenvwrapper \
    tree \
    neovim \
    zsh \
    gnome-tweaks \
    gnome-shell-extension-manager \
    gimp \
    # gnome-shell-system-monitor-next dependencies
    gir1.2-gtop-2.0 gir1.2-nm-1.0 gir1.2-clutter-1.0

