#!/bin/bash

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Function to configure firewall using iptables
configure_iptables() {
# Flush existing rules and set default policies
    iptables -F
    iptables -X
    iptables -Z
    iptables -P INPUT DROP
    iptables -P FORWARD DROP
    iptables -P OUTPUT ACCEPT

    # Allow loopback traffic
    iptables -A INPUT -i lo -j ACCEPT
    iptables -A OUTPUT -o lo -j ACCEPT

    # Allow specific incoming traffic
    iptables -A INPUT -p tcp --dport 80 -j ACCEPT  # HTTP
    iptables -A INPUT -p tcp --dport 443 -j ACCEPT # HTTPS
    iptables -A INPUT -p tcp --dport 25 -j ACCEPT  # SMTP
    iptables -A INPUT -p tcp --dport 587 -j ACCEPT # SMTP
    iptables -A INPUT -p tcp --dport 53 -j ACCEPT  # DNS
    iptables -A INPUT -p udp --dport 53 -j ACCEPT  # DNS
    iptables -A INPUT -p tcp --dport 110 -j ACCEPT # POP3
    iptables -A INPUT -p tcp --dport 995 -j ACCEPT # POP3S
    iptables -A INPUT -p tcp --dport 21 -j ACCEPT  # FTP
    iptables -A INPUT -p tcp --dport 20 -j ACCEPT  # FTP Data
    iptables -A INPUT -p udp --dport 69 -j ACCEPT  # TFTP
    iptables -A INPUT -p udp --dport 123 -j ACCEPT # NTP

    # Allow related/established connections
    iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

    # Display current rules
    iptables -L -v
}


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
    if command -v iptables &> /dev/null; then
        echo "Configuring firewall using iptables..."
        configure_iptables
        configure_ufw
    else
        echo "Error: iptables is not available on this system"
        exit 1
    fi
}

# Run the main function
main
