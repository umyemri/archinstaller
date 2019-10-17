#!/bin/bash
# arch installer script
# by andrew
# works on Dell XPS 13 9360 as of [Insert Date]
# built for uefi - see bootctl
# assumes sda is the install location and you have a connection to the internet
#

# feel free to add or remove what you wish
packages = "base base-devel linux linux-firmware linux-headers mkinitcpio lvm2 \
wireless_tools wpa_supplicant libmnl wireguard-dkms wireguard-tools \
wireguard-arch openresolv macchanger xf86-video-intel neovim tmux python \
python-pip"

echo 'yes-hello-hi! can i get some details from you?'
echo -n '  user name: '
read username
echo -n '  computer name: '
read hostname
echo "okay, $username! i'll get $hostname setup for you."
echo -n '  may i begin (y/n)? '
read continue
if [ $continue == 'n' ]; then
	echo 'oh! okay, exiting. bye!'
	exit
fi
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
mkdir /mnt/boot
mkdir /mnt/home
mount /dev/sda1 /mnt/boot
mount /dev/volume/home /mnt/home

echo "installing base system..."
#===============================================================================
pacstrap -i /mnt $packages
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

echo "initial local value setup..."
#===============================================================================
ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
hwclock --systohc --utc
# fuck it, i'll just append the locale.gen file...
echo "en_US.UTF-8 UTF-8  " >> /etc/locale.gen
echo "ja_JP.UTF-8 UTF-8  " >> /etc/locale.gen
locale-gen
echo $hostname >> /etc/hostname

echo "editing & making things..."
#===============================================================================
file="/etc/mkinitcpio.conf"
search="^\s*HOOKS=.*$"
replace="HOOKS=\\\"base udev autodetect modconf block keymap encrypt lvm2 filesystems keyboard shutdown fsck usr\\\""
grep -q "$search" "$file" && sed -i "s#$search#$replace#" "$file" || echo "$replace" >> "$file"
mkinitcpio -p linux

echo "installing bootctl..."
#===============================================================================
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

#===============================================================================
useradd -m -g wheel -s /bin/bash $username
passwd $username
# copying my dot files, you might have other priorities at this point
# echo ". ~/.aliases" >> /home/$username/.bashrc
# wget -O /home/$username/.aliases https://raw.githubusercontent.com/umyemri/archinstaller/master/dot/.aliases
# wget -O /home/$username/.xinitrc https://raw.githubusercontent.com/umyemri/archinstaller/master/dot/.xinitrc
# wget -O /home/$username/.Xresources https://raw.githubusercontent.com/umyemri/archinstaller/master/dot/.Xresources
echo "done..."
echo "you should do visudo and also disable root\' password."
echo "bye. ∠(ᐛ 」∠)＿"
exit
