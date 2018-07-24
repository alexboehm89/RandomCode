#!/bin/bash

function modify_file {
    # Assign inputs
    file=$1
    dir=$2
    modifier=$3
    # Check if directory already exists
    if [ ! -d "$dir" ]; then
        mkdir $dir
    fi
    # Modify photo
    $modifier $file $dir
    # Inform user
    echo "$modifier: $file to $dir"
    # Save action to history
    echo "$modifier $file $dir" >> .feh_history

}


# Script for use with feh to sort photos

# Check if number of inputs is correct
if [ $# -lt 2 ]; then
    echo -e usage: "$0 <action> <filename>\n actions: copy-photo, change-directory, delete"
    exit -1
fi

# First input is key word for action
action=$1
# Second input is current photo
file=$2

#################### COPY-PHOTO ####################

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
    modify_file $file $current_dir cp
fi

#################### CHANGE-DIRECTORY ####################
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

#################### DELETE #################### 
if [ "$action" == "delete" ]; then
    modify_file $file trash mv
fi

#################### UNDO #################### 
if [ "$action" == "undo" ]; then
    # Check if last action is saved in history
    if [ -s ".feh_history" ]; then
	read -r modifier old_filename new_dir < <(tail -n 1 .feh_history)
	# Get new filename and destination
	IFS='/'
	read -ra ARRAY <<< "$old_filename"
	unset IFS
	dest=${ARRAY[0]}
	file=$new_dir/${ARRAY[1]}
	if [ $modifier = cp ]; then
 	    # Remove copied file
	    rm $file
	    # Inform user
	    echo "rm: $file"
	    # Remove from history
	    sed -i '$d' .feh_history
        elif [ $modifier = mv ]; then
	    modify_file $file $dest mv
	    # Remove last 2 lines of history
	    sed -i '$d' .feh_history
	    sed -i '$d' .feh_history
        else  
	    echo "History of last actions is broken"
        fi
    else
	echo "Already at oldest change!"
    fi
fi

