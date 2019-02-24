#!/bin/bash

# give the vm time to start up to boot menu
echo -e "${text_warn}Wait for VM to reach boot menu (10s)${text_def}"
sleep_timer 10
# press arrow down and then enter on the boot menu to load the text installer
vb_keyboard_press_keys_vm "1" "0" "down"
vb_keyboard_press_keys_vm "1" "0" "enter"

echo -e "${text_warn}Wait for VM to reach text installer (3s)${text_def}"
sleep_timer 3

## Configure Language

# Default eng/eng gekozen so continue
vb_keyboard_press_keys_vm "1" "0" "enter"
# Default US variant is picked so continue
vb_keyboard_press_keys_vm "1" "0" "enter"

## Configure keyboard
# Pick Belgian keyboard
for i in {1..7}
do
	vb_keyboard_press_keys_vm "1" "0" "down"
done
vb_keyboard_press_keys_vm "1" "0" "enter"

## Configure network

echo -e "${text_warn}Wait for installer to poll network interfaces (10s)${text_def}"
sleep_timer 10

# Set Hostname
# Remove default value "debian"
vb_keyboard_press_keys_vm "6" "0" "back_sp"
# Enter correct value
vb_keyboard_type_text_vm "${os_hostname}"
vb_keyboard_press_keys_vm "1" "0" "enter"
# Set Domainname
# Remove default value "home"
vb_keyboard_press_keys_vm "4" "0" "back_sp"
# Enter correct value
vb_keyboard_type_text_vm "${os_domainname}"
vb_keyboard_press_keys_vm "1" "0" "enter"

# Let installer write networkconfiguration
sleep_timer 3

## Set root passwd

# Type the passwd
vb_keyboard_type_text_vm "${os_root_pwd}"
vb_keyboard_press_keys_vm "1" "0" "enter"
# Type it again to confirm
vb_keyboard_type_text_vm "${os_root_pwd}"
vb_keyboard_press_keys_vm "1" "0" "enter"

## Setup user account

#full name
vb_keyboard_type_text_vm "${os_user_fullname}"
vb_keyboard_press_keys_vm "1" "0" "enter"
# user name
# Remove default value from os_user_fullname
lenght_fullname=$(echo "${os_user_fullname}" | wc -c)
vb_keyboard_press_keys_vm "${lenght_fullname}" "0" "back_sp"
# Type the correct value
vb_keyboard_type_text_vm "${os_user_name}"
vb_keyboard_press_keys_vm "1" "0" "enter"
# password
vb_keyboard_type_text_vm "${os_user_pwd}"
vb_keyboard_press_keys_vm "1" "0" "enter"
# retype password to confirm
vb_keyboard_type_text_vm "${os_user_pwd}"
vb_keyboard_press_keys_vm "1" "0" "enter"

## setup timezone
# Pick "Eastern" time, can't set this to Belgium if language/local ain't Europen
vb_keyboard_press_keys_vm "1" "0" "enter"

## partitioning hdds

echo -e "${text_warn}Wait for installer to poll harddrive interfaces (3s)${text_def}"
sleep_timer 3

## Selecting default values
# use entire disk
# select the only disk
# all files in 1 partition
# finish partitioning and write change to disk
vb_keyboard_press_keys_vm "4" "0" "enter"
# select yes by using tab 
vb_keyboard_press_keys_vm "1" "0" "tab"
vb_keyboard_press_keys_vm "1" "0" "enter"

echo -e "${text_ok}Configuration complete!${text_def}"

echo -e "${text_warn}Wait for installer to scan installation medium (15s)${text_def}"
sleep_timer 15
# skip scanning the rest
vb_keyboard_press_keys_vm "1" "0" "enter"

# pick mirror in uk for packages (Default is US)
vb_keyboard_press_keys_vm "1" "0" "up"
vb_keyboard_press_keys_vm "3" "0" "enter"

echo -e "${text_warn}Wait for installer to update mirrors installation medium (5s)${text_def}"
sleep_timer 5s

# dont participate in contest
echo -e "${text_warn}Wait for installer to reach question about popularity-contest (10s)${text_def}"
sleep_timer 10s
vb_keyboard_press_keys_vm "1" "0" "enter"

# Select the packages
echo -e "${text_warn}Wait for installer to reach package selection (10s)${text_def}"
sleep_timer 10s
# deselect desktop environment
vb_keyboard_press_keys_vm "1" "0" "space"
vb_keyboard_press_keys_vm "1" "0" "enter"

