#!/bin/bash

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi



# Function to configure firewall using ufw
configure_ufw() {
   # Reset UFW to default settings
    ufw --force reset

    # Enable UFW
    ufw enable

    # Set default policies
    ufw default deny incoming
    ufw default allow outgoing

    # Allow HTTP, HTTPS, SMTP, DNS, POP3, FTP, TFTP, NTP
    ufw allow http
    ufw allow https
    ufw allow smtp
    ufw allow 53/udp
    ufw allow pop3
    ufw allow ftp
    ufw allow tftp
    ufw allow ntp

    # Enable UFW logging
    ufw logging on

    # Reload UFW to apply changes
    ufw reload

    # Display UFW status
    ufw status verbose
}

# Main function
main() {
    # Check if iptables is available
    configure_ufw
}

# Run the main function
main
