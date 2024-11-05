#!/bin/bash

########################################################
# Main Script to Call Individual Functions
########################################################

# Source common utility functions
source "$(dirname "$0")/../common/common_utils.sh"

echo "---------------------------------------- ` date ` ----------------------------------------"

# Function to display usage information
usage() {
    echo "Usage: $0 [function_name]"
    echo "Available functions:"
    for func in "${!functions[@]}"; do
        echo "  $func"
    done
    exit 1
}

# Declare an associative array to map function names to function calls
declare -A functions

# Dynamically source all scripts in the scripts directory
for script in "$(dirname "$0")"/*.sh; do
    # Skip the main script itself
    [ "$script" != "$(dirname "$0")/$(basename "$0")" ] && source "$script"
done

# Dynamically register functions
for func in $(declare -F | awk '{print $3}'); do
    case "$func" in
        print_*)
            functions[$func]=$func
            ;;
    esac
done

# Execute all functions if no arguments are provided
if [ $# -eq 0 ]; then
    for func in "${!functions[@]}"; do
        ${functions[$func]}
    done
else
    # Execute the specified function
    if [[ -n "${functions[$1]}" ]]; then
        ${functions[$1]}
    else
        usage
    fi
fi

# Print a new line at the end
printf "\n"