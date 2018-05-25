#!/bin/bash
echo 'yes-hello-hi! can i get some details from you?'
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
exit
