#!/bin/bash

# give the vm time to start up to boot menu
echo -e "${text_warn}Wait for VM to reach boot menu (10s)${text_def}"
sleep_timer 10
# press arrow up (ESCAPED) to go to option "installation"
vb_keyboard_press_keys_vm "1" "1" "up"
# press tab to enter advanced boot options
vb_keyboard_press_keys_vm "1" "0" "tab"
# enter " text" as advanced option to launch text installer
vb_keyboard_type_text_vm " inst.text"
# press enter to boot to text installer 
vb_keyboard_press_keys_vm "1" "0" "enter"

# Give the vm time to boot after menu to install shell
echo -e "${text_warn}Wait for VM to boot to command line (60s)${text_def}"
sleep_timer 60

# Load the script for anaconda installer
source "./installer_scripts/anaconda/vm_install_anaconda.sh"

if [ -f "./installer_scripts/anaconda/vm_install_anaconda.sh" ]
then
	echo -e "${text_title}Configuring installer!${text_def}"
	# US English is code 16 in Centos
	anac_menu_lang_code="16"
	# Set values of menu options according to centos
	anac_menu_option_network="7"
	anac_menu_option_root="8"
	anac_menu_option_user="9"
	anac_configure_installer
	# start the installation
	anac_execute_installer

	# TODO: check how to capture this "event"
	# press alt tab to go to "shell"
	vb_keyboard_press_keys_vm "1" "0" "alt" "tab"
	vb_keyboard_type_text_vm "poweroff"
	vb_keyboard_press_keys_vm "1" "0" "enter"
else
	echo "${text_err}Could not load installer script for anaconda!"
	vb_halt_vm
	exit 1
fi
