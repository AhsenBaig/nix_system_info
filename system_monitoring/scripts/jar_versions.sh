#!/bin/bash

########################################################
# JAR Versions Script
########################################################

# Source common utility functions
source "$(dirname "$0")/common_utils.sh"

# Function to print JAR file versions
print_jar_versions() {
    print_table_header "📦 JAR File" "🛠️ Version"

    # Check if java command exists
    if ! command -v java &> /dev/null; then
        print_table_row "Java" "Command not found"
        return
    fi

    for jar in "$CATALINA_HOME"/lib/*.jar; do
        version_output=$(java -jar "$jar" -v 2>&1 || echo "Unknown")
        version=$(echo "$version_output" | head -n 1)
        print_table_row "$jar" "$version"
    done
}