#!/bin/bash

# arch installer script
# by andrew
# works on Dell XPS 13 9360 as of 2017/11/15

echo "partitioning drive..."
sleep 2
sgdisk -og /dev/sda
sgdisk -n 1:2048:+512MiB -t 1:ef00 /dev/sda
start_of='sgdisk -f /dev/sda'
end_of='sgdisk -E /dev/sda'
sgdisk -n 2:$start_of:$end_of -t 2:8e00 /dev/sda
sgdisk -p /dev/sda

echo "making luks lvm..."
sleep 2
cryptsetup luksFormat /dev/sda2
cryptsetup open --type luks /dev/sda2 lvm
pvcreate --dataalignment 1m /dev/mapper/lvm
vgcreate volume /dev/mapper/lvm
lvcreate -L 30GB volume -n root
lvcreate -L 16GB volume -n swap
lvcreate -l 100%FREE volume -n home

echo "activating lvm..."
sleep 2
modprobe dm_mod
vgscan
vgchange -ay

echo "formatting drives..."
sleep 2
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/volume/root
mkfs.ext4 /dev/volume/home
mkswap /dev/volume/swap
swapon /dev/volume/swap

echo "mounting drives..."
sleep 2
mount /dev/volume/root /mnt
mkdir /mnt/boot
mkdir /mnt/home
mount /dev/sda1 /mnt/boot
mount /dev/volume/home /mnt/home

echo "installing base system..."
sleep 2
pacstrap -i /mnt base
genfstab -U /mnt >> /mnt/etc/fstab
# might stop working with the next command... maybe...
arch-chroot /mnt
ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
hwclock --systohc --utc
locale-gen
echo "kunkun" >> /etc/hostname #name this whatever you like

echo "editing & making things..."
sleep 2
file=/mnt/archbox/etc/mkinitcpio.conf
search="^\s*HOOKS=.*$"
replace="HOOKS=\\\"base udev autodetect modconf block keymap encrypt lvm2 filesystems keyboard shutdown fsck usr\\\""
grep -q "$search" "$file" && sed -i "s#$search#$replace#" "$file" || echo "$replace" >> "$file"
mkinitcpio -p linux

echo "installing bootctl..."
bootctl --path=/boot install
> /boot/loader/loader.conf
echo "default arch" >> /boot/loader/loader.conf
echo "timeout 0" >> /boot/loader/loader.conf
echo "editor 0" >> /boot/loader/loader.conf
datUUID=blkid | sed -n '/sda2/s/.*UUID=\"\([^\"]*\)\".*/\1/p'
touch /boot/loader/entries/arch.conf
echo "title Arch" >> /boot/loader/entries/arch.conf
echo "linux /vmlinuz-linux" >> /boot/loader/entries/arch.conf
echo "initrd /initramfs-linux.img" >> /boot/loader/entries/arch.conf
echo "options cryptdevice=UUID=$datUUID:lvm root=/dev/mapper/volume-root quiet rw" >> /boot/loader/entries/arch.conf

echo "done..."
echo "use passwd for root then restart. bye. ∠(ᐛ 」∠)＿"
