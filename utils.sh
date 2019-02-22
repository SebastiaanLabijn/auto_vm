#!/bin/bash

### Color codes for text in terminal

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


# Function that shows how many seconds the system is sleeping
function sleep_timer(){
	seconds="$1"
	echo -n "Sleeping for ${seconds}s .. "
	while [ "${seconds}" -gt "0" ]
	do
		sleep 1
		seconds=$((seconds - 1))
		# only print during last 5 sec
		if [ "${seconds}" -le "5" ]
		then
			echo -n "${seconds} "
		fi
		if [ "$((seconds % 10))" -eq "0" -a "${seconds}" -gt "0" ]
		then
			echo -n "${seconds} .. "
		fi
	done
	echo ""
}
