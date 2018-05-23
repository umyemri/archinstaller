#!/bin/bash

# hardening arch
# mostly just getting sudo setup, some initial scripts, etc.
# 
#

## disk encryption
# should already be setup when installing - see install scripts

## remove root
# as root, remove comments from wheel for sudo use
passwd 
sudo passwd -l root

## edit wheel group
vim /etc/pam.d/su
vim /etc/pam.d/su-l
# Uncomment "wheel" group.
# auth		required	pam_wheel.so use_uid
# remove ssh login by root - PermitRootLogin no
vim /etc/ssh/sshd_config

## Mandatory access control
# [tbd]

## firewall setup
# [tbd]

## Kernel hardening
# [tbd]

## Sandboxing applications
# consider qubes
# [tbd]

## network setup
# don't use these, this makes netneg automatic, which is not secure
# there's probably someway to make these more secure. but i've been 
# working on some alternatives with basic wpa_supp and dhcpcd that
# work great for my purposes. vpn is mullvad openvpn/resolv. not
# a lot revealed here. just a bird's eye view of my process. probably
# release it in my dotfiles repo.
#
#systemctl enable NetworkManager
#systemctl start NetworkManager
#
# prep needs to occur before init net connections.
#   1. mac spoof
#   2. vpn iso setup
#   3. net con
#   4. vpn init
#   ?. net usage
#  x1. radio down
#  x2. dhcp purge
#
# merged these into a script for network handling (now part of .bashrc):
# alias wu = "sh ~/.config/scripts/network.sh wireless-up"
# alias wd = "sh ~/.config/scripts/network.sh wireless-down"
# alias eu = "sh ~/.config/scripts/network.sh ether-up"
# alias ed = "sh ~/.config/scripts/network.sh ether-down" # lol
#
