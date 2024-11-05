#!/bin/bash

########################################################
# Environment Variables Script
########################################################

# Source common utility functions
source "$(dirname "$0")/common_utils.sh"

# Function to print environment variables
print_env_vars() {
    print_table_header "🌍 Environment Variable" "🔧 Value"
    while IFS='=' read -r name value; do
        print_table_row "$name" "$value"
    done < <(env)
}