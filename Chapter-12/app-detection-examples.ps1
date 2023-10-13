$Path = "HKLM:\SOFTWARE\7-Zip"
$Name = "Path"
$Type = "STRING"
$Value = "C:\Program Files\7-Zip\"

Try {
    $Registry = Get-ItemProperty -Path $Path -Name $Name -ErrorAction Stop | Select-Object -ExpandProperty $Name
    If ($Registry -eq $Value){
        Write-Output "Detected"
       Exit 0
    } 
    Exit 1
} 
Catch {
    Exit 1
}

#########################################################################################################


$File = "C:\windows\system32\notepad.exe"
if (Test-Path $File) {
    write-output "Notepad detected, exiting"
    exit 0
}
else {
    exit 1
}

#########################################################################################################


$service = get-service -name "MozillaMaintenance"
if ($service.Status -eq "Running") {
    write-output "MozillaMaintenance detected and running, exiting"
    exit 0
}
else {
   exit 1
}

#########################################################################################################


$filedate = (Get-Item "C:\Windows\System32\notepad.exe").LastWriteTime
if ($filedate -gt (Get-Date).AddDays(-1)) {
    write-output "Detected"
    exit 0
}
else {
    exit 1
}
