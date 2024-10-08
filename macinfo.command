#!/bin/bash

# Function to get device serial number, manufacturer, and model
get_hardware_info() {
    serialNumber=$(system_profiler SPHardwareDataType | awk '/Serial Number/ {print $4}')
    manufacturer="Apple Inc."
    model=$(system_profiler SPHardwareDataType | awk '/Model Identifier/ {print $3}')
}

# Function to get OS info
get_os_info() {
    osInfo=$(uname -a)
}

# Function to get firewall status
get_firewall_status() {
    firewallStatus=$(/usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate)
}

# Function to get antivirus status (for macOS only)
get_antivirus_status() {
    if command -v /usr/local/bin/sophos-av/bin/savdstatus &> /dev/null; then
        antivirusStatus="Sophos Antivirus is installed."
    elif command -v /opt/BitDefender-scanner/bin/bdscan &> /dev/null; then
        antivirusStatus="Bitdefender is installed."
    else
        antivirusStatus="No third-party antivirus software found."
    fi
}

# Function to get encryption status
get_encryption_status() {
    encryptionStatus=$(fdesetup status)
}

# Function to get network encryption type
get_network_encryption_type() {
    encryptionType=$( /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/link auth|auth/ {print $NF}')
}

# Execute functions
get_hardware_info
get_os_info
get_firewall_status
get_antivirus_status
get_encryption_status
get_network_encryption_type

# Prepare Results
results="Serial Number: $serialNumber

Operating System: $osInfo

Firewall Status: $firewallStatus

Antivirus Status:
$antivirusStatus

Encryption Status: $encryptionStatus

Network Encryption Type: $encryptionType

Manufacturer: $manufacturer

Model: $model
"

# Get Documents Path
documentsPath="$HOME/Documents"
outputPath="$documentsPath/device_audit_results.txt"

# Output Results to a Text File
echo "$results" > "$outputPath"

# Optional: Display results in the console
echo "$results"
