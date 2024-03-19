#!/bin/bash

# Define users from the provided list
EXCLUDED_USERS=("root" "daemon" "bin" "sys" "sync" "games" "man" "lp" "mail" "news" "uucp" "proxy" "www-data" "backup" "list" "irc" "gnats" "nobody" "systemd-network" "systemd-resolve" "systemd-timesync" "messagebus" "syslog" "_apt" "tss" "uuidd" "tcpdump" "avahi-autoipd" "usbmux" "rtkit" "dnsmasq" "cups-pk-helper" "speech-dispatcher" "avahi" "kernoops" "saned" "nm-openvpn" "hplip" "whoopsie" "colord" "fwupd-refresh" "geoclue" "pulse" "gnome-initial-setup" "gdm" "sssd" "systemd-coredump" "clamav")

# Prompt user to specify additional users to exclude
read -p "Enter usernames (comma-separated) to exclude in addition to the default list: " additional_users_input

# Parse additional users input
IFS=',' read -ra additional_users <<< "$additional_users_input"

# Combine default excluded users list with additional users specified by the user
EXCLUDED_USERS+=("${additional_users[@]}")

# Loop through all users
while IFS= read -r user; do
    # Check if the current user is in the excluded list
    if [[ " ${EXCLUDED_USERS[@]} " =~ " ${user} " ]]; then
        continue  # Skip if the user is in the excluded list
    fi
    
    # Restrict access for users not in the excluded list
    usermod -s /sbin/nologin "$user"  # Modify shell to /sbin/nologin
    chage -E 1 "$user"  # Set expiration date to immediately expire the password
    echo "User $user restricted"
done < <(cut -d: -f1 /etc/passwd)

echo "Access restricted for specified users."
#!/bin/bash

# Define users to exclude
EXCLUDED_USERS=("root" "daemon" "bin" "sys" "sync" "games" "man" "lp" "mail" "news" "uucp" "proxy" "www-data" "backup" "list" "irc" "gnats" "nobody" "systemd-network" "systemd-resolve" "systemd-timesync" "messagebus" "syslog" "_apt" "tss" "uuidd" "tcpdump" "avahi-autoipd" "usbmux" "rtkit" "dnsmasq" "cups-pk-helper" "speech-dispatcher" "avahi" "kernoops" "saned" "nm-openvpn" "hplip" "whoopsie" "colord" "fwupd-refresh" "geoclue" "pulse" "gnome-initial-setup" "gdm" "sssd" "prepper" "systemd-coredump" "clamav")

# Loop through all users
while IFS= read -r user; do
    # Check if the current user is in the excluded list
    if [[ " ${EXCLUDED_USERS[@]} " =~ " ${user} " ]]; then
        continue  # Skip if the user is in the excluded list
    fi
    
    # Restrict access for users not in the excluded list
    usermod -s /sbin/nologin "$user"  # Modify shell to /sbin/nologin
    chage -E 1 "$user"  # Set expiration date to immediately expire the password
    echo "User $user restricted"
done < <(cut -d: -f1 /etc/passwd)

echo "Access restricted for specified users."
