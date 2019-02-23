#!/bin/bash

### Color codes for text in terminal

# Default color
text_def="\033[0m\e[39m"
# Titles in blue
text_title="\e[34m"
# Success in green
text_ok="\e[32m"
# Warnings in yellow
text_warn="\e[33m"
# Errors in red AND bold
text_err="\033[1m\e[31m"


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

### Keyboard scan codes

# Returns the hex code when a key (=$1) is pressed down
function keyb_get_keycode_pressed() {
	key_code_pressed=""
	case "$1"
	in
		# numbers
		1)		key_code_pressed="02";; 
		2)		key_code_pressed="03";;
		3)		key_code_pressed="04";;
		4)		key_code_pressed="05";;
		5)		key_code_pressed="06";;
		6)		key_code_pressed="07";;
		7)		key_code_pressed="08";;
		8)		key_code_pressed="09";;
		9)		key_code_pressed="0A";;
		0)		key_code_pressed="0B";;
		# letters		
		b)		key_code_pressed="30";;
		c)		key_code_pressed="2E";;
		i)		key_code_pressed="17";;
		q)		key_code_pressed="10";;
		r)		key_code_pressed="13";;
		# arrow keys		
		down) 		key_code_pressed="50";;
		left) 		key_code_pressed="4B";;
		right) 	key_code_pressed="4D";;
		up) 		key_code_pressed="48";;
		# special keys	
		alt)		key_code_pressed="38";;
		ctrl)		key_code_pressed="1D";;
		enter) 	key_code_pressed="1C";;
		esc)		key_code_pressed="01";;
		page_down)	key_code_pressed="76";;
		page_up)	key_code_pressed="84";;
		space)		key_code_pressed="39";;
		tab)		key_code_pressed="0F";;
		*) echo "Unknown key $1 pressed."; exit 1;;
	esac
	echo "${key_code_pressed}"
}

# Returns the hex code when a key (=$1) is released
function keyb_get_keycode_released() {
	key_code_released=""
	case "$1"
	in
		# numbers
		1)		key_code_released="82";;
		2)		key_code_released="83";;
		3)		key_code_released="84";;
		4)		key_code_released="85";;
		5)		key_code_released="86";;
		6)		key_code_released="87";;
		7)		key_code_released="88";;
		8)		key_code_released="89";;
		9)		key_code_released="8A";;
		0)		key_code_released="8B";;
		# letters		
		b)		key_code_released="B0";;
		c)		key_code_released="AE";;
		i)		key_code_released="97";;
		q)		key_code_released="90";;
		r)		key_code_released="93";;
		# arrow keys		
		down) 		key_code_released="D0";;
		left) 		key_code_released="CB";;
		right) 	key_code_released="CD";;
		up) 		key_code_released="C8";;
		# special keys	
		alt)		key_code_released="B8";;
		ctrl)		key_code_released="9D";;
		enter) 	key_code_released="9C";;
		esc)		key_code_released="81";;
		page_down)	key_code_released="F6";;	
		page_up)	key_code_released="04";;
		space)		key_code_released="B9";;
		tab)		key_code_released="8F";;
		*) echo "Unknown key $1 pressed."; exit 1;;
	esac
	echo "${key_code_released}"
}
