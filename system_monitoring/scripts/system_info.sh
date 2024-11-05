#!/bin/bash

########################################################
# System Info Script
########################################################

# Source common utility functions
source "$(dirname "$0")/common_utils.sh"

# Default values
DEFAULT_DISK_USAGE_THRESHOLD=80

# Load configuration file
CONFIG_FILE="$(dirname "$0")/.scripts_config/system_info.conf"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    disk_usage_threshold="$DEFAULT_DISK_USAGE_THRESHOLD"
fi

# Function to print system information
print_system_info() {

    # OS information
    print_table_header "🖥️ System Info" "ℹ️ Details"
    os_info

    # Kernel version
    kernel_version=$(uname -r)
    print_table_row "Kernel Version" "$kernel_version"

    # System uptime
    if ! command -v uptime &> /dev/null; then
        print_table_row "Uptime" "Command not found"
    else
        uptime=$(uptime -p)
        print_table_row "Uptime" "$uptime"
    fi

    # Disk usage information
    print_table_header "Filesystem" "Size" "Used" "Avail" "Use%" "Mounted on"
    disk_usage_info=$(df -h)
    while IFS= read -r line; do
        # Skip the header line
        if [[ "$line" == Filesystem* ]]; then
            continue
        fi
        usage=$(echo "$line" | awk '{print $5}' | sed 's/%//')
        if [[ "$usage" =~ ^[0-9]+$ ]] && [ "$usage" -ge "$disk_usage_threshold" ]; then
            print_table_row "$(echo "$line" | awk '{print $1}')" "$(echo "$line" | awk '{print $2}')" "$(echo "$line" | awk '{print $3}')" "$(echo "$line" | awk '{print $4}')" "$(echo "$line" | awk '{print $5}') (High Usage)" "$(echo "$line" | awk '{print $6}')"
        else
            print_table_row "$(echo "$line" | awk '{print $1}')" "$(echo "$line" | awk '{print $2}')" "$(echo "$line" | awk '{print $3}')" "$(echo "$line" | awk '{print $4}')" "$(echo "$line" | awk '{print $5}')" "$(echo "$line" | awk '{print $6}')"
        fi
    done <<< "$disk_usage_info"

    # Memory usage information
    print_table_header "Memory Usage" "Information"
    memory_usage_info=$(free -h)
    while IFS= read -r line; do
        print_table_row "$line"
    done <<< "$memory_usage_info"

    # CPU usage information
    print_table_header "CPU Usage" "Information"
    cpu_usage_info=$(top -bn1 | grep "Cpu(s)")
    print_table_row "CPU Usage" "$cpu_usage_info"

    # Network information
    print_table_header "Network Info" "Information"
    network_info=$(ip addr)
    while IFS= read -r line; do
        print_table_row "$line"
    done <<< "$network_info"
}

# Function to print OS information
os_info() {
    # Print uname information
    print_table_row "Kernel Name" "$(uname -s)"
    print_table_row "Node Name" "$(uname -n)"
    print_table_row "Kernel Release" "$(uname -r)"
    print_table_row "Kernel Version" "$(uname -v)"
    print_table_row "Machine" "$(uname -m)"
    print_table_row "Processor" "$(uname -p)"
    print_table_row "Hardware Platform" "$(uname -i)"
    print_table_row "Operating System" "$(uname -o)"

    # Print /etc/os-release information
    if [ -f /etc/os-release ]; then
        while IFS='=' read -r key value; do
            print_table_row "$key" "$value"
        done < /etc/os-release
    else
        print_table_row "/etc/os-release" "File not found"
    fi
}