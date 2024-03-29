#!/bin/bash

# Check if ClamAV is installed
if ! dpkg -l | grep -q clamav-daemon; then
    echo "ClamAV is not installed. Installing..."
    sudo apt update
    sudo apt install -y clamav clamav-daemon

    # Start ClamAV daemon
    echo "Starting ClamAV daemon..."
    sudo systemctl start clamav-daemon

    # Enable ClamAV daemon to start on boot
    echo "Enabling ClamAV daemon to start on boot..."
    sudo systemctl enable clamav-daemon

    echo "ClamAV installation and startup completed."
fi

# Check antivirus status
antivirus_status=$(sudo systemctl status clamav-daemon 2>&1)

echo "Antivirus status: $antivirus_status"

# Alert if antivirus is not running
if [[ "$antivirus_status" != *"Active: active"* ]]; then
    echo "Antivirus is not running: $antivirus_status"
    echo "Starting antivirus..."
    sudo systemctl start clamav-daemon
    sudo systemctl status clamav-daemon
    
else
    echo "Antivirus is active"
    sudo systemctl status clamav-daemon
fi
