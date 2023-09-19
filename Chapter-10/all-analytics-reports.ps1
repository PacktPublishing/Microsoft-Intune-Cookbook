$exportpath = "c:\temp\analytics-report.csv"

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

    $outputarray = @()
    $outputarray += "Startup Performance - Model Performance"
    $outputarray += "Startup Performance - Device Performance"
    $outputarray += "Startup Performance - Startup Processes"
    $outputarray += "Startup Performance - Restart Frequency"
    $outputarray += "Application Reliability - App Performance"
    $outputarray += "Application Reliability - Model Performance"
    $outputarray += "Application Reliability - Device Performance"
    $outputarray += "Application Reliability - OS Version Performance"
    $outputarray += "Work from Anywhere - Model Performance"
    $outputarray += "Work from Anywhere - Device Performance"
    $outputarray += "Work from Anywhere - Windows"
    $outputarray += "Work from Anywhere - Cloud Identity"
    $outputarray += "Work from Anywhere - Cloud Management"
    $outputarray += "Work from Anywhere - Cloud Provisioning"
    $outputarray += "Resource Performance - Model Performance"
    $outputarray += "Resource Performance - Device Performance"
    $outputarray += "Remoting Connection - Model Performance"
    $outputarray += "Remoting Connection - Device Performance"

$selectedreport = $outputarray | Out-GridView -Title "Select a report to export" -PassThru

