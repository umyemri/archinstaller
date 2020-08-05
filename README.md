# archinstaller
Just a place for my installer scripts. Makes things faster for me. Installs in about 7 minutes - depending on the connection speed.

Came from me having to reinstall a system over and over after screwing something up.

Designed to work on a Dell XPS 13 9360 (aka kunkun).

## Basic Features
* Partial Luks LVM2 Disk Encryption (/boot left unencrypted, I'll address full disk at a later date) - only as a theft deterrent: https://en.wikipedia.org/wiki/Plausible_deniability
* bootctl for EFI Loader

## Guide
1. Use either install-simple.sh or install-encrypt.sh to get the system setup
2. [draft] Use hardening.sh to get the system to not rip itself apart and needlessly expose itself to passersby. #shame!

## References
* https://wiki.archlinux.org/index.php/Installation_guide
* https://wiki.archlinux.org/index.php/Systemd-boot
* https://wiki.archlinux.org/index.php/LVM
* https://wiki.archlinux.org/index.php/Disk_encryption
