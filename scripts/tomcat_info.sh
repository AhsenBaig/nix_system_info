#!/bin/bash

########################################################
# Tomcat Info Script
########################################################

# Source the common utilities script
source "$(dirname "${BASH_SOURCE[0]}")/../common/common_utils.sh"

# Set up the environment
setup_environment

# Function to print Tomcat information
print_tomcat_info() {
    print_table_header "🐱 Tomcat Info" "ℹ️ Details"

    # Tomcat version
    if [ ! -f "$CATALINA_HOME"/RELEASE-NOTES ]; then
        print_table_row "🔖 Tomcat Version" "RELEASE-NOTES not found"
    else
        tomcat_version=$(grep "Apache Tomcat" "$CATALINA_HOME"/RELEASE-NOTES | head -n 1)
        if [ -z "$tomcat_version" ]; then
            print_table_row "🔖 Tomcat Version" "Version not found"
        else
            print_table_row "🔖 Tomcat Version" "$tomcat_version"
        fi
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
}