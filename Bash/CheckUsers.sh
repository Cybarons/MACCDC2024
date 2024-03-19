#!/bin/bash

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 
    exit 1
fi

# Check if the user provided a filename for the default users list
if [ $# -ne 1 ]; then
    echo "Usage: $0 <default_users_file>"
    exit 1
fi

# Verify if the provided file exists
if [ ! -f "$1" ]; then
    echo "Error: Default users file '$1' not found"
    exit 1
fi

# Read default system users from the file into an array
IFS=$'\r\n' read -d '' -r -a default_users < "$1"

# Read system users from /etc/passwd
IFS=$'\n' read -d '' -r -a system_users < <(cut -d: -f1 /etc/passwd)

# Initialize an array to store extra users
extra_users=()

# Compare system users with default users
for user in "${system_users[@]}"; do
    if ! [[ " ${default_users[@]} " =~ " ${user} " ]]; then
        extra_users+=("$user")
    fi
done

# Check if there are extra users
if [ ${#extra_users[@]} -eq 0 ]; then
    echo "All system users are as expected."
else
    echo "Warning: The following system users are not in the default list:"
    printf '%s\n' "${extra_users[@]}"
fi
