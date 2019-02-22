#!/bin/bash

###
# Installing base system
###

# configure time & date
timedatectl set-ntp true

# configure hdds
( echo "o"; echo "n"; echo "p"; echo "1"; echo ""; echo ""; echo "w" ) | fdisk /dev/sda
mkfs.ext4 /dev/sda1

# install base system and developer packages
mount /dev/sda1 /mnt
pacstrap /mnt base base-devel

genfstab -U /mnt >> /mnt/etc/fstab

# move configure script to right folder
config_script="config_arch.sh"
mv "${config_script}" /mnt/root
chmod 776 "/mnt/root/${config_script}"
# Chroot into new installation and execute the config script there
arch-chroot /mnt /root/"${config_script}"

# Finish installation
poweroff
