#!/bin/bash

# Function to reset user access
reset_user_access() {
    local user="$1"
    
    # Check if username is provided
    if [ -z "$user" ]; then
        echo "Error: Username not provided"
        exit 1
    fi

    # Allow access for specified user
    usermod -s /bin/bash "$user"
    echo "User '$user' access reset to normal"
}

# Main function
main() {
    # Check if script is run as root
    if [[ $EUID -ne 0 ]]; then
       echo "This script must be run as root" 
       exit 1
    fi

    # Prompt for username
    read -p "Enter the username to reset access: " username

    # Run function to reset user access
    reset_user_access "$username"
}

# Run the main function
main
