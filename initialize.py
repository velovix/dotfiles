#!/usr/bin/env python3

from pathlib import Path
import os

def symlink(src: Path, dest: Path):
    if dest.exists():
        print(f"Warning: Path {dest} already exists, not symlinking")
    else:
        os.symlink(src, dest)
        print(f"Symlinked {src} to {dest}")

config_src = Path.cwd() / "xdg-config-home"

config_dest = Path.home() / ".config"
config_dest.mkdir(exist_ok=True)

symlink(config_src / "nvim", config_dest / "nvim")
symlink(config_src / "awesome", config_dest / "awesome")
symlink(config_src / "compton.conf", config_dest / "compton.conf")
symlink(config_src / "kitty", config_dest / "kitty")
symlink(config_src / "lxterminal", config_dest / "lxterminal")
symlink(config_src / "pacman", config_dest / "pacman")
symlink(config_src / "rofi", config_dest / "rofi")
symlink(Path.cwd() / "sh", Path.home() / "sh")
symlink(Path.cwd() / "zshrc", Path.home() / ".zshrc")
symlink(Path.cwd() / "direnvrc", Path.home() / ".direnvrc")
symlink(Path.cwd() / "desktop-files" / "nvim-qt.desktop",
        Path.home() / ".local" / "share" / "applications" / "nvim-qt.desktop")

