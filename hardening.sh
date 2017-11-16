#!/bin/bash

# hardening arch
# mostly just getting sudo setup, some initial scripts, etc.

# sudo
pacman -Sy sudo
# edit /etc/sudoers

# add user
useradd -m -g wheel -s /bin/bash lim

# fstab for sdds

# lock root
passwd -l root
exit
