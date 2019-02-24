#!/bin/bash

vm_name="Fedora_AutoVM"

source "virtualbox.sh"
source "utils.sh"

vb_keyboard_press_keys_vm "1" "0" "2"
vb_keyboard_press_keys_vm "1" "0" "3"
vb_keyboard_press_keys_vm "1" "0" "b"
vb_keyboard_press_keys_vm "1" "0" "c"
vb_keyboard_press_keys_vm "1" "1" "2"
vb_keyboard_press_keys_vm "1" "1" "3"
vb_keyboard_press_keys_vm "1" "1" "b"
vb_keyboard_press_keys_vm "1" "1" "c"



