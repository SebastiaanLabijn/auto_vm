#!/bin/bash

###
# Include other scripts
###
source "parameters.sh"
source "virtualbox.sh"
source "utils.sh"

###
# Functions
###

parameters_ok="1"

# performs a check on critical paramters to check if they are correctly set
function check_parameters() {
	echo -e "${text_title}Checking value critical paramters${text_def}"
	# flags
	accepted_values=("0" "1")
	check_parameter_isset_with_values "os_user_admin" "${os_user_admin}" "${accepted_values[@]}"
	check_parameter_isset_with_values "os_user_vagrant" "${os_user_vagrant}" "${accepted_values[@]}"
	check_parameter_isset_with_values "vagrant_box_create" "${vagrant_box_create}" "${accepted_values[@]}"
	check_parameter_isset_with_values "vagrant_box_overwrite" "${vagrant_box_overwrite}" "${accepted_values[@]}"
	check_parameter_isset_with_values "vm_replace" "${vm_replace}" "${accepted_values[@]}"
	check_parameter_isset_with_values "vagrant_create_user" "${vagrant_create_user}" "${accepted_values[@]}"
	# check if paths are correct
	check_path "vm_path" "${vm_path}"
	check_path "os_iso_path" "${os_iso_path}"
	check_path "vagrant_box_path" "${vagrant_box_path}"
	# check if values for VM are postive numbers
	check_positive_number "vm_vram_size" "${vm_vram_size}"
	check_positive_number "vm_cpus" "${vm_cpus}"
	check_positive_number "vm_mem_size" "${vm_mem_size}"
	# filename for iso must be set
	check_parameter_isset "os_iso_name" "${os_iso_name}"
	# check if value for chosen distribution is correct
	accepted_values=("arch" "centos" "fedora" "redhat")
	check_parameter_isset_with_values "os_name" "${os_name}" "${accepted_values[@]}"
	accepted_values=("ArchLinux_64" "Fedora_64" "RedHat_64")
	check_parameter_isset_with_values "vm_os" "${vm_os}" "${accepted_values[@]}"
}


# Check if a paramter is not empty
function check_parameter_isset(){
	name="$1"
	value="$2"
	
	if [ -z "${value}" -o "${value}" == "" ]
	then
		echo -e "${text_err}Parameter ${name} must have a value!"
		parameters_ok="0"
	fi
}

# Check if a paramter is set with one of the allowed values
function check_parameter_isset_with_values(){
	name="$1"
	value="$2"
	shift
	shift
	# shift first 2 parameters and keep the rest as accepted values
	accepted_values=($@)
	
	# Check if it has at least a value
	if [ -z "${value}" -o "${value}" == "" ]
	then
		echo -e "${text_err}Parameter ${name} (value: ${value}) not set correctly (Accepted values are: ${accepted_values[@]})"
		parameters_ok="0"
	else
		# check if the value
		for av in ${accepted_values[@]}
		do
			# found so correclty set, nothing to do here
			if [ "$av" == "${value}" ]
			then	
				return
			fi
		done
		# we did not find an accepted value, so wrong value
		echo -e "${text_err}Parameter ${name} (value: ${value}) not set correctly (Accepted values are: ${accepted_values[@]})"
		parameters_ok="0"
	fi
}

# Check if a "path" is set correclty
function check_path(){
	name="$1"
	value="$2"
	
	if [ -z "${value}" ] || [ ! -d "${value}" ]
	then
		echo "Current path in check: ${PWD}"
		echo -e "${text_err}Path for parameter ${name} (value: ${value}) does not exist!"
		parameters_ok="0"
	fi
}

# Check if a "file" exists
function check_file(){
	name="$1"
	value="$2"
	
	if [ -z "${value}" ] || [ ! -f "${value}" ]
	then
		echo -e "${text_err}File ${name} (path: ${value}) does not exist!"
		parameters_ok="0"
	fi
}

# check if a value is a postive digit
function check_positive_number() {
	name="$1"
	value="$2"
	# cant be empty, must be a number, must be positve
	if [ -z "${value}" ] || ! [[ "${value}" =~ ^[0-9]+$ ]] || [ "${value}" -le "0" ]
	then
		echo -e "${text_err}Parameter ${name} (value: ${value}) is not a positive number!"
		parameters_ok="0"
	fi
}

# performs the minimal installation of the os
function perform_os_installation() {
	# execute the installtion process specific for the os
	installer_script='./installer_scripts/vm_install_'"${os_name}"'.sh'
	if [ ! -f "${installer_script}" ]
	then
		echo "Could not launch install script ${installer_script} because it does not exist!"
		vb_stop_vm
		exit 1
	fi
	source "${installer_script}"
	
	echo -en "${text_warn}Installation in progress .."
	# Sleep as long as installiong is in progress
	while [ $(vb_is_vm_running) -eq "1" ]
	do
		echo -en "."
		sleep 5
	done
	echo -e "${text_def}"

	echo -e "${text_ok}Installation complete!${text_def}"
	vb_unmount_install_medium
}

# creates a new vagrant box
function vg_create_box() {
	# only create if wanted
	# create vagrant box if wanted
	if [ "${vagrant_box_create}" -eq "1" ]
	then
		echo -e "${text_title}Creating vagrant box${text_def}"
		# check if box does not yet exist
		if [ -f "${vagrant_box_path}/${vagrant_box_name}" ]
		then
			# user asks to overwrite
			if [ "${vagrant_box_overwrite}" -eq "1" ]
			then
				# remove the box if already exists
				echo -e "${text_warn}Box ${vagrant_box_name} already exists in ${vagrant_box_path}! ${text_def}Removing current box"
				rm "${vagrant_box_path}/${vagrant_box_name}" 2>/dev/null
			else
				echo -e "${text_warn}Box ${vagrant_box_name} already exists in ${vagrant_box_path}! ${text_err}Overwrite not allowed! Skipping ..."
				return
			fi
		fi
		# create a new box
		vagrant package --base="${vm_name}" --output="${vagrant_box_path}/${vagrant_box_name}"
	
		echo -e "${text_ok}Vagrant box made!${text_def}"
	fi
}

###
# Setting up new VirtualBox Virtual Machine
###

start=$(date +%s)

# use qwerty keyboard to send the commandos/text in right format
loadkeys us

check_parameters
if [ "${parameters_ok}" -ne "1" ]
then
	echo -e "${text_def}Not all parameters were set correctly. Exiting script!${text_def}"
	exit 2
else
	echo -e "${text_ok}Parameters set correctly${text_def}"
fi

vb_create_vm
vb_boot_vm
perform_os_installation
vg_create_box

stop=$(date +%s)
sec=$((stop - start))
echo -e "${text_title}Script completed in ${sec} seconds!"


