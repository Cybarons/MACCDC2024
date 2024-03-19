#!/bin/bash

# Capture network traffic using tcpdump
tcpdump -i ens33 -w network_traffic.pcap &

# Wait for 60 seconds
sleep 60

# Stop tcpdump process
killall tcpdump

tcpdump -r network_traffic.pcap
