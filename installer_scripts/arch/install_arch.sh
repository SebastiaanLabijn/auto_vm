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
# pass paramters along in this order: os_root_pwd, os_user_vagrant, os_user_name, os_user_pwd, os_user_admin
arch-chroot /mnt "/root/${config_script} $1 $2 $3 $4 $5"
# Finish installation
poweroff
