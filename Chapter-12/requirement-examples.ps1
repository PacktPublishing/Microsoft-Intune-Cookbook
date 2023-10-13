$hotfixid = "KB5030219"
$hotfix = Get-HotFix | where-object HotFixID -eq $hotfixid
if ($hotfix) {
    write-output "Hotfix detected"
}
else {
write-output "Hotfix Not Detected"
}

#########################################################################################################


$Manufacturer = Get-WmiObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty Manufacturer
$Manufacturer

#########################################################################################################

$File = "C:\windows\system32\notepad.exe"
if (Test-Path $File) {
    write-output "Notepad detected"
}
else {
write-output "Notepad Not Detected"
}
#########################################################################################################
