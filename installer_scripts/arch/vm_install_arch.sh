#!/bin/bash

os="arch"

# give the vm time to start up to boot menu
echo -e "${text_warn}Wait for VM to reach boot menu (10s)${text_def}"
sleep_timer 10
# press enter on the boot menu to load the installer
vm_keyboard_press_key "enter"

# Give the vm time to boot after menu to install shell
echo -e "${text_warn}Wait for VM to boot to command line (60s)${text_def}"
sleep_timer 60
echo -e "${text_title}Starting automated basic minimal installation of Arch Linux!${text_def}"

echo -e "${text_def}Copying installer scripts to VM${text_def}"
write_file_to_vm "./installer_scripts/${os_name}/install_${os_name}.sh" "install_${os_name}.sh"
write_file_to_vm "./installer_scripts/${os_name}/config_${os_name}.sh" "config_${os_name}.sh"

echo -e "${text_def}Exectuing installer script on VM${text_def}"
vm_keyboard_type_text "chmod 776 install_${os_name}.sh"
vm_keyboard_press_key "enter"
vm_keyboard_type_text "./install_${os_name}.sh"
vm_keyboard_press_key "enter"
