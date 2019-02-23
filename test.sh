#!/bin/bash

source "parameters.sh"
source "virtualbox.sh"
source "utils.sh"

vm_name="ArchLinuxClean"

vb_keyboard_press_keys_vm "0" "b"

vb_keyboard_press_keys_vm "1" "b"

vb_keyboard_press_keys_vm "0" "i" "b" "c"

vb_keyboard_press_keys_vm "1" "i" "b" "c"


