#!/bin/bash
# payload: lots of tools to install / some setup
#

# copying my dot files, you might have other priorities at this point
echo ". ~/.aliases" >> ~/.bashrc
githubuser = "umyemri"
site = "https://raw.githubusercontent.com/$githubuser/archinstaller/master/dot/"
# curl -sL $site.aliases > ~/.aliases
# curl -sL $site.xinitrc > ~/.xinitrc
# curl -sL $site.Xresources > ~/.Xresources
# wget -O ~/.aliases $site.aliases
# wget -O ~/.xinitrc $site.xinitrc
# wget -O ~/.Xresources $site.Xresources

mkdir ~/{docs/{stories,articles,books},vids,pics,data,.config/scripts,tools,games}

packs = "unzip unrar p7zip ntfs-3g dosfstools exfat-utils htop xorg-xinit xorg-server \
rxvt-unicode noto-fonts noto-fonts-cjk noto-fonts-emoji feh ffmpeg arandr pulseaudio \
pamixer mpv ranger mediainfo poppler highlight calcurse newsboat cmus atool compton \
transset-df markdown mupdf evince youtube-dl screenfetch uim anthy blender krita \
firefox sigil inkscape i3-gaps"

pin $packs
