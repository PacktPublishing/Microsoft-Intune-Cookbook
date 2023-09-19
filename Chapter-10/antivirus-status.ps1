$exportpath = "c:\temp\antivirus-status.csv"

function getallpagination () {
[cmdletbinding()]
    
param
(
    $url
)
    $response = (Invoke-MgGraphRequest -uri $url -Method Get -OutputType PSObject)
    $alloutput = $response.value
    
    $alloutputNextLink = $response."@odata.nextLink"
    
    while ($null -ne $alloutputNextLink) {
        $alloutputResponse = (Invoke-MGGraphRequest -Uri $alloutputNextLink -Method Get -outputType PSObject)
        $alloutputNextLink = $alloutputResponse."@odata.nextLink"
        $alloutput += $alloutputResponse.value
    }
    
    return $alloutput
    }


$selectedreport = "DefenderAgents"

$fullreport = $selectedreport + "_00000000-0000-0000-0000-000000000001"

$generateurl = "https://graph.microsoft.com/beta/deviceManagement/reports/cachedReportConfigurations"

        $json = @"
        {
            "filter": "",
            "id": "$fullreport",
            "metadata": null,
            "orderBy": [
            ],
            "select": [
                "DeviceName",
                "DeviceState",
                "_ManagedBy",
                "AntiMalwareVersion",
                "CriticalFailure",
                "ProductStatus",
                "TamperProtectionEnabled",
                "IsVirtualMachine",
                "IsWDATPSenseRunning",
                "WDATPOnboardingState",
                "EngineVersion",
                "FullScanOverdue",
                "FullScanRequired",
                "LastFullScanDateTime",
                "LastQuickScanDateTime",
                "LastQuickScanSignatureVersion",
                "LastReportedDateTime",
                "MalwareProtectionEnabled",
                "NetworkInspectionSystemEnabled",
                "PendingFullScan",
                "PendingManualSteps",
                "PendingOfflineScan",
                "PendingReboot",
                "QuickScanOverdue",
                "RealTimeProtectionEnabled",
                "RebootRequired",
                "SignatureUpdateOverdue",
                "SignatureVersion",
                "UPN",
                "UserEmail",
                "UserName"
                ]
        }
"@

Invoke-MgGraphRequest -Method POST -Uri $generateurl -Body $json -ContentType "application/json"



$url = "https://graph.microsoft.com/beta/deviceManagement/reports/cachedReportConfigurations('$fullreport')"

$reportcheck = (Invoke-MgGraphRequest -uri $url -Method Get -OutputType PSObject).status

while ($reportcheck -ne "Completed") {
    $reportcheck = (Invoke-MgGraphRequest -uri $url -Method Get -OutputType PSObject).status
    Start-Sleep -Seconds 5
}

$reporturl = "https://graph.microsoft.com/beta/deviceManagement/reports/getCachedReport"

$reportjson = @"
{
	"filter": "",
	"Id": "$fullreport",
	"OrderBy": [],
	"Search": "",
    "Select": [
		"DeviceName",
		"DeviceState",
		"_ManagedBy",
		"AntiMalwareVersion",
		"CriticalFailure",
		"ProductStatus",
		"TamperProtectionEnabled",
		"IsVirtualMachine",
		"IsWDATPSenseRunning",
		"WDATPOnboardingState",
		"EngineVersion",
		"FullScanOverdue",
		"FullScanRequired",
		"LastFullScanDateTime",
		"LastQuickScanDateTime",
		"LastQuickScanSignatureVersion",
		"LastReportedDateTime",
		"MalwareProtectionEnabled",
		"NetworkInspectionSystemEnabled",
		"PendingFullScan",
		"PendingManualSteps",
		"PendingOfflineScan",
		"PendingReboot",
		"QuickScanOverdue",
		"RealTimeProtectionEnabled",
		"RebootRequired",
		"SignatureUpdateOverdue",
		"SignatureVersion",
		"UPN",
		"UserEmail",
		"UserName"
        ],
	"Skip": 0,
	"Top": 50
}
"@

$tempfilepath = $env:TEMP + "\antivirus.txt"

Invoke-MgGraphRequest -Method POST -Uri $reporturl -Body $reportjson -ContentType "application/json" -OutputFilePath $tempfilepath

$parsedData = get-content $tempfilepath | ConvertFrom-Json
$fullvalues = $parsedData.Values

$allrows = $parsedData.TotalRowCount
$n = 0
while ($n -lt $allrows) {
    $n += 50
    $tempfilepath2 = $env:TEMP + "\antivirus-$n.txt"
    $json = @"
{
	"filter": "",
	"Id": "$fullreport",
	"OrderBy": [],
	"Search": "",
    "Select": [
		"DeviceName",
		"DeviceState",
		"_ManagedBy",
		"AntiMalwareVersion",
		"CriticalFailure",
		"ProductStatus",
		"TamperProtectionEnabled",
		"IsVirtualMachine",
		"IsWDATPSenseRunning",
		"WDATPOnboardingState",
		"EngineVersion",
		"FullScanOverdue",
		"FullScanRequired",
		"LastFullScanDateTime",
		"LastQuickScanDateTime",
		"LastQuickScanSignatureVersion",
		"LastReportedDateTime",
		"MalwareProtectionEnabled",
		"NetworkInspectionSystemEnabled",
		"PendingFullScan",
		"PendingManualSteps",
		"PendingOfflineScan",
		"PendingReboot",
		"QuickScanOverdue",
		"RealTimeProtectionEnabled",
		"RebootRequired",
		"SignatureUpdateOverdue",
		"SignatureVersion",
		"UPN",
		"UserEmail",
		"UserName"
        ],
    "skip": $n,
    "top": 50
}
"@
    Invoke-MgGraphRequest -Method POST -Uri $reporturl -Body $json -ContentType "application/json" -OutputFilePath $tempfilepath2
    $tempdata = get-content $tempfilepath2 | ConvertFrom-Json
    $fullvalues += $tempdata.Values

}



        $outputarray = @()
        foreach ($value in $fullvalues) {
            $objectdetails = [pscustomobject]@{
                _ManagedBy = $value[0]
                AntiMalwareVersion = $value[2]
                CriticalFailure = $value[3]
                DeviceName = $value[4]
                DeviceState = $value[6]
                EngineVersion = $value[7]
                FullScanOverdue = $value[8]
                FullScanRequired = $value[9]
                IsVirtualMachine = $value[10]
                IsWDATPSenseRunning = $value[11]
                LastFullScanDateTime = $value[12]
                LastQuickScanDateTime = $value[13]
                LastQuickScanSignatureVersion = $value[14]
                LastReportedDateTime = $value[15]
                MalwareProtectionEnabled = $value[16]
                NetworkInspectionSystemEnabled = $value[17]
                PendingFullScan = $value[18]
                PendingManualSteps = $value[19]
                PendingOfflineScan = $value[20]
                PendingReboot = $value[21]
                QuickScanOverdue = $value[23]
                RealTimeProtectionEnabled = $value[24]
                RebootRequired = $value[25]
                SignatureUpdateOverdue = $value[26]
                SignatureVersion = $value[27]
                TamperProtectionEnabled = $value[28]
                UPN = $value[29]
                UserEmail = $value[30]
                UserName = $value[31]
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
    $tempfilepath2 = $env:TEMP + "\antivirus-$n.txt"
    Remove-Item $tempfilepath2
}