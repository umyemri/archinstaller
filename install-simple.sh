#!/bin/bash
# title: archinstaller - simple version
# author: andrew
# aim: a minimal version of my encryption app
# last working run: [tbd]
# notes:
#   - assumes sda will be a /root /swap disk
#      - sdb /home
#      - and you have a connection to the internet
# 
# part 1: disks
# part 2: formatting drives
# part 3: base install
# part 4: system config
#

packages="base linux linux-firmware"

# part 1: disks
#===================================================================================================
echo '\(OoO)/ OH!!'
sleep 1
echo 'yes-hello-hi! i am kit. can i get some details from you?'
echo -n '  user name: '
read username
echo -n '  computer name: '
read hostname
echo -n "  swap size (GiB): "
read swap_size
echo "okay, $username! i'll get $hostname setup for you with a swap size of $swap_sizeGiB."
echo -n '  may i begin (y/n)? '
read continue
if [ $continue == 'n' ]; then
	echo 'oh! okay, exiting. bye!'
	echo '(._. )...'
	exit
fi
echo '(-u-)\ k! on it!'
sleep 2

echo -e "\npartitioning drives...\n"
# first drive: boot partition
sgdisk -og /dev/sda # -og will clears partition table and sets it to gpt
sgdisk -n 1:2048:+500MiB -t 1:ef00 /dev/sda # assumes we'll be using a uefi

# make swap 
start_of=$(sgdisk -f /dev/sda)
sgdisk -n 2:$start_of:+$swap_sizeGiB -t 2:8200 /dev/sda

# make root: using all space since i have another drive for home
start_of=$(sgdisk -f /dev/sda)
end_of=$(sgdisk -E /dev/sda)
sgdisk -n 3:$start_of:$end_of -t 3:8300 /dev/sda

# make home
sgdisk -og /dev/sdb
start_of=$(sgdisk -f /dev/sdb)
end_of=$(sgdisk -E /dev/sdb)
sgdisk -n 1:$start_of:$end_of -t 1:8300 /dev/sdb

# overview
sgdisk -p /dev/sda
sgdisk -p /dev/sdb


# part 2: formatting drives
#===================================================================================================
echo -e "\nformatting drives...\n"
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda3
mkfs.ext4 /dev/sdb1
mkswap /dev/sda2
swapon /dev/sda2

echo -e "\nmounting drives...\n"
mount /dev/sda3 /mnt
mkdir /mnt/boot
mkdir /mnt/home
mount /dev/sda1 /mnt/boot
mount /dev/sdb1 /mnt/home

# part 3: base install
#===================================================================================================
echo -e "\ninstalling base system...\n"
pacstrap -i /mnt $packages

# part 4: system config
#===================================================================================================
echo -e "\nediting & making things...\n"
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
arch-chroot /mnt hwclock --systohc --utc
# fuck it, i'll just append the locale.gen file...
echo "en_US.UTF-8 UTF-8  " >> /mnt/etc/locale.gen
echo "ja_JP.UTF-8 UTF-8  " >> /mnt/etc/locale.gen
arch-chroot /mnt locale-gen
echo $hostname >> /mnt/etc/hostname
# no need mkinitcpio now... crazy

echo "installing bootctl..."
#===============================================================================
echo -e "\ninstalling bootctl...\n"
bootctl --path=/boot install 
echo "default arch" > /boot/loader/loader.conf
echo "timeout 0" >> /boot/loader/loader.conf
echo "editor 0" >> /boot/loader/loader.conf
datUUID=$(blkid | sed -n '/sda3/s/.* UUID=\"\([^\"]*\)\".*/\1/p')
touch /boot/loader/entries/arch.conf
echo "title Arch" >> /boot/loader/entries/arch.conf
echo "linux /vmlinuz-linux" >> /boot/loader/entries/arch.conf
echo "initrd /initramfs-linux.img" >> /boot/loader/entries/arch.conf
echo "options device=UUID=$datUUID root=/dev/sda3 quiet rw" >> /boot/loader/entries/arch.conf

#===============================================================================
arch-chroot /mnt useradd -m -g wheel -s /bin/bash $username
arch-chroot /mnt passwd $username
echo "done..."
echo "you should do visudo and also disable root\' password."
echo "bye. (^o^)//"

# seriously, use arch-chroot /mnt visudo
# otherwise strange things are needed to update things.
# strange... things... (=_= )
