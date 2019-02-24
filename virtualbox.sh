#!/bin/bash

###
# Contains all functionality to be performed on VirtualBox & Virtual Machine
###

# creates a new virtual machine
function vb_create_vm(){
	echo -e "${text_title}Setting up new virtual machine${text_def}"
	vb_create_new_vm
	vb_configure_vm_network
	vb_create_drives
	vb_mount_install_medium
}

# Creates a new virtual machine
function vb_create_new_vm(){
	# Create new virtual machine if needed
	if [ $(vboxmanage list vms | grep '^"'"${vm_name}"'"' | wc -l) -le "0" ]
	then
		echo "Creating new virtual machine \"${vm_name}\" ..."
		vboxmanage createvm --name "${vm_name}" --ostype "${vm_os}" --register	
		vboxmanage modifyvm "${vm_name}" --cpus "${vm_cpus}"		
		vboxmanage modifyvm "${vm_name}" --vram "${vm_vram_size}"		
		vboxmanage modifyvm "${vm_name}" --memory "${vm_mem_size}"		
	else
		echo "Virtual Machine ${vm_name} already exists!"
		# destroy current machine and start over if user wants too
		if [ "${vm_replace}" -eq "1" ]
		then
			vb_remove_vm
			vb_create_new_vm
		fi
	fi
}

# Removes a virtual machine and all it's files
function vb_remove_vm(){
	echo "Removing Virtual Machine ${vm_name}"
	vboxmanage unregistervm "${vm_name}" --delete
}

# Creates the hdd and cdrom drive for the virtual machine
function vb_create_drives(){
	local path_hdd="${vm_path}/${vm_name}"
	echo "Creating and mounting drives"	
	vboxmanage createhd --filename "${path_hdd}/${vm_name}.vdi" --size "10000"
	vboxmanage storagectl "${vm_name}" --name "SATA Controller" --add "sata" --controller "IntelAHCI"
	vboxmanage storageattach "${vm_name}" --storagectl "SATA Controller" --port "0" --device "0" --type "hdd" --medium "${path_hdd}/${vm_name}.vdi"
}

# Mount the iso for OS installer into cdrom drive
function vb_mount_install_medium() {
	# if file does not exist, dl it
	if [ ! -f "${os_iso_path}/${os_iso_name}" ]
	then
		echo -e "${text_warn}Install iso not present. Downloading iso ... ${text_def}"
		mkdir -p "${os_iso_path}"
		wget "${os_iso_url}" -O "${os_iso_path}/${os_iso_name}"
	else
		echo -e "${text_ok}Install iso already present${text_def}"	
	fi
	echo -e "${text_title}Mounting install medium${text_def}"
	vboxmanage storageattach "${vm_name}" --storagectl "SATA Controller" --port "1" --device "0" --type "dvddrive" --medium "${os_iso_path}/${os_iso_name}"
}

# unmounts the iso from the cdrom drive
function vb_unmount_install_medium(){
	echo -e "${text_def}Unmounting install medium"
	vboxmanage storageattach "${vm_name}" --storagectl "SATA Controller" --port "1" --device "0" --type "dvddrive" --medium "emptydrive"
}

# Creates a new hostonly network in virtualbox
function vb_create_hostonly_network(){
	if [ $(vboxmanage list hostonlyifs | grep -P '^Name:\s*'"${vm_hostonly_name}" | wc -l) -le "0" ]
	then
		echo "Creating new hostonly network ${vm_hostonly_name} "
		# TO DO 
		echo "TO DO!"
	else
		echo "Hostonly network ${vm_hostonly_name} already exists!"
	fi
}

# configures the network adapters for a vm
function vb_configure_vm_network() {
	echo "Configuring VM network"
	# set up network cards
	vboxmanage modifyvm "${vm_name}" --nic1 NAT
	# create the hostonly netwerk if not yet exists
	vb_create_hostonly_network
	vboxmanage modifyvm "${vm_name}" --nic2 hostonly --hostonlyadapter2 "${vm_hostonly_name}"
}

