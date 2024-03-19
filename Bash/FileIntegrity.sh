#!/bin/bash

# Define critical files for a Ubuntu machine
CRITICAL_FILES=(
    "/etc/passwd"
    "/etc/shadow"
    "/etc/group"
    "/etc/sudoers"
    # Add more critical files as needed
)

# Function to set baseline hashsum for critical files
set_baseline_hash() {
    for file in "${CRITICAL_FILES[@]}"; do
        if [ -f "$file" ]; then
            md5sum "$file" >> /var/log/critical_files_baseline.md5
        else
            echo "Error: $file not found"
        fi
    done
}

# Function to check for violation or change to critical files
check_critical_files() {
    while true; do
        for file in "${CRITICAL_FILES[@]}"; do
            if [ -f "$file" ]; then
                current_hash=$(md5sum "$file")
                if ! grep -q "$current_hash" /var/log/critical_files_baseline.md5; then
                    echo "Violation detected:"
                    echo "File: $file"
                    echo "Details: File has been modified"
                    echo "Deleting md5 baseline and stopping script"
                    rm /var/log/critical_files_baseline.md5
                    exit 1
                fi
            else
                echo "Error: $file not found"
            fi
        done
        sleep 30
    done
}

# Main function
main() {
    echo "Setting baseline hashsum for critical files..."
    set_baseline_hash
    echo "Baseline hashsum set successfully"
    echo "Checking critical files every 30 seconds..."
    check_critical_files
}

# Run the main function
main
