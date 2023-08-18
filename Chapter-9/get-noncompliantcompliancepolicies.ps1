$exportpath = "c:\temp\noncompliantcompliancepolicies.csv"

$url = "https://graph.microsoft.com/beta/deviceManagement/reports/getPolicyNoncomplianceSummaryReport"

$json = @"
{
	"filter": "((PolicyBaseTypeName eq 'Microsoft.Management.Services.Api.DeviceCompliancePolicy') or (PolicyBaseTypeName eq 'DeviceManagementCompliancePolicy'))",
	"orderBy": [],
	"select": [
		"PolicyName",
		"UnifiedPolicyPlatformType",
		"NumberOfNonCompliantDevices",
		"NumberOfErrorDevices",
		"PolicyBaseTypeName",
		"PolicyId"
	]
}
"@

$tempfilepath = $env:TEMP + "\noncompliantcompliancepolicies.txt"

Invoke-MgGraphRequest -Method POST -Uri $url -Body $json -ContentType "application/json" -OutputFilePath $tempfilepath

$parsedData = get-content $tempfilepath | ConvertFrom-Json
$fullvalues = $parsedData.Values

$allrows = $parsedData.TotalRowCount
$n = 0
while ($n -lt $allrows) {
    $n += 50
    $tempfilepath2 = $env:TEMP + "\noncompliantcompliancepolicies-$n.txt"
    $url = "https://graph.microsoft.com/beta/deviceManagement/reports/getPolicyNoncomplianceSummaryReport"
    $json = @"
{
	"filter": "((PolicyBaseTypeName eq 'Microsoft.Management.Services.Api.DeviceCompliancePolicy') or (PolicyBaseTypeName eq 'DeviceManagementCompliancePolicy'))",
	"orderBy": [],
	"select": [
		"PolicyName",
		"UnifiedPolicyPlatformType",
		"NumberOfNonCompliantDevices",
		"NumberOfErrorDevices",
		"PolicyBaseTypeName",
		"PolicyId"
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
$numberoferrordevices = $value[0]
$NumberOfNonCompliantDevices = $value[1]
$PolicyBaseTypeName = $value[2]
$policyid = $value[3]
$policyname = $value[4]
$unifiedpolicyplatformtype = $value[5]

    $objectdetails = [pscustomobject]@{
        PolicyName = $policyname
        NumberOfErrorDevices = $numberoferrordevices
        NumberOfNonCompliantDevices = $NumberOfNonCompliantDevices
        UnifiedPolicyPlatformType = $unifiedpolicyplatformtype
        PolicyBaseTypeName = $PolicyBaseTypeName
        PolicyID = $policyid
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
    $selecteditems = $outputarray | Out-GridView -Title "Pick a policy to drill-down" -PassThru
foreach ($selected in $selecteditems) {
    $policyid2 = $selected.PolicyID
    $PolicyBaseTypeName2 = $selected.PolicyBaseTypeName
    ##Drill Down
    $url = "https://graph.microsoft.com/beta/deviceManagement/reports/getPolicyNoncomplianceReport"

$json = @"
{
	"filter": "((PolicyBaseTypeName eq '$PolicyBaseTypeName2') and (PolicyId eq '$policyid2'))",
	"orderBy": [],
	"select": [
		"DeviceName",
		"UPN",
		"PolicyStatus",
		"PspdpuLastModifiedTimeUtc",
		"UserId",
		"IntuneDeviceId"
	],
	"skip": 0,
	"top": 50
}
"@

$tempfilepath4 = $env:TEMP + "\noncompliantcompliancepolicies-selected.txt"

Invoke-MgGraphRequest -Method POST -Uri $url -Body $json -ContentType "application/json" -OutputFilePath $tempfilepath4

$parsedData2 = get-content $tempfilepath4 | ConvertFrom-Json
$fullvalues2 = $parsedData2.Values

$allrows2 = $parsedData2.TotalRowCount
$n2 = 0
while ($n2 -lt $allrows2) {
    $n2 += 50
    $tempfilepath3 = $env:TEMP + "\noncompliantcompliancepolicies-selected-$n.txt"
    $url = "https://graph.microsoft.com/beta/deviceManagement/reports/getPolicyNoncomplianceReport"
    $json = @"
{
	"filter": "((PolicyBaseTypeName eq '$PolicyBaseTypeName2') and (PolicyId eq '$policyid2'))",
	"orderBy": [],
	"select": [
		"DeviceName",
		"UPN",
		"PolicyStatus",
		"PspdpuLastModifiedTimeUtc",
		"UserId",
		"IntuneDeviceId"
	],
    "skip": $n,
    "top": 50
}
"@
    Invoke-MgGraphRequest -Method POST -Uri $url -Body $json -ContentType "application/json" -OutputFilePath $tempfilepath3
    $tempdata2 = get-content $tempfilepath3 | ConvertFrom-Json
    $fullvalues2 += $tempdata2.Values

}

$outputarray2 = @()
foreach ($value in $fullvalues2) {
$devicename = $value[0]
$deviceid = $value[1]
$policystatus = $value[2]
$lastmodified = $value[3]
$user = $value[4]
$userid = $value[5]

    $objectdetails = [pscustomobject]@{
        DeviceName = $devicename
        DeviceID = $deviceid
        PolicyStatus = $policystatus
        LastModified = $lastmodified
        User = $user
        UserID = $userid
    }
    $outputarray2 += $objectdetails

}

}
$outputarray2 | Out-GridView
}

Remove-Item $tempfilepath
Remove-Item $tempfilepath4
$allrows = $parsedData.TotalRowCount
$n = 0
while ($n -lt $allrows) {
    $n += 50
    $tempfilepath2 = $env:TEMP + "\noncompliantcompliancepolicies-$n.txt"
    Remove-Item $tempfilepath2
}
$allrows2 = $parsedData2.TotalRowCount
$n2 = 0
while ($n2 -lt $allrows2) {
    $n2 += 50
    $tempfilepath2 = $env:TEMP + "\noncompliantcompliancepolicies-selected-$n.txt"
    Remove-Item $tempfilepath2
}