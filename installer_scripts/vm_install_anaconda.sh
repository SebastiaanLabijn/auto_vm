#!/bin/bash

###
# Generic anaconda installer script
# All distros using this installer can be installed using this
# Supported:
#	Centos
#	Fedora
###

# anaconda main menu
# 1 = Language settings
# 2 = Time settings
# 3 = Installation source
# 4 = Software selection
# 5 = Installation destination
# 6 = Kdump (Not present in FEDORA!!)
# 7 = Network configuration
# 8 = Root password
# 9 = User creation
#
# q = Quit
# b = Begin installation
# r = Refresh

### Functions

# Configures the Language
function __anac_configure_language() {
	echo -e "${text_title}Setting up language${text_def}"
	vb_keyboard_press_keys_vm "1" "0" "1"
	vb_keyboard_press_keys_vm "1" "0" "enter"
	# list is 2 parts so additional enter required
	vb_keyboard_press_keys_vm "1" "0" "enter" 
	# Select English as language
	# (differs between centos & fedora, check for variable in respective scripts)
	vb_keyboard_type_text_vm "${os_lang_code}"
	vb_keyboard_press_keys_vm "1" "0" "enter" 
	# Choose US type of English
	vb_keyboard_press_keys_vm "1" "0" "1"
	vb_keyboard_press_keys_vm "1" "0" "enter" 
}

# Configure the Time
function __anac_configure_time() {
	echo -e "${text_title}Setting up time${text_def}"
	vb_keyboard_press_keys_vm "1" "0" "2"
	vb_keyboard_press_keys_vm "1" "0" "enter"
	# set timezone
	vb_keyboard_press_keys_vm "1" "0" "1"
	vb_keyboard_press_keys_vm "1" "0" "enter"
	# europe
	vb_keyboard_press_keys_vm "1" "0" "1"
	vb_keyboard_press_keys_vm "1" "0" "enter"
	# Brussels
	vb_keyboard_press_keys_vm "1" "0" "8"
	vb_keyboard_press_keys_vm "1" "0" "enter"
}

# Configure the cdrom drive to be used as installation source
function __anac_set_installation_source(){
	echo -e "${text_title}Setting up installation source${text_def}"
	vb_keyboard_press_keys_vm "1" "0" "3"
	vb_keyboard_press_keys_vm "1" "0" "enter"
	# Use cdrom/dvdrom
	vb_keyboard_press_keys_vm "1" "0" "1"
	vb_keyboard_press_keys_vm "1" "0" "enter"
	# Give installer time to process choice for cdrom
	sleep 2
}

# picks the minimal software as selection
function __anac_software_selection (){
	echo -e "${text_title}Setting up software selection${text_def}"
	vb_keyboard_press_keys_vm "1" "0" "4"
	vb_keyboard_press_keys_vm "1" "0" "enter"
	# Minimal install
	vb_keyboard_press_keys_vm "1" "0" "1"
	vb_keyboard_press_keys_vm "1" "0" "enter"
	# Confirm selection and continue
	vb_keyboard_press_keys_vm "1" "0" "c"
	vb_keyboard_press_keys_vm "1" "0" "enter"
	# In fedora extra selection screen, skip it by confirm selection and continue
	# Test if this breaks in Centos
	vb_keyboard_press_keys_vm "1" "0" "c"
	vb_keyboard_press_keys_vm "1" "0" "enter"
}

# Pick the hdd to install the software to
function __anac_set_installation_destination() {
	echo -e "${text_title}Setting up installation destination${text_def}"
	vb_keyboard_press_keys_vm "1" "0" "5"
	vb_keyboard_press_keys_vm "1" "0" "enter"
	# Auto selected our first (and only) hdd so continue
	vb_keyboard_press_keys_vm "1" "0" "c"
	vb_keyboard_press_keys_vm "1" "0" "enter"
	# Auto use full hdd so continue
	vb_keyboard_press_keys_vm "1" "0" "c"
	vb_keyboard_press_keys_vm "1" "0" "enter"
	# Partition schema: usse auto selection (LVM)
	vb_keyboard_press_keys_vm "1" "0" "c"
	vb_keyboard_press_keys_vm "1" "0" "enter"
}

# Configures the network adapters 
function __anac_configure_network() {
	echo -e "${text_title}Setting up network${text_def}"
	vb_keyboard_press_keys_vm "1" "0" "${anac_menu_option_network}"
	vb_keyboard_press_keys_vm "1" "0" "enter"
	# Setting hostname
	vb_keyboard_press_keys_vm "1" "0" "1"
	vb_keyboard_press_keys_vm "1" "0" "enter"
	vb_keyboard_type_text_vm "${os_hostname}"
	vb_keyboard_press_keys_vm "1" "0" "enter"
	## Setting up NAT network card
	vb_keyboard_press_keys_vm "1" "0" "2"
	vb_keyboard_press_keys_vm "1" "0" "enter"
	# Auto connect after reboot
	vb_keyboard_press_keys_vm "1" "0" "7"
	vb_keyboard_press_keys_vm "1" "0" "enter"
	# apply changes for NAT card and return network config menu
	vb_keyboard_press_keys_vm "1" "0" "c"
	vb_keyboard_press_keys_vm "1" "0" "enter"
	## Setting up hostonly card
	vb_keyboard_press_keys_vm "1" "0" "3"
	vb_keyboard_press_keys_vm "1" "0" "enter"
	# Auto connect after reboot
	vb_keyboard_press_keys_vm "1" "0" "7"
	vb_keyboard_press_keys_vm "1" "0" "enter"
	# apply changes for NAT card and return network config menu
	vb_keyboard_press_keys_vm "1" "0" "c"
	vb_keyboard_press_keys_vm "1" "0" "enter"
	# Go back to main anaconda menu
	vb_keyboard_press_keys_vm "1" "0" "c"
	vb_keyboard_press_keys_vm "1" "0" "enter"
}

