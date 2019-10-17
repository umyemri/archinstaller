# archinstaller
***To the one guy who forked this project (@Tw333x)*** : this is by no means a finished product. Watch out! 

Just a place for my installer scripts.

Came from me having to reinstall a system over and over after screwing something up.

Designed to work on a Dell XPS 13 9360 (aka kunkun).

Takes some pointers from @LukeSmithxyz LARBS: https://github.com/LukeSmithxyz/LARBS, but ultimately this is designed so I make my own solutions.

## Basic Features
* Partial Luks LVM2 Disk Encryption (/boot left unencrypted, I'll address full disk at a later date) - only as a theft deterrent: https://en.wikipedia.org/wiki/Plausible_deniability
* bootctl for EFI Loader
* two flavors for wm:
  * i3-gaps - basically took @lukesmithxyz LARBS as a template, used it as a tutorial in some ways.
  * suckless combination (dwm, st, lemonbar) - heavily inspired by @MitchWeaver r/unixporn posts and git repos. love his work!
* [draft] japanese input through uim / anthy.

## Guide
1. Use either install-simple.sh or install-encrypt.sh to get the system setup
2. [draft] Use hardening.sh to get the system to not rip itself apart and needlessly expose itself to passersby. #shame!
3. Use payload-XXXX.sh post install to put on some makeup.

## References
* https://wiki.archlinux.org/index.php/Installation_guide
* https://wiki.archlinux.org/index.php/Systemd-boot
* https://wiki.archlinux.org/index.php/LVM
* https://wiki.archlinux.org/index.php/Disk_encryption
