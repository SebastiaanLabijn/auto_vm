#!/bin/sh

###
# Configure installation itself
###

# caputre passed script arguments
os_root_pwd="$1"
os_user_vagrant="$2"
os_user_name="$3"
os_user_pwd="$4"

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
user_pwd=$(openssl passwd -1 "${os_root_pwd}")
usermod -p ${user_pwd} ${username}

# Create user
username="${os_user_name}"
# Create vagrant user
if [ ! -z "${username}" -and "${username}" != "" ]
then
	useradd ${username}
	user_pwd=$(openssl passwd -1 "${os_user_pwd}")
	usermod -p ${user_pwd} ${username}
	# add to wheel group if needed
	if [ "${os_user_admin}" -eq "1" ]
	then
		usermod -aG wheel ${username}
	fi
fi

# Create vagrant user
if [ "${os_user_vagrant}" -eq "1" ]
then
	username="vagrant"
	useradd ${username}
	user_pwd=$(openssl passwd -1 "${username}")
	usermod -p ${user_pwd} ${username}
	usermod -aG wheel ${username}
fi

# network & hosts
echo "${os_hostname}" > /etc/hostname

echo '# Static table lookup for hostnames.' > /etc/hosts
echo '# See hosts(5) for details.' >> /etc/hosts
echo '#' >> /etc/hosts
echo -e "127.0.0.1\tlocalhost" >> /etc/hosts
echo -e "::1\t\tlocalhost" >> /etc/hosts
echo -e "127.0.1.1\t${os_hostname}.localdomain ${os_hostname}" >> /etc/hosts

systemctl enable dhcpcd
systemctl start dhcpcd

pacman -S openssh --noconfirm
systemctl enable sshd
systemctl start sshd

# bootloader
pacman -S grub os-prober --noconfirm
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
