$exportpath = "c:\temp\userenrollmentfailures.csv"

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

 $reporttypes = @()
    $reporttypes += "DeviceCompliance"   
    $reporttypes += "NoncompliantDevicesAndSettings"
    $reporttypes += "DevicesWithoutCompliancePolicy"
    $reporttypes += "SettingComplianceAggReport"
    $reporttypes += "PolicyComplianceAggReport"

$selectedreport = $reporttypes | Out-GridView -PassThru -Title "Select Report"

$fullreport = $selectedreport + "_00000000-0000-0000-0000-000000000001"

$generateurl = "https://graph.microsoft.com/beta/deviceManagement/reports/cachedReportConfigurations"

        $json = @"
        {
            "filter": "",
            "id": "$fullreport",
            "metadata": null,
            "orderBy": [
                "PolicyName asc"
            ],
            "select": []
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


switch ($selectedreport) {
    "DeviceCompliance" {
        $jsonselection = @"
        "Select": [
            "DeviceName",
            "UPN",
            "ComplianceState",
            "OS",
            "OSVersion",
            "OwnerType",
            "LastContact"
        ],
"@
    }
    "NoncompliantDevicesAndSettings" {
        $jsonselection = @"
        "Select": [
            "DeviceName",
            "SettingName",
            "PolicyName",
            "CalculatedPolicyVersion",
            "LatestPolicyVersion",
            "SettingStatus",
            "ErrorCodeString",
            "UPN",
            "OS",
            "LastContact"
        ],
"@
    }
    "DevicesWithoutCompliancePolicy" {
        $jsonselection = @"
        "Select": [
            "DeviceId",
            "DeviceName",
            "DeviceModel",
            "DeviceType",
            "OSDescription",
            "OSVersion",
            "OwnerType",
            "ManagementAgents",
            "UserId",
            "PrimaryUser",
            "UPN",
            "UserEmail",
            "UserName",
            "AadDeviceId",
            "OS"
        ],
"@
    }
    "SettingComplianceAggReport" {
        $jsonselection = @"
        "Select": [
        ],
"@
    }
    "PolicyComplianceAggReport" {
        $jsonselection = @"
        "Select": [
        ],
"@
    }
}


$reportjson = @"
{
	"filter": "",
	"Id": "$fullreport",
	"OrderBy": [],
	"Search": "",
$jsonselection
	"Skip": 0,
	"Top": 50
}
"@

$tempfilepath = $env:TEMP + "\compliance-report.txt"

Invoke-MgGraphRequest -Method POST -Uri $reporturl -Body $reportjson -ContentType "application/json" -OutputFilePath $tempfilepath

$parsedData = get-content $tempfilepath | ConvertFrom-Json
$fullvalues = $parsedData.Values

$allrows = $parsedData.TotalRowCount
$n = 0
while ($n -lt $allrows) {
    $n += 50
    $tempfilepath2 = $env:TEMP + "\compliancereport-$n.txt"
    $json = @"
{
	"filter": "",
	"Id": "$fullreport",
	"OrderBy": [],
	"Search": "",
$jsonselection
    "skip": $n,
    "top": 50
}
"@
    Invoke-MgGraphRequest -Method POST -Uri $reporturl -Body $json -ContentType "application/json" -OutputFilePath $tempfilepath2
    $tempdata = get-content $tempfilepath2 | ConvertFrom-Json
    $fullvalues += $tempdata.Values

}


switch ($selectedreport) {
    "DeviceCompliance" {
        $outputarray = @()
        foreach ($value in $fullvalues) {
            $objectdetails = [pscustomobject]@{
                DeviceName = $value[2]
                ComplianceState = $value[1]
                LastContact = $value[3]
                OS = $value[5]
                OSVersion = $value[6]
                OwnershipType = $value[8]
                User = $value[9]
            }
        
        
            $outputarray += $objectdetails
        
        }
    }
    "NoncompliantDevicesAndSettings" {
        $outputarray = @()
        foreach ($value in $fullvalues) {
            $objectdetails = [pscustomobject]@{
                DeviceName = $value[1]
                SettingName = $value[7]
                PolicyName = $value[6]
                CalculatedPolicyVersion = $value[0]
                LatestPolicyVersion = $value[4]
                SettingStatus = $value[9]
                ErrorCodeString = $value[2]
                OS = $value[5]
                LastContact = $value[3]
                User = $value[10]
            }
        
        
            $outputarray += $objectdetails
        
        }
    }
    "DevicesWithoutCompliancePolicy" {
        $outputarray = @()
        foreach ($value in $fullvalues) {
            $objectdetails = [pscustomobject]@{
                DeviceId = $value[1]
                DeviceName = $value[3]
                DeviceModel = $value[2]
                DeviceType = $value[2]
                OSVersion = $value[10]
                OwnershipType = $value[12]
                ManagementAgents = $value[6]
                UserId = $value[12]
                PrimaryUser = $value[15]
                UserEmail = $value[14]
                UserName = $value[17]
                AadDeviceId = $value[0]
                OS = $value[7]
            }
        
        
            $outputarray += $objectdetails
        
        }
    }
    "SettingComplianceAggReport" {
        $outputarray = @()
        foreach ($value in $fullvalues) {
            $objectdetails = [pscustomobject]@{
            setting = $value[3]
            Platform = $value[5]
            CompliantDevices = $value[6]
            NonCompliantDevices = $value[7]
            NotEvaluatedDevices = $value[8]
            NotApplicableDevices = $value[9]
            ConflictDevices = $value[10]
            }
        
        
            $outputarray += $objectdetails
        
        }
    }
    "PolicyComplianceAggReport" {
        $outputarray = @()
        foreach ($value in $fullvalues) {
            $objectdetails = [pscustomobject]@{
            PolicyName = $value[1]
            Platform = $value[3]
            CompliantDevices = $value[4]
            NonCompliantDevices = $value[5]
            Error = $value[6]
            NotEvaluatedDevices = $value[7]
            NotApplicableDevices = $value[8]
            ConflictDevices = $value[9]
            }
        
        
            $outputarray += $objectdetails
        
        }
    }
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
    $tempfilepath2 = $env:TEMP + "\compliancereport-$n.txt"
    Remove-Item $tempfilepath2
}