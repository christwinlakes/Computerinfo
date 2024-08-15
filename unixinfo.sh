#!/bin/bash

# Get Device Serial Number
serialNumber=$(sudo dmidecode -s system-serial-number)

# Get Operating System
osInfo=$(uname -a)

# Get Firewall Status (Linux with UFW)
firewallStatus=$(sudo ufw status)

# Get Firewall Status (macOS)
# firewallStatus=$(/usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate)

# Get Antivirus Status (example with ClamAV)
antivirusStatus=$(systemctl status clamav-daemon)

# Get Encryption Status (Linux with LUKS)
encryptionStatus=$(sudo cryptsetup status <partition>)

# Get Device Manufacturer and Model
manufacturer=$(sudo dmidecode -s system-manufacturer)
model=$(sudo dmidecode -s system-product-name)

# Prepare Results
results="Serial Number: $serialNumber

Operating System: $osInfo

Firewall Status: $firewallStatus

Antivirus Status: $antivirusStatus

Encryption Status: $encryptionStatus

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
