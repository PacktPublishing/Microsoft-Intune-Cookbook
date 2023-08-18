$exportpath = "c:\temp\encryptionreport.csv"

$url = "https://graph.microsoft.com/beta/deviceManagement/reports/getEncryptionReportForDevices"

$json = @"
{
	"filter": "",
	"orderBy": [],
	"select": [
        "DeviceId",
        "DeviceName",
        "DeviceType",
        "OSVersion",
        "TpmSpecificationVersion",
        "EncryptionReadinessState",
        "EncryptionStatus",
        "UPN"
	]
}
"@

$tempfilepath = $env:TEMP + "\encryptionreport.txt"

Invoke-MgGraphRequest -Method POST -Uri $url -Body $json -ContentType "application/json" -OutputFilePath $tempfilepath

$parsedData = get-content $tempfilepath | ConvertFrom-Json
$fullvalues = $parsedData.Values

$allrows = $parsedData.TotalRowCount
$n = 0
while ($n -lt $allrows) {
    $n += 50
    $tempfilepath2 = $env:TEMP + "\encryptionreport-$n.txt"
    $url = "https://graph.microsoft.com/beta/deviceManagement/reports/getEncryptionReportForDevices"
    $json = @"
{
	"filter": "",
	"orderBy": [],
	"select": [
        "DeviceId",
        "DeviceName",
        "DeviceType",
        "OSVersion",
        "TpmSpecificationVersion",
        "EncryptionReadinessState",
        "EncryptionStatus",
        "UPN"
	],
    "skip": $n,
    "top": 50
}
"@
    Invoke-MgGraphRequest -Method POST -Uri $url -Body $json -ContentType "application/json" -OutputFilePath $tempfilepath2
    $tempdata = get-content $tempfilepath2 | ConvertFrom-Json
    $fullvalues += $tempdata.Values

}

$outputarray = @()
foreach ($value in $fullvalues) {
    $deviceid = $value[0]
    $devicename = $value[1]
    $OSType = $value[3]
    $readiness = $value[5]
    $encryption = $value[7]
    $OSVersion = $value[8]
    $TPMversion2 = $value[9]
    $username = $value[10]

    if ($TPMversion2 -eq "") {
        $TPMversion = "Unknown"
    }
    else {
        $TPMversion = $TPMversion2
    }

    $objectdetails = [pscustomobject]@{
        DeviceID = $deviceid
        DeviceName = $devicename
        OSVersion = $OSVersion
        OS = $OSType
        TPMVersion = $TPMversion
        EncryptionReadiness = $readiness
        EncryptionStatus = $encryption
        Username = $username
    }
  
    $outputarray += $objectdetails

}

Add-Type -AssemblyName System.Windows.Forms

$form = New-Object System.Windows.Forms.Form
$form.Text = "Export or View"
$form.Width = 300
$form.Height = 150
$form.StartPosition = "CenterScreen"

$label = New-Object System.Windows.Forms.Label
$label.Text = "Select an option:"
$label.Location = New-Object System.Drawing.Point(10, 20)
$label.AutoSize = $true
$form.Controls.Add($label)

$exportButton = New-Object System.Windows.Forms.Button
$exportButton.Text = "Export"
$exportButton.Location = New-Object System.Drawing.Point(100, 60)
$exportButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $exportButton
$form.Controls.Add($exportButton)

$viewButton = New-Object System.Windows.Forms.Button
$viewButton.Text = "View"
$viewButton.Location = New-Object System.Drawing.Point(180, 60)
$viewButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $viewButton
$form.Controls.Add($viewButton)

$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    # Export code here
    $outputarray | export-csv $exportpath -NoTypeInformation
} elseif ($result -eq [System.Windows.Forms.DialogResult]::Cancel) {
    # View code here
    $outputarray | Out-GridView
}

Remove-Item $tempfilepath
$allrows = $parsedData.TotalRowCount
$n = 0
while ($n -lt $allrows) {
    $n += 50
    $tempfilepath2 = $env:TEMP + "\appconfigstatus-$n.txt"
    Remove-Item $tempfilepath2
}