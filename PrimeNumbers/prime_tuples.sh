#!/bin/bash

# Bash script that writes different prime tuples into text files
# A file with all prime numbers up to N is the input to this script

# Here come all functions to find a specific prime tuplet
function twins() {
    declare -a primes=("${!1}")
    prime_diff=$((primes[0]-primes[1]))
    if [ $prime_diff -eq 2 ] 
    then
        echo "${primes[1]}, ${primes[0]}" >> logs/twin_primes.txt
        let twins_count=twins_count+1
    fi
}
# Cleanup ./logs/ 
if [ -e ./logs/twin_primes.txt ] 
then
    rm ./logs/twin_primes.txt
fi
# Initialize counter variables for prime tuples
twins_count=0
# Define prime_buffer for old line inputs 
i=0
while [ $i != 16 ]; do
    prime_buffer[$i]=-1
    let i=i+1
done

# Read input file line by line
while IFS='' read -r prime || [[ -n "$prime" ]]; do
    # Reorder prime_buffer
    i=14
    while [ $i != -1 ]; do
        prime_buffer[$i+1]=${prime_buffer[$i]}
        let i=i-1
    done
    # Write new prime into buffer
    prime_buffer[0]=$prime
    # Call functions for specific prime tuplets
    twins prime_buffer[@]
done < "$1"

# Information for the user 
echo "Found $twins_count twin primes and saved them in ./logs/twin_primes.txt"
