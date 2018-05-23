#!/bin/bash
# arch installer script
# by andrew
# works on Dell XPS 13 9360 as of [Insert Date]
# built for uefi - see bootctl
# assumes sda is the install location.
#
echo 'hi! can i get some details from you?'
echo -n '    user name: '
read username
echo -n '    computer name: '
read hostname
echo "okay, $username! i'll get $hostname setup for you."
echo -n '    may i begin (y/n)? '
read continue
if [ $continue == 'n' ]; then
	echo 'oh! okay, exiting. bye!'
	exit
fi
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
# --noconfirm is generally a bad idea, you should read everything
# ...do as i say, not as i do
pacstrap --noconfirm -i /mnt base base-devel wireless_tools wpa_supplicant \
    xf86-video-intel vim wget
genfstab -U /mnt >> /mnt/etc/fstab
#### might stop working with the next command... maybe...
arch-chroot /mnt
#### might need to break this script off here.
ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
hwclock --systohc --utc
# fuck it, i'll just append the locale.gen file...
echo "en_US.UTF-8 UTF-8  " >> /etc/locale.gen
echo "ja_JP.UTF-8 UTF-8  " >> /etc/locale.gen 
locale-gen
echo hostname >> /etc/hostname
echo "editing & making things..."
sleep 1
file=/mnt/archbox/etc/mkinitcpio.conf
search="^\s*HOOKS=.*$"
replace="HOOKS=\\\"base udev autodetect modconf block keymap encrypt lvm2 filesystems keyboard shutdown fsck usr\\\""
grep -q "$search" "$file" && sed -i "s#$search#$replace#" "$file" || echo "$replace" >> "$file"
mkinitcpio -p linux
echo "installing bootctl..."
bootctl --path=/boot install 
echo "default arch" >> /boot/loader/loader.conf
echo "timeout 0" >> /boot/loader/loader.conf
echo "editor 0" >> /boot/loader/loader.conf
datUUID=$(blkid | sed -n '/sda2/s/.*UUID=\"\([^\"]*\)\".*/\1/p')
touch /boot/loader/entries/arch.conf
echo "title Arch" >> /boot/loader/entries/arch.conf
echo "linux /vmlinuz-linux" >> /boot/loader/entries/arch.conf
echo "initrd /initramfs-linux.img" >> /boot/loader/entries/arch.conf
echo "options cryptdevice=UUID=$datUUID:lvm root=/dev/mapper/volume-root quiet rw" >> /boot/loader/entries/arch.conf
# add user
useradd -m -g wheel -s /bin/bash $username
echo "done..."
echo "bye. ∠(ᐛ 」∠)＿"
sleep 5
exit
umount -R /mnt
reboot
