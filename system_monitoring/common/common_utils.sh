#!/bin/bash

########################################################
# Common Utility Functions
########################################################

# Function to print a table header with a variable number of columns
print_table_header() {
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
        echo "Error: No columns provided for table row"
        return 1
    fi

    local col_width=$(( 100 / num_cols ))

    local formatted_row=""
    for col in "${cols[@]}"; do
        formatted_row+=$(printf "%-${col_width}s | " "$(trim "$col")")
    done
    printf "%s\n" "${formatted_row% | }"
}