# suckless rice 
# =====
# themed around use of dwm, st, surf, dmenu
#
## pacstrap during initial install
#
# previously in the init script, we installed the following:
#     $ pacstrap -i /mnt base base-devel wireless_tools wpa_supplicant \
#     $     xf86-video-intel vim wget
#   
# base contains: bash bzip2 coreutils cryptsetup device-mapper dhcpcd diffutils
#  e2fsprogs file filesystem findutils gawk gcc-libs gettext glibc grep gzip
#  inetutils iproute2 iputils jfsutils less licenses linux logrotate lvm2 
#  man-db man-pages mdadm nano netctl pacman pciutils pcmciautils perl
#  procps-ng psmisc reiserfsprogs s-nail s-nail sed shadow sysfsutils 
#  systemd-sysvcompat systemd-sysvcompat tar texinfo usbutils util-linux 
#  util-linux vi which xfsprogs
#
# base-devel contains: autoconf automake binutils bison fakeroot file findutils
#  flex gawk gcc gettext grep groff gzip libtool m4 make pacman patch
#  pkg-config sed sudo systemd texinfo util-linux which
#
# wireless_tools  : basic wireless programs
# wpa_supplicant  : tool set for dealing with WPA com
# --networkmanager--  : trust me... you don't want to do wireless yourself
#  *Edit: that's bullshit it seems. dhcpcd, wpa_supplicant work just fine
#  on their own. Scripted an easy solution where nm isn't required in the 
#  slightest. use wpa_passphrase to generate a config.
# xf86-video-intel: intel video drivers
# vim             : more than vi
# wget            : when curl doesn't cut it, recursively
# 

## post install packages - the basics
#
# xorg-xinit      : xorg initialization system
# xorg-server     : xorg server... yeah
# ttf-inconsolata : nice font
# rsync           : backup util
# openvpn         : vpn all the things
# openresolv      : resolve all the dns'
# git             : git tools for duplicating / diff tracking source
# unzip           : compression utils for zip
# unrar           : compression utils for rar
# p7zip           : compression utils for 7z/others
# ntfs-3g         : file system handler for ntfs
# exfat-utils     : file system handler for exfat
# dosfstools      : file system handler for fat16/32
# ranger          : cli file navigator
# w3m             : cli web browser
# htop            : cli resource manager
# feh             : minimal image viewer
# ffmpeg          : video/audio swiss army knife
# mpv             : minimal video player
# newsboat        : cli rss reader
# arandr          : display handler
# mediainfo       : media meta data reader
# poppler         : pdf render library
# highlight       : fast and flexible source code highlighter
# imagemagick     : image manipulation program, screenshots through import
# atool           : compression handler
# compton         : compositing suite for wm
# transset-df     : transparency handler
# xorg-xbacklight : backlight handling
# mupdf           : pdf / xps viewer
# evince          : document viewer
# youtube-dl      : cli youtube downloader / can be used for many sites...
# screenfetch     : little os cli printout
# dmenu           : for dwm 
#
sudo pacman --needed -Sy xorg-xinit xorg-server ttf-inconsolata rsync openvpn \
    openresolv git unzip unrar p7zip ntfs-3g exfat-utils dosfstools ranger \
    w3m htop feh ffmpeg mpv newsboat arandr mediainfo poppler highlight \
    imagemagick atool compton transset-df xorg-xbacklight mupdf evince \
    youtube-dl screenfetch dmenu
## functions that will be needed for st, dwm, surf and lemonbar
#
# aurinstall is lukesmithxyz creation. many thanks, sir.
# aurget is my alteration, because sometimees you're going to want to alter
# the config.h before compiling.
#         + don't forget to updpkgsums after changing anything. other wise,
#           makepkg will complain.
# this is all posted to the .bashrc file for usage with suckless libraries
#
# aurinstall : lukesmithxyz function, i've found useful.
# aurget     : a modification on the above to pause install so you can edit them
#
# get you packages ready, you'll need to edit their config.h files to your liking
# or... you could just accept them as is with aurinstall. it won't look pretty...
#
# if i have to explain the suckless group, why are you even using this script?
# https://suckless.org if you are still confused
#
# ttf-monapo & anthy-kaomoji are a font and input method for japanese.
# apulse is a lean pulse emulation. pretty slick!
#
# suckless=('dwm' 'st' 'surf')
# miscaur=('lemonbar-git' 'ttf-monapo' 'anthy-kaomoji' 'apulse')
#
echo "aurinstall() { curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/\$1.tar.gz \\" >> .bashrc
echo "    && tar -xvf \$1.tar.gz && cd \$1 && makepkg --noconfirm -si && cd .. \\" >> .bashrc
echo "    && rm -rf \$1 \$1.tar.gz ;}" >> .bashrc
echo "aurget() { curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/\$1.tar.gz \\" >> .bashrc
echo "    && tar -xvf \$1.tar.gz ;}" >> .bashrc
# =====
# [uncomment the following commands if you want these features]
# =====
## huge / misc applications
#
# blender and gimp are large applications. if you're trying to run a lean
# system, maybe you don't want to install them. and pandoc installs every
# god damn haskell lib on the planet. maybe you want to install those 
# later...
#
# blender         : 3d swiss army knife
# gimp / krita    : basically close enough to photoshop
# pandoc          : document converter (very haskell heavy)
# python          : python 3, my swissarmy knife
# r               : statistical modeling programming language, and great calculator
# firefox         : well... you might not want this. i use qute and waterfox
#
# sudo pacman --needed -S blender gimp krita pandoc python r firefox
## japanese support characters
#
# You might be wondering why I'm mentioning japanese at all: I translate manga
# on the side. This is just features I want. Feel free to remove this section
# if you want.
#
# bdf-unifont     : bitmap font that covers japanese characters
# uim             : multilingual input
#
# sudo pacman --needed -S uim bdf-unifont 
exit
