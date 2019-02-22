#!/bin/bash

# creates a new virtual machine
function create_virtual_marchine(){
	echo -e "${text_title}Setting up new virtual machine${text_def}"
	create_new_vm
	configure_vm_network
	create_drives
	mount_install_medium
}

# Creates a new hostonly network in virtualbox
function create_hostonly_network(){
	if [ $(vboxmanage list hostonlyifs | grep -P '^Name:\s*'${vm_hostonly_name} | wc -l) -le "0" ]
	then
		echo "Creating new hostonly network ${vm_hostonly_name} "
		# TO DO 
		echo "TO DO!"
	else
		echo "Hostonly network ${vm_hostonly_name} already exists!"
	fi
}

# configures the network adapters for a vm
function configure_vm_network() {
	echo "Configuring VM network"
	# set up network cards
	vboxmanage modifyvm "${vm_name}" --nic1 NAT
	# create the hostonly netwerk if not yet exists
	create_hostonly_network
	vboxmanage modifyvm "${vm_name}" --nic2 hostonly --hostonlyadapter2 "${vm_hostonly_name}"
}

# Creates a new virtual machine
function create_new_vm(){
	# Create new virtual machine if needed
	if [ $(VBoxManage list vms | grep '^"'${vm_name}'"' | wc -l) -le "0" ]
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
			remove_vm
			create_new_vm
		fi
	fi
}

# Removes a virtual machine and all it's files
function remove_vm(){
	echo "Removing Virtual Machine ${vm_name}"
	vboxmanage unregistervm "${vm_name}" --delete
}

# Creates the hdd and cdrom drive for the virtual machine
function create_drives(){
	local path_hdd="${vm_path}/${vm_name}"
	echo "Creating and mounting drives"	
	vboxmanage createhd --filename "${path_hdd}/${vm_name}.vdi" --size "10000"
	vboxmanage storagectl "${vm_name}" --name "SATA Controller" --add "sata" --controller "IntelAHCI"
	vboxmanage storageattach "${vm_name}" --storagectl "SATA Controller" --port "0" --device "0" --type "hdd" --medium "${path_hdd}/${vm_name}.vdi"
}

# Mount the iso for OS installer into cdrom drive
function mount_install_medium() {
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
function unmount_install_medium(){
	echo -e "${text_def}Unmounting install medium"
	vboxmanage storageattach "${vm_name}" --storagectl "SATA Controller" --port "1" --device "0" --type "dvddrive" --medium "emptydrive"
}

# Types a line of text on the vm console
function vm_keyboard_type_text(){
	vboxmanage controlvm "${vm_name}" keyboardputstring "$1"
}

# Simulates pressing a key on the vm console
# Usage: vm_keyboard_press_key [key] [IS_ESCAPED]
# IS_ESCAPED	If has value then special escape char will be placed before the keycode
function vm_keyboard_press_key() {
	key_code_press=""
	key_code_release=""
	case "$1"
	in
		# numbers
		1)		key_code_press="02"; key_code_release="82";;
		2)		key_code_press="03"; key_code_release="83";;
		3)		key_code_press="04"; key_code_release="84";;
		4)		key_code_press="05"; key_code_release="85";;
		5)		key_code_press="06"; key_code_release="86";;
		6)		key_code_press="07"; key_code_release="87";;
		7)		key_code_press="08"; key_code_release="88";;
		8)		key_code_press="09"; key_code_release="89";;
		9)		key_code_press="0A"; key_code_release="8A";;
		0)		key_code_press="0B"; key_code_release="8B";;
		# letters		
		b)		key_code_press="30"; key_code_release="B0";;
		c)		key_code_press="2E"; key_code_release="AE";;
		i)		key_code_press="17"; key_code_release="97";;
		q)		key_code_press="10"; key_code_release="90";;
		r)		key_code_press="13"; key_code_release="93";;
		# arrow keys		
		down) 		key_code_press="50"; key_code_release="D0";;
		left) 		key_code_press="4B"; key_code_release="CB";;
		right) 		key_code_press="4D"; key_code_release="CD";;
		up) 		key_code_press="48"; key_code_release="C8";;
		# special keys	
		alt)		key_code_press="38"; key_code_release="B8";;
		ctrl)		key_code_press="1D"; key_code_release="9D";;
		enter) 		key_code_press="1C"; key_code_release="9C";;
		esc)		key_code_press="01"; key_code_release="81";;
		page_down)	key_code_press="76"; key_code_release="F6";;	
		page_up)	key_code_press="84"; key_code_release="04";;
		space)		key_code_press="39"; key_code_release="B9";;
		tab)		key_code_press="0F"; key_code_release="8F";;
		*) echo "Unknown key $1 pressed."; exit 1;;
	esac
	
	# escape the key we will type 
	if [ "$#" -eq "2" ]
	then
		vboxmanage controlvm "${vm_name}" keyboardputscancode "E0" "${key_code_press}" "E0" "${key_code_release}"
	else
		vboxmanage controlvm "${vm_name}" keyboardputscancode "${key_code_press}" "${key_code_release}"
	fi
}

# Returns 1 if virtual machine is running, 0 otherwise
function is_vm_running(){
	echo $(vboxmanage list runningvms | grep '^"'${vm_name}'"' | wc -l)
}

# Writs a file line per line to VM using vim
# USAGE: write_file_to_vm [LOCAL_FILE] [FILE_VM] [SKIP_COMMENT] [SKIP_EMPTY]
# LOCAL_FILE		The file on host machine
# FILE_VM		The file to write to in VM
# SKIP_COMMENT		Do not copy lines which are comment (1 = default)
# SKIP_EMPTY		Do not copy lines which are empty (1 = default)
function write_file_to_vm() {
	local_file="$1"	
	file_vm="$2"

	skip_comment=[[ -z "$3" ]] && "1" || "$3"
	skip_empty=[[ -z "$4" ]] && "1" || "$4"
	
	# temp swap to qwertz keyboard otherwise a in text will be sent as q, ...
	loadkeys us

	# create install script on vm using vi
	vm_keyboard_type_text "vi ${file_vm}"
	vm_keyboard_press_key "enter"

	# activate insert mode (= i)
	vm_keyboard_press_key "i"

	while read line
	do
		# Skip empty line if wanted
		if ([ -z "${line}" -o "${line}" == "" ] && [ "${skip_empty}" -eq "0" ]) || 
			# skip comment line if wanted
			([[ "${line}" =~ ^\s*# ]] && [ "${skip_comment}" -eq "0" ]) ||
			# Always print a non-empty and non-comment line		
			(! [ -z "${line}" -o "${line}" == "" ] && ! [[ "${line}" =~ ^\s*# ]])
		then
			vm_keyboard_type_text "${line}"
			vm_keyboard_press_key "enter"
		fi
	done < "${local_file}"


	# enter command mode (= esc)
	vm_keyboard_press_key "esc"

	# write changes (= :w)
	vm_keyboard_type_text ':w'
	vm_keyboard_press_key "enter"

	# quit vi (= :q)
	vm_keyboard_type_text ':q'
	vm_keyboard_press_key "enter"
}
