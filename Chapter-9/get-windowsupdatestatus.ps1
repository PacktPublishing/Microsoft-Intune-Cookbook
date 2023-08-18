$exportpath = "c:\temp\windowsupdates.csv"
$outputarray = @()

##Policies
$url = "https://graph.microsoft.com/beta/deviceManagement/reports/getWindowsUpdateAlertSummaryReport"

$json = @"
{
	"filter": "",
	"orderBy": [],
	"select": [
        "PolicyName",
        "NumberOfDevicesWithErrors",
        "PolicyId"
	]
}
"@

$tempfilepath = $env:TEMP + "\summaryreport.txt"

Invoke-MgGraphRequest -Method POST -Uri $url -Body $json -ContentType "application/json" -OutputFilePath $tempfilepath

$parsedData = get-content $tempfilepath | ConvertFrom-Json
$fullvalues = $parsedData.Values
Remove-Item $tempfilepath
$allrows = $parsedData.TotalRowCount
$n = 0
while ($n -lt $allrows) {
    $n += 50
    $tempfilepath2 = $env:TEMP + "\summaryreport-$n.txt"
    $url = "https://graph.microsoft.com/beta/deviceManagement/reports/getWindowsUpdateAlertSummaryReport"
    $json = @"
{
	"filter": "",
	"orderBy": [],
	"select": [
        "PolicyName",
        "NumberOfDevicesWithErrors",
        "PolicyId"
	],
    "skip": $n,
    "top": 50
}
"@
    Invoke-MgGraphRequest -Method POST -Uri $url -Body $json -ContentType "application/json" -OutputFilePath $tempfilepath2
    $tempdata = get-content $tempfilepath2 | ConvertFrom-Json
    $fullvalues += $tempdata.Values
    Remove-Item $tempfilepath2

}


foreach ($value in $fullvalues) {
$numberoferrordevices = $value[0]
$policyid = $value[1]
$policyname = $value[2]
$type = "Policy Errors"

    $objectdetails = [pscustomobject]@{
        ReportType = $type
        PolicyName = $policyname
        ErrorDevices = $numberoferrordevices
        PolicyID = $policyid
    }
    $outputarray += $objectdetails

}



##Quality Updates
$url = "https://graph.microsoft.com/beta/deviceManagement/reports/getWindowsQualityUpdateAlertSummaryReport"

$json = @"
{
	"filter": "",
	"orderBy": [],
	"select": [
        "PolicyName",
        "NumberOfDevicesWithErrors",
        "PolicyId"
	]
}
"@

$tempfilepath = $env:TEMP + "\summaryreport.txt"

Invoke-MgGraphRequest -Method POST -Uri $url -Body $json -ContentType "application/json" -OutputFilePath $tempfilepath

$parsedData = get-content $tempfilepath | ConvertFrom-Json
$fullvalues = $parsedData.Values
Remove-Item $tempfilepath
$allrows = $parsedData.TotalRowCount
$n = 0
while ($n -lt $allrows) {
    $n += 50
    $tempfilepath2 = $env:TEMP + "\summaryreport-$n.txt"
    $url = "https://graph.microsoft.com/beta/deviceManagement/reports/getWindowsQualityUpdateAlertSummaryReport"
    $json = @"
{
	"filter": "",
	"orderBy": [],
	"select": [
        "PolicyName",
        "NumberOfDevicesWithErrors",
        "PolicyId"
	],
    "skip": $n,
    "top": 50
}
"@
    Invoke-MgGraphRequest -Method POST -Uri $url -Body $json -ContentType "application/json" -OutputFilePath $tempfilepath2
    $tempdata = get-content $tempfilepath2 | ConvertFrom-Json
    $fullvalues += $tempdata.Values
    Remove-Item $tempfilepath2

}

foreach ($value in $fullvalues) {
$numberoferrordevices = $value[0]
$policyid = $value[1]
$policyname = $value[2]
$type = "Quality Updates"

    $objectdetails = [pscustomobject]@{
        ReportType = $type
        PolicyName = $policyname
        ErrorDevices = $numberoferrordevices
        PolicyID = $policyid
    }
    $outputarray += $objectdetails

}



##Driver Updates
$url = "https://graph.microsoft.com/beta/deviceManagement/reports/getWindowsDriverUpdateAlertSummaryReport"

$json = @"
{
	"filter": "",
	"orderBy": [],
	"select": [
        "PolicyName",
        "NumberOfDevicesWithErrors",
        "PolicyId"
	]
}
"@

$tempfilepath = $env:TEMP + "\summaryreport.txt"

Invoke-MgGraphRequest -Method POST -Uri $url -Body $json -ContentType "application/json" -OutputFilePath $tempfilepath

$parsedData = get-content $tempfilepath | ConvertFrom-Json
$fullvalues = $parsedData.Values
Remove-Item $tempfilepath
$allrows = $parsedData.TotalRowCount
$n = 0
while ($n -lt $allrows) {
    $n += 50
    $tempfilepath2 = $env:TEMP + "\summaryreport-$n.txt"
    $url = "https://graph.microsoft.com/beta/deviceManagement/reports/getWindowsDriverUpdateAlertSummaryReport"
    $json = @"
{
	"filter": "",
	"orderBy": [],
	"select": [
        "PolicyName",
        "NumberOfDevicesWithErrors",
        "PolicyId"
	],
    "skip": $n,
    "top": 50
}
"@
    Invoke-MgGraphRequest -Method POST -Uri $url -Body $json -ContentType "application/json" -OutputFilePath $tempfilepath2
    $tempdata = get-content $tempfilepath2 | ConvertFrom-Json
    $fullvalues += $tempdata.Values
    Remove-Item $tempfilepath2

}

foreach ($value in $fullvalues) {
$numberoferrordevices = $value[0]
$policyid = $value[1]
$policyname = $value[2]
$type = "Driver Updates"

    $objectdetails = [pscustomobject]@{
        ReportType = $type
        PolicyName = $policyname
        ErrorDevices = $numberoferrordevices
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
    $outputarray | Out-GridView
}


##Feature Updates

$exportpath2 = "c:\temp\featureupdates.csv"

$url = "https://graph.microsoft.com/beta/deviceManagement/softwareUpdateStatusSummary"

$fulloutput = Invoke-MGGraphRequest -Uri $url -Method Get -outputType PSObject

$selectedoutput = $fulloutput | Select-Object *


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
    $selectedoutput | export-csv $exportpath2 -NoTypeInformation
} elseif ($result -eq [System.Windows.Forms.DialogResult]::Cancel) {
    # View code here
    $selectedoutput | Out-GridView
}