# Set the password for the root user
function __anac_set_root_pwd(){
	echo -e "${text_title}Setting up root password${text_def}"
	vb_keyboard_press_keys_vm "1" "0" "${anac_menu_option_root}"
	vb_keyboard_press_keys_vm "1" "0" "enter"
	# Enter password
	vb_keyboard_type_text_vm "${os_root_pwd}"
	vb_keyboard_press_keys_vm "1" "0" "enter"
	# Repeat password
	vb_keyboard_type_text_vm "${os_root_pwd}"
	vb_keyboard_press_keys_vm "1" "0" "enter"
	# Confirm if weak password, if was strong we type this too much but wont make crash
	vb_keyboard_type_text_vm "yes"
	vb_keyboard_press_keys_vm "1" "0" "enter"
}

# Creates new user account if needed using the parameters
function __anac_create_user_account() {
	# Installer can only make 1 user, so prior to vagrant
	if [ ! -z "${vagrant_create_user}" -a "${vagrant_create_user}" == "1" ]
	then
		__anac_configure_user "vagrant" "vagrant" "vagrant" "1"
	# no vagrant user wanted, so create a regular user if wanted	
	elif [ ! -z "${os_user_name}" -a "${os_user_name}" != "" ]
	then
		__anac_configure_user "${os_user_fullname}" "${os_user_name}" "${os_user_pwd}" "${os_user_admin}"
	fi
}

# Configures a user account, taking full name, username, password, is_admin
# Called from __anac_create_user_account() and not directly
function __anac_configure_user(){
	user_full_name="$1"
	user_name="$2"
	user_pwd="$3"
	user_is_admin="$4"
	echo -e "${text_title}Setting up user account${text_def}"
	vb_keyboard_press_keys_vm "1" "0" "${anac_menu_option_user}"
	vb_keyboard_press_keys_vm "1" "0" "enter"
	# Activate Create user
	vb_keyboard_press_keys_vm "1" "0" "1"
	vb_keyboard_press_keys_vm "1" "0" "enter"
	# Set Full name
	vb_keyboard_press_keys_vm "1" "0" "2"
	vb_keyboard_press_keys_vm "1" "0" "enter"
	vb_keyboard_type_text_vm "${user_fullname}"
	vb_keyboard_press_keys_vm "1" "0" "enter"
	# Set username
	vb_keyboard_press_keys_vm "1" "0" "3"
	vb_keyboard_press_keys_vm "1" "0" "enter"
	vb_keyboard_type_text_vm "${user_name}"
	vb_keyboard_press_keys_vm "1" "0" "enter"
	# Activate Use password
	vb_keyboard_press_keys_vm "1" "0" "4"
	vb_keyboard_press_keys_vm "1" "0" "enter"
	# Set the password
	vb_keyboard_press_keys_vm "1" "0" "5"
	vb_keyboard_type_text_vm "${user_pwd}"
	vb_keyboard_press_keys_vm "1" "0" "enter"
	vb_keyboard_type_text_vm "${user_pwd}"
	vb_keyboard_press_keys_vm "1" "0" "enter"
	# Confirm if weak password, if was strong we type this too much but wont make crash
	vb_keyboard_type_text_vm "yes"
	vb_keyboard_press_keys_vm "1" "0" "enter"
	if [ ! -z "${user_is_admin}" -a "${user_is_admin}" -eq "1" ]
	then
		# Activate Administrator
		vb_keyboard_press_keys_vm "1" "0" "6"
		vb_keyboard_press_keys_vm "1" "0" "enter"
		# User auto added to wheel
	fi
	# confirm user details and return to main menu
	vb_keyboard_press_keys_vm "1" "0" "c"
	vb_keyboard_press_keys_vm "1" "0" "enter"
}

# Configures the anaconda installer
function anac_configure_installer() {
	# 1 = Language settings
	__anac_configure_language
	# 2 = Time settings
	__anac_configure_time
	# 3 = Installation source
	__anac_set_installation_source
	# 4 = Software selection
	__anac_software_selection
	# 5 = Installation destination
	__anac_set_installation_destination
	# 7 = Network configuration
	__anac_configure_network
	# 8 = Root password
	__anac_set_root_pwd
	# 9 = User creation
	__anac_create_user_account
}

# executes the installer script
function anac_execute_installer() {
	echo -e "${text_title}Starting automated basic minimal installation of ${os_name}!${text_def}"
	vb_keyboard_press_keys_vm "1" "0" "b"
	vb_keyboard_press_keys_vm "1" "0" "enter"
}


