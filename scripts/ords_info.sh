#!/bin/bash

########################################################
# ORDS Info Script
########################################################

# Source common utility functions
source "$(dirname "$0")/common_utils.sh"

# Default values
DEFAULT_ORDS_SHARED_PATH="/u01/ords"
DEFAULT_ORDS_CONFIG_PATH="/default/path/to/ords"

# Load configuration file
CONFIG_FILE="$(dirname "$0")/.scripts_config/ords_info.conf"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
fi

# Use the value from the configuration file if set, otherwise use the environment variable, otherwise use the default value
ords_shared_path="${ords_shared_path:-$DEFAULT_ORDS_SHARED_PATH}"
ords_config_path="${ORDS_CONFIG:-$ords_config_path}"

# Recursive function to list files and directories in order
list_files_recursive() {
    local path="$1"
    for file in $(ls -1v "$path"); do
        local full_path="$path/$file"
        if [ -d "$full_path" ]; then
            print_table_row "$path" "$file/"
            list_files_recursive "$full_path"
        else
            print_table_row "$path" "$file"
        fi
    done
}

# Function to print ORDS information
print_ords_info() {
    print_table_header "🔧 ORDS Info" "ℹ️ Details"

    # Check if ORDS configuration directory exists
    # ords_config="$CATALINA_HOME"/conf/ords
    if [ -d "$ords_config" ]; then
        print_table_row "📄 ORDS Config Location" "$ords_config"
    else
        print_table_row "📄 ORDS Config Location" "Not found"
    fi

    # Check if ORDS WAR file exists and get version
    ords_war="$CATALINA_HOME"/lib/ords.war
    if [ -f "$ords_war" ]; then
        ords_version=$(java -jar "$ords_war" version 2>&1 | grep "Oracle REST Data Services" | head -n 1)
        print_table_row "🔖 ORDS Version" "$ords_version"
    else
        print_table_row "🔖 ORDS Version" "ORDS WAR file not found"
    fi

    # Check and list files in ords_shared_path
    if [ -d "$ords_shared_path" ]; then
        print_table_header "📂 ORDS Shared Path" "🗂️ Files"
        list_files_recursive "$ords_shared_path"
    else
        print_table_row "📂 ORDS Shared Path" "Path not found"
    fi
}