#!/bin/bash

########################################################
# JAR Versions Script
########################################################

# Source the common utilities script
source "$(dirname "${BASH_SOURCE[0]}")/../common/common_utils.sh"

# Set up the environment
setup_environment

# Default values
DEFAULT_JAR_DIR="/path/to/jar/files"

# Use the value from the configuration file if set, otherwise use the environment variable, otherwise use the default value
JAR_DIR="${JAR_DIR:-$DEFAULT_JAR_DIR}"

# Function to print Jar versions information
print_jar_versions_info() {
    print_table_header "📦 Jar Versions" "ℹ️ Details"

    # Check if JAR_DIR directory exists
    if [ -d "$JAR_DIR" ]; then
        print_table_row "📂 JAR_DIR" "$JAR_DIR"
        find_jar_war_versions "$JAR_DIR"
    else
        print_table_row "📂 JAR_DIR" "Not found"
    fi
}