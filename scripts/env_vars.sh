#!/bin/bash

########################################################
# Environment Variables Script
########################################################

# Source the common utilities script
source "$(dirname "${BASH_SOURCE[0]}")/../common/common_utils.sh"

# Set up the environment
setup_environment

# Function to print environment variables
print_env_vars() {
    print_table_header "🌍 Environment Variable" "🔧 Value"
    while IFS='=' read -r name value; do
        print_table_row "$name" "$value"
    done < <(env)
}