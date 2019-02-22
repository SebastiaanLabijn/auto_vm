#!/bin/sh

###
# Configure installation itself
###

# time and date
ln -sf /usr/share/zoneinfo/Europe/Brussels /etc/localtime
hwclock --systohc

# keyboards and language settings
locale-gen
echo 'KEYMAP=be-latin1' > /etc/vconsole.conf

# initrams
mkinitcpio -p linux

# Update Packages & mirrors
pacman -Syyu --noconfirm 

# Configure sudo
pacman -S sudo --noconfirm
echo '%wheel ALL=(ALL) ALL' >>  /etc/sudoers

# set root pwd
username="root"
user_pwd=$(openssl passwd -1 "arch")
usermod -p ${user_pwd} ${username}

# Create vagrant user
username="vagrant"
useradd ${username}
user_pwd=$(openssl passwd -1 "${username}")
usermod -p ${user_pwd} ${username}
usermod -aG wheel ${username}

# network & hosts
box_name="archvm"
echo "${box_name}" > /etc/hostname

echo '# Static table lookup for hostnames.' > /etc/hosts
echo '# See hosts(5) for details.' >> /etc/hosts
echo '#' >> /etc/hosts
echo -e "127.0.0.1\tlocalhost" >> /etc/hosts
echo -e "::1\t\tlocalhost" >> /etc/hosts
echo -e "127.0.1.1\t${box_name}.localdomain ${box_name}" >> /etc/hosts

systemctl enable dhcpcd
systemctl start dhcpcd

pacman -S openssh --noconfirm
systemctl enable sshd
systemctl start sshd

# bootloader
pacman -S grub os-prober --noconfirm
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
