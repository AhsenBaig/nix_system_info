#!/bin/bash

########################################################
# Common Utility Functions
########################################################

# Function to load a configuration file based on the script's name
load_config() {    
    local config_file="$1"
    # echo "Check config file: $config_file"
    if [ -f "$config_file" ]; then
        source "$config_file"
    #else
        #if [ "$(basename "$config_file")" != "common_utils.conf" ]; then
        #echo "NOTE: Configuration file '$config_file' not found."
        #    return 1
        #fi
    fi
}

# Function to set up the environment
setup_environment() {
    local script_name="$(basename "${BASH_SOURCE[1]}" .sh)"
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[1]}")" && pwd)"
    #echo "SCRIPT_DIR: $script_dir"

    local config_dir="$(realpath "$script_dir/../.config")"
    #echo "CONFIG_DIR: $config_dir"

    local config_file="$config_dir/${script_name}.conf"
    #echo "CONFIG_FILE: $config_file"

    # Load the configuration file
    load_config "$config_file"
}

# Function to print a table header with a variable number of columns
print_table_header() {
    printf "\n"
    local cols=("$@")
    local num_cols=${#cols[@]}
    
    # Check if num_cols is zero
    if [ "$num_cols" -eq 0 ]; then
        echo "Error: No columns provided for table header"
        return 1
    fi

    local col_width=$(( 100 / num_cols ))

    local formatted_header=""
    for col in "${cols[@]}"; do
        formatted_header+=$(printf "%-${col_width}s | " "$col")
    done
    printf "%s\n" "${formatted_header% | }"

    local separator=""
    for col in "${cols[@]}"; do
        separator+=$(printf "%-${col_width}s | " "--------------------")
    done
    printf "%s\n" "${separator% | }"
}

# Function to trim leading and trailing whitespace
trim() {
    local var="$*"
    var="${var#"${var%%[![:space:]]*}"}"
    var="${var%"${var##*[![:space:]]}"}"
    echo -n "$var"
}

# Function to print a table row with a variable number of columns
print_table_row() {
    local cols=("$@")
    local num_cols=${#cols[@]}
    
    # Check if num_cols is zero
    if [ "$num_cols" -eq 0 ]; then
        # echo "Error: No columns provided for table row"
        return 1
    fi

    local col_width=$(( 100 / num_cols ))

    local formatted_row=""
    for col in "${cols[@]}"; do
        formatted_row+=$(printf "%-${col_width}s | " "$(trim "$col")")
    done
    printf "%s\n" "${formatted_row% | }"
}