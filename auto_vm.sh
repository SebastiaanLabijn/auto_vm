#!/bin/bash

###
# Include other scripts
###
source "parameters.sh"
source "virtualbox.sh"
source "utils.sh"

###
# Setting up new VirtualBox Virtual Machine
###

start=$(date +%s)

# creates a new virtual machine using functions from virtualbox.sh
create_virtual_marchine

echo -e "${text_title}Starting VM headless${text_def}"
vboxmanage startvm "${vm_name}" # --type headless

# execute the installtion process specific for the os
installer_script='./installer_scripts/'"${os_name}"'/vm_install_'"${os_name}"'.sh'
if [ ! -f "${installer_script}" ]
then
	echo "Could not launch install script ${installer_script} because it does not exist!"
	exit 1
fi
source "${installer_script}"

echo -en "${text_warn}Installation in progress .."
# Sleep as long as installiong is in progress
while [ $(is_vm_running) -eq "1" ]
do
	echo -en "."
	sleep 5
done
echo -e "${text_def}"

echo -e "${text_ok}Installation complete!${text_def}"
unmount_install_medium

echo -e "${text_title}Creating vagrant box${text_def}"
rm "${vagrant_box_name}" 2>/dev/null
vagrant package --base="${vm_name}" --output="${vagrant_box_path}/${vagrant_box_name}"

echo -e "${text_ok}Vagrant box made!${text_def}"

stop=$(date +%s)
sec=$((stop - start))
echo -e "${text_title}Script completed in ${sec} seconds!"


