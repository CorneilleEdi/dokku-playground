#!/bin/bash

set -e

# Set the name of the subnet that you want to view
SUBNET_NAME=$1

# Get the CIDR range of the subnet
SUBNET_CIDR=$(gcloud compute networks subnets describe $SUBNET_NAME --format='value(ipCidrRange)')

echo $SUBNET_NAME has a CIDR range of $SUBNET_CIDR

# Get the first and last IP addresses in the CIDR range
FIRST_IP=$(ipcalc $SUBNET_CIDR | grep "HostMin" | awk '{print $2}')
LAST_IP=$(ipcalc $SUBNET_CIDR | grep "HostMax" | awk '{print $2}')

# Print the first and last IP addresses as reserved
echo "Reserved IPs (2 by GCP): $FIRST_IP $LAST_IP"

# Get the number of IP addresses in the CIDR range
TOTAL_IPS=$(ipcalc $SUBNET_CIDR | grep "HostMin" | awk '{print $2}')

# Get the list of used IP addresses in the subnet
USED_IPS=$(gcloud compute instances list --format='value(networkInterfaces[].networkIP)' --filter="network:($SUBNET_NAME)" | tr '\n' ' ')

# Print the list of used IP addresses
echo "Used IPs: $USED_IPS"

# Calculate the number of remaining IP addresses
REMAINING_IPS=$(($TOTAL_IPS-2-$(echo $USED_IPS | wc -w)))

# Print the number of remaining IP addresses
echo "Remaining IPs: $REMAINING_IPS"