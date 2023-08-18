$exportpath = "c:\temp\appprotectstatus.csv"

$url = "https://graph.microsoft.com/beta/deviceManagement/reports/getMobileApplicationManagementAppRegistrationSummaryReport"

$json = @"
{
    "filter": "",
    "orderBy": [],
    "select": [
        "User",
        "Email",
        "App",
        "AppVersion",
        "AppInstanceId",
        "DeviceType",
        "AADDeviceID",
        "ManagementType",
        "_Platform",
        "Policy",
        "LastSync",
        "DeviceName",
        "DeviceManufacturer",
        "DeviceModel",
        "AndroidPatchVersion",
        "MDMDeviceID",
        "PlatformVersion",
        "AppProtectionStatus",
        "SdkVersion",
        "ComplianceState"
    ]
}
"@

$tempfilepath = $env:TEMP + "\appprotectstatus.txt"

Invoke-MgGraphRequest -Method POST -Uri $url -Body $json -ContentType "application/json" -OutputFilePath $tempfilepath

$parsedData = get-content $tempfilepath | ConvertFrom-Json
$fullvalues = $parsedData.Values

$allrows = $parsedData.TotalRowCount
$n = 0
while ($n -lt $allrows) {
    $n += 50
    $tempfilepath2 = $env:TEMP + "\appprotectstatus-$n.txt"
    $url = "https://graph.microsoft.com/beta/deviceManagement/reports/getMobileApplicationManagementAppRegistrationSummaryReport"
    $json = @"
{
    "filter": "",
    "orderBy": [],
    "select": [
        "User",
        "Email",
        "App",
        "AppVersion",
        "AppInstanceId",
        "DeviceType",
        "AADDeviceID",
        "ManagementType",
        "_Platform",
        "Policy",
        "LastSync",
        "DeviceName",
        "DeviceManufacturer",
        "DeviceModel",
        "AndroidPatchVersion",
        "MDMDeviceID",
        "PlatformVersion",
        "AppProtectionStatus",
        "SdkVersion",
        "ComplianceState"
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
    $platform = $value[0]
    $aaddeviceid = $value[1]
    $app = $value[3]
    $appinstanceid = $value[4]
    $appprotectionstatus = $value[5]
    $appversion = $value[6]
    $compliancestate = $value[7]
    $devicemodel = $value[9]
    $devicename = $value[10]
    $devicetype = $value[11]
    $email = $value[12]
    $lastsync = $value[13]
    $managementtype = $value[14]
    $platformversion = $value[16]
    $policyname = $value[17]
    $iossdkversion = $value[18]
    $user = $value[19]

    $objectdetails = [pscustomobject]@{
        Platform = $platform
        AADDeviceID = $aaddeviceid
        App = $app
        AppInstanceID = $appinstanceid
        AppProtectionStatus = $appprotectionstatus
        AppVersion = $appversion
        ComplianceState = $compliancestate
        DeviceModel = $devicemodel
        DeviceName = $devicename
        DeviceType = $devicetype
        Email = $email
        LastSync = $lastsync
        ManagementType = $managementtype
        PlatformVersion = $platformversion
        PolicyName = $policyname
        iOSSDKVersion = $iossdkversion
        User = $user
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