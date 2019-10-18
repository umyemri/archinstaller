#!/bin/bash
#
# arch installer script
# by andrew
# 
# part 1: disks
# part 2: formatting drives
# part 3: base install
# part 4: system config
#

packages = "base linux linux-firmware nvidia"

# part 1: disks
#===================================================================================================
# user inputs: get desired swap size
echo "yes-hello-hi! can i get some details from you?"
echo -n "  user name: "
read username
echo -n "  computer name: "
read hostname
echo -n "  swap size (GiB): "
read swap_size
echo "okay, $username! i'll get $hostname setup for you with a swap size of $swap_sizeGiB."
echo -n "  may i begin (y/n)? "
read continue
if [ $continue == 'n' ]; then
	echo 'oh! okay, exiting. bye!'
	exit
fi

echo -e "\'kay.\npartitioning drives...\n"
sleep 1

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
sleep 2

# part 2: formatting drives
#===================================================================================================
echo -e "\nformatting drives...\n"
sleep 1
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda3
mkfs.ext4 /dev/sdb1
mkswap /dev/sda2
swapon /dev/sda2

echo -e "\nmounting drives...\n"
sleep 1
mount /dev/sda3 /mnt
mkdir /mnt/boot
mkdir /mnt/home
mount /dev/sda1 /mnt/boot
mount /dev/sdb1 /mnt/home

# part 3: base install
#===================================================================================================
echo -e "\ninstalling base system...\n"
sleep 1
# i like wireguard. maybe you don't. /shrug
pacstrap -i /mnt $packages

# part 4: system config
#===================================================================================================
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

echo -e "\nediting & making things...\n"
ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
hwclock --systohc --utc
echo "en_US.UTF-8 UTF-8  " >> /etc/locale.gen
echo "ja_JP.UTF-8 UTF-8  " >> /etc/locale.gen 
locale-gen
mkinitcpio -p linux

echo -e "\ninstalling bootctl...\n"
bootctl --path=/boot install 
echo "default arch" > /boot/loader/loader.conf
echo "timeout 0" >> /boot/loader/loader.conf
echo "editor 0" >> /boot/loader/loader.conf
datUUID=$(blkid | sed -n '/sda3/s/.*UUID=\"\([^\"]*\)\".*/\1/p')
touch /boot/loader/entries/arch.conf
echo "title Arch" >> /boot/loader/entries/arch.conf
echo "linux /vmlinuz-linux" >> /boot/loader/entries/arch.conf
echo "initrd /initramfs-linux.img" >> /boot/loader/entries/arch.conf
echo "options device=UUID=$datUUID root=/dev/sda3 quiet rw" >> /boot/loader/entries/arch.conf

# add user
echo hostname >> /etc/hostname
useradd -m -g wheel -s /bin/bash $username
passwd $username

# exodus
echo "done!"
echo -e "You should run visudo, setup wheel and invalidate root\'s password."
echo "bye. ∠(ᐛ 」∠)＿"