# boots the vm headless
function vb_boot_vm() {
	if [ "${vm_headless}" -eq "1" ]
	then
		echo -e "${text_title}Starting VM ${vm_name} headless${text_def}"
		vboxmanage startvm "${vm_name}" --type headless
	else
		echo -e "${text_title}Starting VM ${vm_name}${text_def}"
		vboxmanage startvm "${vm_name}"
	fi
}

# halts the vm headless
function vb_stop_vm() {
	echo -e "${text_title}Stopping VM ${text_def}"
	vboxmanage controlvm "${vm_name}" poweroff hard
}

# Returns 1 if virtual machine is running, 0 otherwise
function vb_is_vm_running(){
	echo $(vboxmanage list runningvms | grep '^"'"${vm_name}"'"' | wc -l)
}

# Types a line of text on the vm console
function vb_keyboard_type_text_vm(){
	vboxmanage controlvm "${vm_name}" keyboardputstring "$1"
		# added for DEBUGGING
		sleep 2
} 

# Simulates pressing multiple keys on the vm console
# Usage: vb_keyboard_press_keys_vm [AMOUNT_OF_TIMES] [IS_ESCAPED] [KEY_1] [KEY_2] ...
# AMOUNT_OF_TIMES	Value indicating how much time we will press the key sequence (at least 1 or more)
# IS_ESCAPED		If has value 1 then special escape char will be placed before the keycode
# KEY_1			The first key pressed
# KEY_2			The second key pressed (= optional)
# ...
function vb_keyboard_press_keys_vm() {
	key_codes_pressed=()
	key_codes_released=()
	amount="$1"
	# check if we have to escape the characters
	# if we use special escaped sign, add em as first elements to array
	if [ ! -z "$2" -a "$2" -eq "1" ]
	then
		key_codes_pressed+=("E0")
		key_codes_released+=("E0")
	fi
	# shift out $1 and $2
	shift
	shift
	# loop all other chars and add correct keycodes
	while [ "$#" -gt "0" ]
	do
		key_codes_pressed+=($(keyb_get_keycode_pressed "$1"))
		key_codes_released+=($(keyb_get_keycode_released "$1"))
		shift
	done 

	for i in {1..$amount}
	do
		echo "${key_codes_pressed[@]}" "${key_codes_released[@]}"
		# type the text in the vm
		vboxmanage controlvm "${vm_name}" keyboardputscancode "${key_codes_pressed[@]}" "${key_codes_released[@]}"
		# added for DEBUGGING
		sleep 2
	done
}

# Writs a file line per line to VM using vim
# USAGE: write_file_to_vm [LOCAL_FILE] [FILE_VM] [SKIP_COMMENT] [SKIP_EMPTY]
# LOCAL_FILE		The file on host machine
# FILE_VM		The file to write to in VM
function vb_write_file_to_vm() {
	# only works with full absolut path so get it
	local_file="$1"
	file_vm="$2"
	
	# temp swap to qwertz keyboard otherwise a in text will be sent as q, ...
	loadkeys us

	# create install script on vm using vi
	vb_keyboard_type_text_vm "vi ${file_vm}"
	vb_keyboard_press_keys_vm "0" "enter"

	# activate insert mode (= i)
	vb_keyboard_press_keys_vm "0" "i"

	while read line
	do
		# Skip empty lines & comment lines if wanted
		if [ ! -z "${line}" ] && ! [[ "${line}" =~ ^\s*$ ]] && ! [[ "${line}" =~ ^\s*# ]]
		then
			vb_keyboard_type_text_vm "${line}"
			vb_keyboard_press_keys_vm "0" "enter"
		fi
	done < "${local_file}"

	# enter command mode (= esc)
	vb_keyboard_press_keys_vm "0" "esc"

	# write changes (= :w)
	vb_keyboard_type_text_vm ":w"
	vb_keyboard_press_keys_vm "0" "enter"

	# quit vi (= :q!)
	vb_keyboard_type_text_vm ":q!"
	vb_keyboard_press_keys_vm "0" "enter"
}
