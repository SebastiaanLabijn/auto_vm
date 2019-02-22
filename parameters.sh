#!/bin/bash

###
# Contains all the parameters used by the auto_vm scripts
###

### Virtual Machine Parameters

# password for the root user (plain text)
os_root_pwd=""
# Username for user account to be created during OS install
os_user_name=""
# password for the user (plain text)
os_user_pwd=""

### Operation System parameters

# (short) Name of the OS to be installed
# Possible values: arch, centos, fedora, redhat
os_name="centos"
# Name of the iso file for the OS installer
os_iso_name="centos.iso"
# Path where the ISO is stored (created if doesn't exist)
os_iso_path="./isos"
# url where to dl the iso if not present
# Mirrors:
arch_iso_url='https://archlinux.cu.be/iso/latest/archlinux-2019.02.01-x86_64.iso'
centos_iso_url='http://centos.cu.be/7.6.1810/isos/x86_64/CentOS-7-x86_64-Minimal-1810.iso'
fedora_ws_iso_url='https://download.fedoraproject.org/pub/fedora/linux/releases/29/Workstation/x86_64/iso/Fedora-Workstation-Live-x86_64-29-1.2.iso'
fedora_server_iso_url='https://download.fedoraproject.org/pub/fedora/linux/releases/29/Server/x86_64/iso/Fedora-Server-dvd-x86_64-29-1.2.iso'
# Pick the mirror you need from above
os_iso_url="${centos_iso_url}"

### Virtual box parameters

# Flag indicating to delete the VM if already exists and remake it
vm_replace="1"
# folder where to store the VM (created if doesn't exist)
vm_path="/home/${USER}/VirtualBox VMs"
# Name of the Virtual Machine to be shown in Virtualbox
vm_name="${os_name}vm"
# Name of the OS as defined by VirtualBox
# Currently supported: ArchLinux_64, Fedora_64, RedHat_64 (Use RedHat_64 for centos)
vm_os="RedHat_64"
# Name of the hostonly network to be used
vm_hostonly_name="vboxnet0"
# Display RAM size (in MB)
vm_vram_size="16"
# Amount of CPUs used
vm_cpus="2"
# RAM size (in MB)
vm_mem_size="4096"

### Vagrant Options

# Name of the box for vagrant to be created
vagrant_box_path="./boxes"
vagrant_box_name="centos.box"
