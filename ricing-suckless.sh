# suckless rice 
#
# themed around use of dwm, st, surf, dmenu
#

## pacstrap during iniital install
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
# wireless_tools  : wpa_supplicant and the like
# networkmanager  : trust me... you don't want to do wireless yourself
# xf86-video-intel: intel video drivers
# vim                : more than vi
# wget              : when curl doesn't cut it
# 
pacstrap -i /mnt base base-devel wireless_tools networkmanager \
    xf86-video-intel vim wget 

## post install packages
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
# calcurse        : cli calendar / curses based
# newsboat        : cli rss reader
# pulseaudio      : pulse audio drivers / server
# pulseaudio-alsa : pulse - alsa system
# arandr          : display handler
# pavucontrol     : gui for pulse
# pamixer         : pulse mixer
# mediainfo       : media meta data reader
# poppler         : pdf render library
# highlight       : fast and flexible source code highlighter
# mpd             : server-side application for playing music
# mpc             : cli interface for mpd
# imagemagick     : image manipulation program, screenshots through import
# atool           : compression handler
# libcaca         : cli visualizer library
# compton         : compositing suite for wm
# transset-df     : transparency handler
# mupdf           : pdf / xps viewer
# evince          : document viewer
# youtube-dl      : cli youtube downloader / can be used for many sites
# youtube-viewer  : viewer util
# pandoc          : document converter (very haskell heavy)
# python-dbus     : python dbus handler (forces python3 install)
# python-gobject  : python gtk handler
# blender         : 3d swiss army knife
# gimp            : basically close enough to photoshop
# transmission-cli: cli transmission... yeah 
# screenfetch     : little os cli printout
#
pacman --needed -Sy xorg-xinit xorg-server ttf-inconsolata rsync openvpn \
    openresolv git unzip unrar p7zip ntfs-3g exfat-utils dosfstools ranger \
    w3m htop feh ffmpeg mpv calcurse newsboat pulseaudio pulseaudio-alsa \
    arandr pavucontrol pamixer mediainfo poppler highlight mpd mpc \
    imagemagick atool libcaca compton transset-df mupdf evince youtube-dl \
    youtube-viewer pandoc python-dbus python-gobject blender gimp \
    transmission-cli screenfetch

## functions that will be needed for st, dwm, surf and lemonbar
#
# aurinstall is lukesmithxyz creation. many thanks, sir.
# aurget is my alteration, because sometimees you're going to want to alter
# the config.h before compiling.
#         + don't forget to updpkgsums after changing anything. other wise,
#           makepkg will complain.
#
aurinstall() { curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/$1.tar.gz \
    && tar -xvf $1.tar.gz && cd $1 && makepkg --noconfirm -si && cd .. \
    && rm -rf $1 $1.tar.gz ;}
aurget() { curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/$1.tar.gz \
    && tar -xvf $1.tar.gz && cd $1 ;}
