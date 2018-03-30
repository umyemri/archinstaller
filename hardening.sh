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
# strike these, this makes automatic netneg, which is not secure
# prep needs to occur before init net connections.
#   1. mac spoof
#   2. vpn iso setup
#   3. net con
#   4. vpn init
#   ?. net usage
#   e. radio down
#systemctl enable NetworkManager
#systemctl start NetworkManager

# add these to .bashrc
alias mw = "sh .config/scripts/mac-wireless.sh"
alias me = "sh .config/scripts/mac-ether.sh"
alias vu = "sh .config/scripts/vpn-up.sh"
alias vd = "sh .config/scripts/vpn-down.sh"
# consider merging v*/w*
alias wu = "sh .config/scripts/wireless-up.sh"
alias wd = "sh .config/scripts/wireless-down.sh"
