# archinstaller
***To the one guy who forked this project (@Tw333x)*** : this is by no means a finished product. Watch out! 

Just a place for my installer scripts.

Came from me having to reinstall a system over and over after screwing something up.

Designed to work on a Dell XPS 13 9360 (aka kunkun).

Takes some pointers from https://github.com/LukeSmithxyz/LARBS but ultimately this is designed so I make my own solutions.

## Basic Features
* Full Luks LVM2 Disk Encryption - only for theft deterrent: https://en.wikipedia.org/wiki/Plausible_deniability
* bootctl for EFI Loader

## Guide
1. Use initinstall.sh to get the system setup
2. Use hardening.sh to get the system to not rip itself apart and needlessly expose itself to passersby. #shame!
3. Use rising.sh to put on some makeup.

## References
* https://wiki.archlinux.org/index.php/Installation_guide
* https://wiki.archlinux.org/index.php/Systemd-boot
* https://wiki.archlinux.org/index.php/LVM
* https://wiki.archlinux.org/index.php/Disk_encryption
