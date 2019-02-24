#!/bin/bash

# give the vm time to start up to boot menu
echo -e "${text_warn}Wait for VM to reach boot menu (10s)${text_def}"
sleep_timer 10
# press enter on the boot menu to load the installer
vb_keyboard_press_keys_vm "1" "0" "enter"

# Give the vm time to boot after menu to install shell
echo -e "${text_warn}Wait for VM to boot to command line (60s)${text_def}"
sleep_timer 60
echo -e "${text_title}Starting automated basic minimal installation of Arch Linux!${text_def}"

script_install_os_path="./installer_scripts/${os_name}"
script_install_os_name="install_${os_name}.sh"
check_file  "${script_install_os_name}" "${script_install_os_path}/${script_install_os_name}"

script_config_os_name="config_${os_name}.sh"
check_file "${script_config_os_name}" "${script_install_os_path}/${script_config_os_name}"

if [ "${parameters_ok}" -ne "1" ]
then
	echo -e "${text_def}The required installer scripts could not be found! Exiting installer and VM!${text_def}"
	vb_stop_vm
	exit 2
fi

echo -e "${text_def}Copying installer scripts to VM${text_def}"
vb_write_file_to_vm "${script_install_os_path}/${script_install_os_name}" "${script_install_os_name}" "1" "1"
vb_write_file_to_vm "${script_install_os_path}/${script_config_os_name}" "${script_config_os_name}" "1" "1"

echo -e "${text_def}Exectuing installer script on VM${text_def}"
vb_keyboard_type_text_vm "chmod 776 ${script_install_os_name}"
vb_keyboard_press_keys_vm "1" "0" "enter"
vb_keyboard_type_text_vm "./${script_install_os_name} ${os_root_pwd} ${os_user_vagrant} ${os_user_name} ${os_user_pwd} ${os_user_admin}"
vb_keyboard_press_keys_vm "1" "0" "enter"
