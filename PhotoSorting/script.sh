#!/bin/bash

# Script for use with feh to sort photos

# Check if number of inputs is correct
if [ $# -lt 2 ]; then
    echo -e usage: "$0 <action> <filename>\n actions: copy-photo, change-directory"
    exit -1
fi

# First input is key word for action
action=$1
# Second input is current photo
file=$2

if [ "$action" == "copy-photo" ]; then
    # Check if file with currently chosen directory exists
    if [ -f ".feh_current_directory" ]; then
    current_dir=`cat .feh_current_directory`
    fi
    # If there is no current directory chosen ask user to choose one
    if [ ! -d "$current_dir" ] ; then
        current_dir="$(find -type d -printf '%f\n' | dmenu -p "Select directory")"
        mkdir "$current_dir"
        # Save current directory for next script call
        echo "${current_dir}" > .feh_current_directory
    fi
    # Copy file to chosen directory and print out information
    cp $file $current_dir
    echo "Moved $file to $current_dir"
fi

if [ "$action" == "change-directory" ]; then
    # Ask user for directory
    current_dir="$(find -type d -printf '%f\n' | dmenu -p "Select directory")"
    # If directory does not exist, create it
    if [ ! -d "$current_dir" ]; then
        mkdir "$current_dir"
        echo "Created and switched to new directory: "$current_dir""
    else
        echo "Switched to directory: "$current_dir""
    fi
    # Save current directory for next script call
    echo "${current_dir}" > .feh_current_directory
fi
