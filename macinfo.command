#!/bin/bash

# Function to get device serial number, manufacturer, and model
get_hardware_info() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        serialNumber=$(sudo dmidecode -s system-serial-number)
        manufacturer=$(sudo dmidecode -s system-manufacturer)
        model=$(sudo dmidecode -s system-product-name)
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        serialNumber=$(system_profiler SPHardwareDataType | awk '/Serial Number/ {print $4}')
        manufacturer="Apple Inc."
        model=$(system_profiler SPHardwareDataType | awk '/Model Identifier/ {print $3}')
    else
        serialNumber="Unknown"
        manufacturer="Unknown"
        model="Unknown"
    fi
}

# Function to get OS info
get_os_info() {
    osInfo=$(uname -a)
}

# Function to get firewall status
get_firewall_status() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        firewallStatus=$(sudo ufw status)
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        firewallStatus=$(/usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate)
    else
        firewallStatus="Unknown"
    fi
}

# Function to get antivirus status
get_antivirus_status() {
    declare -A antivirusPrograms=(
        ["clamav"]="ClamAV: $(systemctl is-active clamav-daemon)"
        ["sophos"]="Sophos: $(/usr/local/bin/sophos-av/bin/savdstatus 2>/dev/null)"
        ["bitdefender"]="Bitdefender: $(/opt/BitDefender-scanner/bin/bdscan --version 2>/dev/null)"
        ["avg"]="AVG: $(/usr/bin/avgctl --version 2>/dev/null)"
    )

    antivirusStatus=""
    for av in "${!antivirusPrograms[@]}"; do
        if command -v $av &> /dev/null; then
            status="${antivirusPrograms[$av]}"
            antivirusStatus="$antivirusStatus$status"$'\n'
        fi
    done

    if [ -z "$antivirusStatus" ]; then
        antivirusStatus="No antivirus software found."
    fi
}

# Function to get encryption status
get_encryption_status() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        encryptionStatus=$(sudo cryptsetup status <partition>)
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        encryptionStatus=$(fdesetup status)
    else
        encryptionStatus="Unknown"
    fi
}

# Function to get network encryption type
get_network_encryption_type() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        encryptionType=$( /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/link auth|auth/ {print $NF}')
    else
        encryptionType="Unknown"
    fi
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
