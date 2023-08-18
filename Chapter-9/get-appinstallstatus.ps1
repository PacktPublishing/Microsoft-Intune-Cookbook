$exportpath = "c:\temp\appinstallstatus.csv"

$url = "https://graph.microsoft.com/beta/deviceManagement/reports/getAppsInstallSummaryReport"

$json = @"
{
    "filter": "",
    "orderBy": [],
    "select": [
        "DisplayName",
        "Publisher",
        "Platform",
        "AppVersion",
        "FailedDevicePercentage",
        "FailedDeviceCount",
        "FailedUserCount",
        "ApplicationId"
    ],
}
"@

$tempfilepath = $env:TEMP + "\appinstallstatus.txt"

Invoke-MgGraphRequest -Method POST -Uri $url -Body $json -ContentType "application/json" -OutputFilePath $tempfilepath

$parsedData = get-content $tempfilepath | ConvertFrom-Json
$fullvalues = $parsedData.Values

$allrows = $parsedData.TotalRowCount
$n = 0
while ($n -lt $allrows) {
    $n += 50
    $tempfilepath2 = $env:TEMP + "\appinstallstatus-$n.txt"
    $url = "https://graph.microsoft.com/beta/deviceManagement/reports/getAppsInstallSummaryReport"
    $json = @"
{
    "filter": "",
    "orderBy": [],
    "select": [
        "DisplayName",
        "Publisher",
        "Platform",
        "AppVersion",
        "FailedDevicePercentage",
        "FailedDeviceCount",
        "FailedUserCount",
        "ApplicationId"
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
    $id = $value[0]
    $version = $value[1]
    $appname = $value[2]
    $devicefailure = $value[3]
    $installfailure = $value[4]
    $userfailure = $value[5]
    $platform = $value[7]
    $publisher = $value[8]
    $objectdetails = [pscustomobject]@{
        ID = $id
        Version = $version
        AppName = $appname
        DeviceFailure = $devicefailure
        InstallFailurePercent = $installfailure
        UserFailure = $userfailure
        Platform = $platform
        Publisher = $publisher
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
    $tempfilepath2 = $env:TEMP + "\appinstallstatus-$n.txt"
    Remove-Item $tempfilepath2
}