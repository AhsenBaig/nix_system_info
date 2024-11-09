#!/bin/bash

########################################################
# Tomcat Info Script
########################################################

# Source the common utilities script
source "$(dirname "${BASH_SOURCE[0]}")/../common/common_utils.sh"

# Set up the environment
setup_environment

# Default values
DEFAULT_CATALINA_HOME="/usr/local/tomcat"
DEFAULT_VERSION_SCRIPT="$DEFAULT_CATALINA_HOME/bin/version.sh"  # Update this path to the correct location of version.sh

# Use the value from the configuration file if set, otherwise use the environment variable, otherwise use the default value
CATALINA_HOME="${CATALINA_HOME:-$DEFAULT_CATALINA_HOME}"
VERSION_SCRIPT="${VERSION_SCRIPT:-$CATALINA_HOME/bin/version.sh}"

# Function to print Tomcat information
print_tomcat_info() {
    print_table_header "🐱 Tomcat Info" "ℹ️ Details"

    # Check if CATALINA_HOME directory exists
    if [ -d "$CATALINA_HOME" ]; then
        print_table_row "📂 CATALINA_HOME" "$CATALINA_HOME"
    else
        print_table_row "📂 CATALINA_HOME" "Not found"
        return
    fi

    # Execute the version.sh script to get Tomcat version information
    if [ -f "$VERSION_SCRIPT" ]; then
        version_output=$(bash "$VERSION_SCRIPT")
        declare -A version_info=(
            ["📂 Using CATALINA_BASE"]="$(echo "$version_output" | grep 'Using CATALINA_BASE' | cut -d':' -f2- | xargs)"
            ["📂 Using CATALINA_HOME"]="$(echo "$version_output" | grep 'Using CATALINA_HOME' | cut -d':' -f2- | xargs)"
            ["📂 Using CATALINA_TMPDIR"]="$(echo "$version_output" | grep 'Using CATALINA_TMPDIR' | cut -d':' -f2- | xargs)"
            ["📂 Using JRE_HOME"]="$(echo "$version_output" | grep 'Using JRE_HOME' | cut -d':' -f2- | xargs)"
            ["📂 Using CLASSPATH"]="$(echo "$version_output" | grep 'Using CLASSPATH' | cut -d':' -f2- | xargs)"
            ["📂 Using CATALINA_OPTS"]="$(echo "$version_output" | grep 'Using CATALINA_OPTS' | cut -d':' -f2- | xargs)"
            ["🔖 Server Version"]="$(echo "$version_output" | grep 'Server version' | cut -d':' -f2- | xargs)"
            ["🔧 Server Built"]="$(echo "$version_output" | grep 'Server built' | cut -d':' -f2- | xargs)"
            ["🔧 Server Number"]="$(echo "$version_output" | grep 'Server number' | cut -d':' -f2- | xargs)"
            ["🔧 OS Name"]="$(echo "$version_output" | grep 'OS Name' | cut -d':' -f2- | xargs)"
            ["🔧 OS Version"]="$(echo "$version_output" | grep 'OS Version' | cut -d':' -f2- | xargs)"
            ["🔧 Architecture"]="$(echo "$version_output" | grep 'Architecture' | cut -d':' -f2- | xargs)"
            ["🔧 JVM Version"]="$(echo "$version_output" | grep 'JVM Version' | cut -d':' -f2- | xargs)"
            ["🔧 JVM Vendor"]="$(echo "$version_output" | grep 'JVM Vendor' | cut -d':' -f2- | xargs)"
        )
        for key in "${!version_info[@]}"; do
            if [ -z "${version_info[$key]}" ]; then
                print_table_row "$key" "Not specified"
            else
                print_table_row "$key" "${version_info[$key]}"
            fi
        done
    else
        print_table_row "🔖 Tomcat Version" "version.sh not found in: $VERSION_SCRIPT"
    fi

    # Tomcat server.xml location
    server_xml="$CATALINA_HOME"/conf/server.xml
    if [ ! -f "$server_xml" ]; then
        print_table_row "📄 server.xml Location" "server.xml not found"
        return
    fi
    print_table_row "📄 server.xml Location" "$server_xml"

    # Tomcat running ports
    running_ports=$(grep 'Connector port' "$server_xml" | awk -F'"' '{print $2}' | tr '\n' ', ' | sed 's/, $//')
    print_table_row "🔌 Running Ports" "$running_ports"

    # Check if ls command exists
    if ! command -v ls &> /dev/null; then
        print_table_row "Deployed Applications" "ls command not found"
        return
    fi

    # Tomcat deployed applications
    deployed_apps=$(ls "$CATALINA_HOME"/webapps | tr '\n' ', ' | sed 's/, $//')
    if [ -z "$deployed_apps" ]; then
        print_table_row "🚀 Deployed Applications" "None"
    else
        print_table_row "🚀 Deployed Applications" "$deployed_apps"
    fi

    # Tomcat service information
    print_table_header "Tomcat Service" "Information"
    tomcat_service_info=$(ps aux | grep tomcat | grep -v grep)
    print_table_row "Tomcat Service" "$tomcat_service_info"

    # Check for .jar and .war files in the webapps directory
    print_table_header "📦 Jar Versions" "ℹ️ Details"
    webapps_dir="$CATALINA_HOME/webapps"
    if [ -d "$webapps_dir" ]; then
        print_table_row "📂 Webapps Directory" "$webapps_dir"
        find_jar_war_versions "$webapps_dir"
    else
        print_table_row "📂 Webapps Directory" "Not found"
    fi
}