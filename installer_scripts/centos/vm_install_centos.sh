#!/bin/bash

source "/home/${USER}/scripts/vm/virtualbox.sh"
source "/home/${USER}/scripts/vm/utils.sh"
vm_name="centosvm"

# give the vm time to start up to boot menu
echo -e "${text_warn}Wait for VM to reach boot menu (10s)${text_def}"
sleep_timer 10
# press arrow up (ESCAPED) to go to option "installation"
vm_keyboard_press_key "up" "Y"
# press tab to enter advanced boot options
vm_keyboard_press_key "tab"
# enter " text" as advanced option to launch text installer
vm_keyboard_type_text " text"
# press enter to boot to text installer 
vm_keyboard_press_key "enter"

# Give the vm time to boot after menu to install shell
echo -e "${text_warn}Wait for VM to boot to command line (60s)${text_def}"
sleep_timer 60

# Default color
text_def="\e[39m"
# Titles in blue
text_title="\e[34m"
# Success in green
text_ok="\e[32m"
# Warnings in yellow
text_warn="\e[33m"
# Errors in red
text_err="\e[31m"

echo -e "${text_title}Starting configuration of basic minimal installation of Centos!${text_def}"

# anaconda main menu
# 1 = Language settings
# 2 = Time settings
# 3 = Installation source
# 4 = Software selection
# 5 = Installation destination
# 6 = Kdump
# 7 = Network configuration
# 8 = Root password
# 9 = User creation
#
# q = Quit
# b = Begin installation
# r = Refresh

### 1. Language settings
echo -e "${text_title}Setting up language${text_def}"
vm_keyboard_press_key "1"
vm_keyboard_press_key "enter"
# list is 2 parts so additional enter required
vm_keyboard_press_key "enter" 
# Select English as language
vm_keyboard_type_text "16"
vm_keyboard_press_key "enter" 
# Choose US type of English
vm_keyboard_press_key "1"
vm_keyboard_press_key "enter" 

### 2. Time Settings
echo -e "${text_title}Setting up time${text_def}"
vm_keyboard_press_key "2"
vm_keyboard_press_key "enter"
# set timezone
vm_keyboard_press_key "1"
vm_keyboard_press_key "enter"
# europe
vm_keyboard_press_key "1"
vm_keyboard_press_key "enter"
# Brussels
vm_keyboard_press_key "8"
vm_keyboard_press_key "enter"

### 3. Installation source
echo -e "${text_title}Setting up installation source${text_def}"
vm_keyboard_press_key "3"
vm_keyboard_press_key "enter"
# Use cdrom/dvdrom
vm_keyboard_press_key "1"
vm_keyboard_press_key "enter"

### 4. Software selection
echo -e "${text_title}Setting up software selection${text_def}"
vm_keyboard_press_key "4"
vm_keyboard_press_key "enter"
# Minimal install
vm_keyboard_press_key "1"
vm_keyboard_press_key "enter"
# Confirm selection and continue
vm_keyboard_press_key "c"
vm_keyboard_press_key "enter"

### 5. Installation Destination
echo -e "${text_title}Setting up installation destination${text_def}"
vm_keyboard_press_key "5"
vm_keyboard_press_key "enter"
# Auto selected our first (and only) hdd so continue
vm_keyboard_press_key "c"
vm_keyboard_press_key "enter"
# Auto use full hdd so continue
vm_keyboard_press_key "c"
vm_keyboard_press_key "enter"
# Partition schema: usse auto selection (LVM)
vm_keyboard_press_key "c"
vm_keyboard_press_key "enter"

### 7. Network Configuration
echo -e "${text_title}Setting up network${text_def}"
vm_keyboard_press_key "7"
vm_keyboard_press_key "enter"
# Setting hostname
vm_keyboard_press_key "1"
vm_keyboard_press_key "enter"
vm_keyboard_type_text 'centosvm.local'
vm_keyboard_press_key "enter"
## Setting up NAT network card
vm_keyboard_press_key "2"
vm_keyboard_press_key "enter"
# Auto connect after reboot
vm_keyboard_press_key "7"
vm_keyboard_press_key "enter"
# apply changes for NAT card and return network config menu
vm_keyboard_press_key "c"
vm_keyboard_press_key "enter"
## Setting up hostonly card
vm_keyboard_press_key "3"
vm_keyboard_press_key "enter"
# Auto connect after reboot
vm_keyboard_press_key "7"
vm_keyboard_press_key "enter"
# apply changes for NAT card and return network config menu
vm_keyboard_press_key "c"
vm_keyboard_press_key "enter"
# Go back to main anaconda menu
vm_keyboard_press_key "c"
vm_keyboard_press_key "enter"

### 8. Root password
echo -e "${text_title}Setting up root password${text_def}"
vm_keyboard_press_key "8"
vm_keyboard_press_key "enter"
# Enter password
vm_keyboard_type_text 'centosvm.local'
vm_keyboard_press_key "enter"
# Repeat password
vm_keyboard_type_text 'centosvm.local'
vm_keyboard_press_key "enter"
# Confirm if weak password, if was strong we type this too much but wont make crash
vm_keyboard_type_text 'yes'
vm_keyboard_press_key "enter"

### 9. Create user
echo -e "${text_title}Setting up user account${text_def}"
vm_keyboard_press_key "9"
vm_keyboard_press_key "enter"
# Activate Create user
vm_keyboard_press_key "1"
vm_keyboard_press_key "enter"
# Set Full name
vm_keyboard_press_key "2"
vm_keyboard_press_key "enter"
vm_keyboard_type_text 'sebastiaan'
vm_keyboard_press_key "enter"
# Set username
vm_keyboard_press_key "3"
vm_keyboard_press_key "enter"
vm_keyboard_type_text 'sebastiaan'
vm_keyboard_press_key "enter"
# Activate Use password
vm_keyboard_press_key "4"
vm_keyboard_press_key "enter"
# Set the password
vm_keyboard_press_key "5"
vm_keyboard_type_text 'sebastiaan'
vm_keyboard_press_key "enter"
vm_keyboard_type_text 'sebastiaan'
vm_keyboard_press_key "enter"
# Confirm if weak password, if was strong we type this too much but wont make crash
vm_keyboard_type_text 'yes'
vm_keyboard_press_key "enter"
# Activate Administrator
vm_keyboard_press_key "6"
vm_keyboard_press_key "enter"
# User auto added to wheel group so continu
vm_keyboard_press_key "c"
vm_keyboard_press_key "enter"

echo -e "${text_title}Starting automated basic minimal installation of Centos!${text_def}"
vm_keyboard_press_key "b"
vm_keyboard_press_key "enter"

