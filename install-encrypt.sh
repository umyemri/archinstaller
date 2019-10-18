#!/bin/bash
# arch installer script
# by andrew
# works on Dell XPS 13 9360 as of 2019-10-17
# built for uefi - see bootctl
# assumes sda is the install location and you have a connection to the internet
#
# this script works. for now. i will update it when it fails. just let me know.
#

# feel free to add or remove what you wish
## base
packages="base base-devel linux-hardened linux-hardened-docs linux-hardened-headers linux-firmware mkinitcpio lvm2"
## networking
packages+=" wireless_tools wpa_supplicant wireguard-dkms wireguard-tools openresolv dhcpcd macchanger"
## misc
packages+=" xf86-video-intel vim tmux python python-pip"

echo '\(OoO)/ OH!!'
echo 'yes-hello-hi! i am kit. can i get some details from you?'
echo -n '  user name: '
read username
echo -n '  computer name: '
read hostname
echo "okay, $username! i'll get $hostname setup for you."
echo -n '  may i begin (y/n)? '
read continue
if [ $continue == 'n' ]; then
	echo 'oh! okay, exiting. bye!'
	echo '(._. )...'
	exit
fi
echo '(-u-)\ k! on it!'
sleep 2

echo "partitioning drive..."
#===============================================================================
sgdisk -og /dev/sda
sgdisk -n 1:2048:+200MiB -t 1:ef00 /dev/sda
start_of=$(sgdisk -f /dev/sda)
end_of=$(sgdisk -E /dev/sda)
sgdisk -n 2:$start_of:$end_of -t 2:8e00 /dev/sda
sgdisk -p /dev/sda

echo "making luks lvm..."
#===============================================================================
cryptsetup luksFormat /dev/sda2
cryptsetup open --type luks /dev/sda2 lvm
pvcreate --dataalignment 1m /dev/mapper/lvm
vgcreate volume /dev/mapper/lvm
lvcreate -L 20GB volume -n root
lvcreate -L 12GB volume -n swap
lvcreate -l 100%FREE volume -n home

echo "activating lvm..."
#===============================================================================
modprobe dm_mod
vgscan
vgchange -ay

echo "formatting drives..."
#===============================================================================
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/volume/root
mkfs.ext4 /dev/volume/home
mkswap /dev/volume/swap
swapon /dev/volume/swap

echo "mounting drives..."
#===============================================================================
mount /dev/volume/root /mnt
mkdir /mnt/{boot,home}
mount /dev/sda1 /mnt/boot
mount /dev/volume/home /mnt/home

echo "installing base system..."
#===============================================================================
pacstrap -i /mnt $packages
genfstab -U /mnt >> /mnt/etc/fstab

echo "initial local value setup..."
#===============================================================================
arch-chroot /mnt ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
arch-chroot /mnt hwclock --systohc --utc
# fuck it, i'll just append the locale.gen file...
echo "en_US.UTF-8 UTF-8  " >> /mnt/etc/locale.gen
echo "ja_JP.UTF-8 UTF-8  " >> /mnt/etc/locale.gen
arch-chroot /mnt locale-gen
echo $hostname >> /mnt/etc/hostname

echo "editing & making things..."
#===============================================================================
file="/mnt/etc/mkinitcpio.conf"
search="^\s*HOOKS=.*$"
replace="HOOKS=\\\"base udev autodetect modconf block keymap encrypt lvm2 filesystems keyboard shutdown fsck usr\\\""
grep -q "$search" "$file" && sed -i "s#$search#$replace#" "$file" || echo "$replace" >> "$file"
arch-chroot /mnt mkinitcpio -p linux

echo "installing bootctl..."
#===============================================================================
arch-chroot /mnt bootctl --path=/boot install
echo "default arch" > /mnt/boot/loader/loader.conf
echo "timeout 0" >> /mnt/boot/loader/loader.conf
echo "editor 0" >> /mnt/boot/loader/loader.conf
datUUID=$(blkid | sed -n '/sda2/s/.* UUID=\"\([^\"]*\)\".*/\1/p')
touch /mnt/boot/loader/entries/arch.conf
echo "title Arch" > /mnt/boot/loader/entries/arch.conf
echo "linux /vmlinuz-linux" >> /mnt/boot/loader/entries/arch.conf
echo "initrd /initramfs-linux.img" >> /mnt/boot/loader/entries/arch.conf
echo "options cryptdevice=UUID=$datUUID:lvm root=/dev/mapper/volume-root quiet rw" >> /mnt/boot/loader/entries/arch.conf

#===============================================================================
arch-chroot /mnt useradd -m -g wheel -s /bin/bash $username
arch-chroot /mnt passwd $username
echo "done..."
echo "you should do visudo and also disable root\' password."
echo "bye. (^o^)//"

# seriously, use arch-chroot /mnt visudo
# otherwise strange things are needed to update things.
# strange... things... (=_= )
