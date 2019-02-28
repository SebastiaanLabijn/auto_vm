#!/bin/bash

###
# Contains all the parameters used by the auto_vm scripts
###

### Operation System Configuration

# password for the root user (plain text)
# There is no check if this password is good enough for the installer!
# If not strong enough this might crash the installer!
os_root_pwd="rootroot"
# Username for user account to be created during OS install (Leave bank if dont want to create extra user)
# If installer only allows 1 user to be made
# vagrant user will be made and os_user_name ignored
os_user_name="sebastiaan"
# Full name of the user
os_user_fullname="${os_user_name}"
# password for the user (plain text)
os_user_pwd="sebastiaan"
# flag indicating if user has to be admin (0 if not)
os_user_admin="1"
# flag indicating if we have to make vagrant user (0 if not)
os_user_vagrant="1"
# hostname
os_hostname="fedoravm"
# domainname
os_domainname="domain"

### Operation System parameters

# (short) Name of the OS to be installed
# Possible values: arch, centos, fedora, redhat
os_name="fedora"
# Name of the iso file for the OS installer
os_iso_name="${os_name}.iso"
# Path where the ISO is stored (created if doesn't exist)
os_iso_path="./isos"
# url where to dl the iso if not present
# Mirrors:
arch_iso_url='https://archlinux.cu.be/iso/latest/archlinux-2019.02.01-x86_64.iso'
centos_iso_url='http://centos.cu.be/7.6.1810/isos/x86_64/CentOS-7-x86_64-Minimal-1810.iso'
debian_iso_url='https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-9.8.0-amd64-netinst.iso'
fedora_ws_iso_url='https://download.fedoraproject.org/pub/fedora/linux/releases/29/Workstation/x86_64/iso/Fedora-Workstation-Live-x86_64-29-1.2.iso'
fedora_server_iso_url='https://download.fedoraproject.org/pub/fedora/linux/releases/29/Server/x86_64/iso/Fedora-Server-dvd-x86_64-29-1.2.iso'
# Pick the mirror you need from above
os_iso_url="${fedora_server_iso_url}"

### Virtual box parameters

# Flag indicating to boot the VM headless (0, to boot vm with GUI)
vm_headless="0"
# Flag indicating to delete the VM if already exists and remake it (0, to keep current)
vm_replace="1"
# folder where to store the VM (created if doesn't exist)
vm_path="/home/${USER}/VirtualBox VMs"
# Name of the Virtual Machine to be shown in Virtualbox
vm_name="Fedora_AutoVM"
# Name of the OS as defined by VirtualBox
# Currently supported: ArchLinux_64, Fedora_64, RedHat_64 (Use RedHat_64 for centos)
vm_os="Fedora_64"
# Name of the hostonly network to be used
vm_hostonly_name="vboxnet0"
# ip of the hostonly network
vm_hostonly_ip="192.168.200.200"
# Display RAM size (in MB)
vm_vram_size="16"
# Amount of CPUs used
vm_cpus="2"
# RAM size (in MB)
vm_mem_size="4096"

### Vagrant Options

# Flag to indicate that a vragrant user must be made (0 to skip)
# If installer only allows 1 user to be made
# vagrant user will be made and os_user_name ignored
vagrant_create_user="1"
# Create a vagrant box if wanted (0 to skip)
vagrant_box_create="1"
# Overwrite the box if exists (0 to skip)
vagrant_box_overwrite="1"
# Path where to save the box
vagrant_box_path="./boxes"
# Name of the box for vagrant to be created
vagrant_box_name="${os_name}.box"
