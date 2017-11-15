#!/bin/bash

# ricing
# getting all that sweet ui shiz. Lot of this is based on @LukeSmithXYZ's LARBS - https://github.com/LukeSmithxyz/LARBS

# don't look at this! I'm just dumping this in.
pacman --noconfirm --needed -Sy 

# Essentials...
essent="base-devel sudo wireless_tools network-manager-applet networkmanager rsync git unzip unrar ntfs-3g wget tmux vim w3m dosfstools htop"

# Nice to have...
nice="xorg-xinit xorg-server rxvt-unicode xf86-video-intel noto-fonts feh ffmpeg pulseaudio pulseaudio-alsa arandr pavucontrol pamixer mpv rofi ranger mediainfo poppler highlight calcurse newsboat mpd mpc ncmpcpp imagemagick atool libcaca compton transset-df markdown mupdf evince youtube-dl youtube-viewer cups scrot offlineimap msmtp notmuch notmuch-mutt r pandoc python-dbus python-gobject transmission-cli projectm-pulseaudio cmatrix asciiquarium screenfetch"

# LaTeX...
latex="texlive-most texlive-lang biber"

# Big apps...
bigens="blender gimp"

gpg --recv-keys 5FAF0A6EE7371805 #Add the needed gpg key for neomutt

aurinstall() { curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/$1.tar.gz && tar -xvf $1.tar.gz && cd $1 && makepkg --noconfirm -si && cd .. && rm -rf $1 $1.tar.gz ;}

aurcheck packer i3-gaps vim-pathogen tamzen-font-git neomutt unclutter-xfixes-git urxvt-resize-font-git polybar python-pywal xfce-theme-blackbird fzf-git
sudo pacman -S --noconfirm --needed i3lock
