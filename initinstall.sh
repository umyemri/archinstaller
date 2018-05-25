#!/bin/bash
# arch installer script
# by andrew
# works on Dell XPS 13 9360 as of [Insert Date]
# built for uefi - see bootctl
# assumes sda is the install location.
#
echo "partitioning drive..."
sleep 1
sgdisk -og /dev/sda
sgdisk -n 1:2048:+200MiB -t 1:ef00 /dev/sda
start_of=$(sgdisk -f /dev/sda)
end_of=$(sgdisk -E /dev/sda)
sgdisk -n 2:$start_of:$end_of -t 2:8e00 /dev/sda
sgdisk -p /dev/sda
echo "making luks lvm..."
sleep 1
cryptsetup luksFormat /dev/sda2
cryptsetup open --type luks /dev/sda2 lvm
pvcreate --dataalignment 1m /dev/mapper/lvm
vgcreate volume /dev/mapper/lvm
lvcreate -L 20GB volume -n root
lvcreate -L 12GB volume -n swap
lvcreate -l 100%FREE volume -n home
echo "activating lvm..."
sleep 1
modprobe dm_mod
vgscan
vgchange -ay
echo "formatting drives..."
sleep 1
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/volume/root
mkfs.ext4 /dev/volume/home
mkswap /dev/volume/swap
swapon /dev/volume/swap
echo "mounting drives..."
sleep 1
mount /dev/volume/root /mnt
mkdir /mnt/boot
mkdir /mnt/home
mount /dev/sda1 /mnt/boot
mount /dev/volume/home /mnt/home
echo "installing base system..."
sleep 1
pacstrap -i /mnt base base-devel wireless_tools wpa_supplicant \
xf86-video-intel vim wget
genfstab -U /mnt >> /mnt/etc/fstab
echo "done! use arch-chroot /mnt and run secondstage-install.sh"
exit
