$biosinfo = Get-CimInstance -ClassName Win32_ComputerSystem
$manufacturer = $biosinfo.Manufacturer

$domainfirewall= ((Get-NetFirewallProfile | select Name, Enabled | where-object Name -eq Domain | select Enabled).Enabled).ToString()

$noactivemalware = Get-MpThreatDetection
if ($null -eq $noactivemalware) {
    $noactivemalware = "True"
}
else {
    $noactivemalware = "False"
}

$bitlockerprotected = (get-bitlockervolume).ProtectionStatus
$bitlockerencryption = (get-bitlockervolume).VolumeStatus

if (($bitlockerprotected -eq "On") -and ($bitlockerencryption -eq "FullyEncrypted")) {
    $bitlocker = "True"
}
else {
    $bitlocker = "False"
}

$hash = @{ 
    Manufacturer = $manufacturer
    DomainFirewall = $domainfirewall
    NoActiveMalware = $noactivemalware

    Bitlocker = $bitlocker
}

return $hash | ConvertTo-Json -Compress