#!/bin/bash

# Function to monitor user account creations
monitor_user_creation() {
    # Define the initial state of /etc/passwd file
    initial_passwd_state=$(md5sum /etc/passwd | awk '{print $1}')

    while true; do
        # Check if /etc/passwd file has changed
        current_passwd_state=$(md5sum /etc/passwd | awk '{print $1}')
        
        if [ "$current_passwd_state" != "$initial_passwd_state" ]; then
            # Alert user about new user account creation
            echo "NEW USER ACCOUNT CREATED! PLEASE CHECK THE SYSTEM!"
            break
        else
            echo "No new users created."
        fi

        # Wait for 30 seconds before checking again
        sleep 30
    done
}

# Main function
main() {
    echo "Monitoring user account creations..."
    monitor_user_creation
}

# Run the main function
main
