$exportpath = "c:\temp\policycompliance.csv"

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

##Send a sync first
$syncurl = "https://graph.microsoft.com/beta/deviceManagement/deviceCompliancePolicies/refreshDeviceComplianceReportSummarization"
Invoke-MgGraphRequest -Method POST -Uri $syncurl

##Sleep for 1 minute
Start-Sleep -Seconds 60

$url = "https://graph.microsoft.com/beta/deviceManagement/deviceCompliancePolicies?`$select=id,displayName,lastModifiedDateTime,roleScopeTagIds,microsoft.graph.androidCompliancePolicy/deviceThreatProtectionRequiredSecurityLevel,microsoft.graph.androidWorkProfileCompliancePolicy/deviceThreatProtectionRequiredSecurityLevel,microsoft.graph.iosCompliancePolicy/deviceThreatProtectionRequiredSecurityLevel,microsoft.graph.windows10CompliancePolicy/deviceThreatProtectionRequiredSecurityLevel,microsoft.graph.iosCompliancePolicy/advancedThreatProtectionRequiredSecurityLevel,microsoft.graph.androidWorkProfileCompliancePolicy/advancedThreatProtectionRequiredSecurityLevel,microsoft.graph.androidDeviceOwnerCompliancePolicy/advancedThreatProtectionRequiredSecurityLevel,microsoft.graph.androidDeviceOwnerCompliancePolicy/deviceThreatProtectionRequiredSecurityLevel,microsoft.graph.androidCompliancePolicy/advancedThreatProtectionRequiredSecurityLevel&`$expand=deviceStatusOverview,assignments"

$fulloutput = getallpagination -url $url

$selectedoutput = $fulloutput | Select-Object -Property id, displayName, @{Name="Name"; Expression={$_.deviceStatusOverview.Name}}, @{Name="pendingCount"; Expression={$_.deviceStatusOverview.pendingCount}}, @{Name="notApplicableCount"; Expression={$_.deviceStatusOverview.notApplicableCount}}, @{Name="notApplicablePlatformCount"; Expression={$_.deviceStatusOverview.notApplicablePlatformCount}}, @{Name="successCount"; Expression={$_.deviceStatusOverview.successCount}}, @{Name="errorCount"; Expression={$_.deviceStatusOverview.errorCount}}, @{Name="failedCount"; Expression={$_.deviceStatusOverview.failedCount}}, @{Name="conflictCount"; Expression={$_.deviceStatusOverview.conflictCount}}

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
    $selectedoutput | export-csv $exportpath
} elseif ($result -eq [System.Windows.Forms.DialogResult]::Cancel) {
    # View code here
    $selection = $selectedoutput | Out-GridView -PassThru

    foreach ($item in $selection) {
        $policyid = $item.id
        $url = "https://graph.microsoft.com/beta/deviceManagement/deviceCompliancePolicies/$policyid/deviceStatuses"
        $fulloutput = getallpagination -url $url
        $selectedoutput = $fulloutput | Select-Object deviceDisplayName, userName, status, userPrincipalName, deviceModel, lastReportedDateTime | Out-GridView
    }
}

