# Get Device Serial Number
$serialNumber = (Get-WmiObject win32_bios).SerialNumber

# Get Operating System
$osInfo = Get-ComputerInfo -Property CsName, OsName, OsArchitecture, WindowsVersion, WindowsBuildLabEx

# Get Firewall Status
$firewallStatus = Get-NetFirewallProfile | Select-Object Name, Enabled

# Get Antivirus Status
$antivirusStatus = Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntivirusProduct

# Get BitLocker Encryption Status
$bitLockerStatus = Get-BitLockerVolume | Select-Object MountPoint, ProtectionStatus

# Get Device Manufacturer and Model
$systemInfo = Get-WmiObject -Class Win32_ComputerSystem | Select-Object Manufacturer, Model

# Prepare Results
$results = @"
Serial Number: $serialNumber

OS Info:
$($osInfo | Out-String)

Firewall Status:
$($firewallStatus | Out-String)

Antivirus Status:
$($antivirusStatus | Out-String)

BitLocker Status:
$($bitLockerStatus | Out-String)

System Info:
$($systemInfo | Out-String)
"@

# Get Desktop Path
$desktopPath = [System.Environment]::GetFolderPath('Desktop')
$outputPath = "$desktopPath\device_audit_results.txt"

# Output Results to a Text File
$results | Out-File -FilePath $outputPath

# Optional: Display results in the console
$results