##Switch on selectedreport
switch ($selectedreport) {
    "Startup Performance - Model Performance" {
        $url = "https://graph.microsoft.com/beta/deviceManagement/userExperienceAnalyticsDevicePerformance/summarizeDevicePerformanceDevices(summarizeBy=microsoft.graph.userExperienceAnalyticsSummarizedBy'model')?dtFilter=all&`$expand=*"
    }
    "Startup Performance - Device Performance" {
        $url = "https://graph.microsoft.com/beta/deviceManagement/userExperienceAnalyticsDevicePerformance?dtFilter=all"
    }
    "Startup Performance - Startup Processes" {
        $url = "https://graph.microsoft.com/beta/deviceManagement/userExperienceAnalyticsDeviceStartupProcessPerformance?dtFilter=all"
    }
    "Startup Performance - Restart Frequency" {
        $url = "https://graph.microsoft.com/beta/deviceManagement/userExperienceAnalyticsMetricHistory/?dtFilter=all&`$select=id,metricDateTime,userExperienceAnalyticsMetric&`$expand=*"
    }
    "Application Reliability - App Performance" {
        $url = "https://graph.microsoft.com/beta/deviceManagement/userExperienceAnalyticsAppHealthApplicationPerformance?dtFilter=all&`$orderBy=appHealthScore asc"
    }
    "Application Reliability - Model Performance" {
        $url = "https://graph.microsoft.com/beta/deviceManagement/userExperienceAnalyticsAppHealthDeviceModelPerformance?dtFilter=all&`$orderBy=modelAppHealthScore asc"
    }
    "Application Reliability - Device Performance" {
        $url = "	https://graph.microsoft.com/beta/deviceManagement/userExperienceAnalyticsAppHealthDevicePerformance?dtFilter=all&`$orderBy=deviceAppHealthScore asc"
    }
    "Application Reliability - OS Version Performance" {
        $url = "https://graph.microsoft.com/beta/deviceManagement/userExperienceAnalyticsAppHealthOSVersionPerformance?dtFilter=all&`$orderBy=osVersionAppHealthScore asc"
    }
    "Work from Anywhere - Model Performance" {
        $url = "https://graph.microsoft.com/beta/deviceManagement/UserExperienceAnalyticsWorkFromAnywhereModelPerformance?`$select=id,model,manufacturer,modelDeviceCount,workFromAnywhereScore,windowsScore,cloudManagementScore,cloudIdentityScore,cloudProvisioningScore,healthStatus&dtFilter=all&`$orderBy=model asc"
    }
    "Work from Anywhere - Device Performance" {
        $url = "https://graph.microsoft.com/beta/deviceManagement/userExperienceAnalyticsWorkFromAnywhereMetrics('devicePerformance')/metricDevices?`$select=id,deviceName,model,manufacturer,workFromAnywhereScore,windowsScore,cloudManagementScore,cloudIdentityScore,cloudProvisioningScore,healthStatus&dtFilter=all&`$orderBy=deviceName asc"
    }
    "Work from Anywhere - Windows" {
        $url = "https://graph.microsoft.com/beta/deviceManagement/userExperienceAnalyticsWorkFromAnywhereMetrics('allDevices')/metricDevices?`$select=id,deviceName,managedBy,manufacturer,model,osDescription,osVersion,upgradeEligibility,azureAdJoinType,upgradeEligibility,ramCheckFailed,storageCheckFailed,processorCoreCountCheckFailed,processorSpeedCheckFailed,tpmCheckFailed,secureBootCheckFailed,processorFamilyCheckFailed,processor64BitCheckFailed,osCheckFailed&dtFilter=all&`$orderBy=osVersion asc"
    }
    "Work from Anywhere - Cloud Identity" {
        $url = "https://graph.microsoft.com/beta/deviceManagement/userExperienceAnalyticsWorkFromAnywhereMetrics('allDevices')/metricDevices?`$select=id,deviceName,managedBy,ownership,azureAdRegistered,azureAdDeviceId,azureAdJoinType&dtFilter=all&`$orderBy=azureAdRegistered asc"
    }
    "Work from Anywhere - Cloud Management" {
        $url = "https://graph.microsoft.com/beta/deviceManagement/userExperienceAnalyticsWorkFromAnywhereMetrics('allDevices')/metricDevices?`$select=id,deviceName,ownership,managedBy,tenantAttached,compliancePolicySetToIntune,otherWorkloadsSetToIntune,isCloudManagedGatewayEnabled&dtFilter=all&`$orderBy=managedBy asc"
   }
    "Work from Anywhere - Cloud Provisioning" {
        $url = "https://graph.microsoft.com/beta/deviceManagement/userExperienceAnalyticsWorkFromAnywhereMetrics('allDevices')/metricDevices?`$select=id,deviceName,serialNumber,managedBy,manufacturer,model,azureAdRegistered,autoPilotRegistered,autoPilotProfileAssigned,azureAdJoinType&dtFilter=all&`$orderBy=autoPilotRegistered asc"
    }
    "Resource Performance - Model Performance" {
        $url = "https://graph.microsoft.com/beta/deviceManagement/userExperienceAnalyticsResourcePerformance/summarizeDeviceResourcePerformance(summarizeBy=microsoft.graph.userExperienceAnalyticsSummarizedBy'model')?=&`$orderBy=deviceCount desc"
    }
    "Resource Performance - Device Performance" {
        $url = "https://graph.microsoft.com/beta/deviceManagement/userExperienceAnalyticsResourcePerformance?=&`$orderBy=deviceName asc"
    }
    "Remoting Connection - Model Performance" {
        $url = "https://graph.microsoft.com/beta/deviceManagement/userExperienceAnalyticsRemoteConnection/summarizeDeviceRemoteConnection(summarizeBy=microsoft.graph.userExperienceAnalyticsSummarizedBy'model')?=&`$orderBy=deviceCount desc"
    }
    "Remoting Connection - Device Performance" {
        $url = "	https://graph.microsoft.com/beta/deviceManagement/userExperienceAnalyticsRemoteConnection?=&`$orderBy=cloudPcRoundTripTime desc"
    }
}


$allanalytics = getallpagination -url $url


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
    if ($null -eq $allanalytics) {
       write-host "Nothing to display"
    }
    else {
        $allanalytics | export-csv $exportpath
    }

} elseif ($result -eq [System.Windows.Forms.DialogResult]::Cancel) {
    # View code here
    if ($null -eq $allanalytics) {
       write-host "Nothing to display"
    }
    else {
    $allanalytics | Out-GridView
    }
}

