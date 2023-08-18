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

    $todaydate = Get-Date -Format "yyyy-MM-ddTHH:mm:ss.fffZ"
    $lastmonthdate = (Get-Date).AddDays(-30).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")

$url = "https://graph.microsoft.com/beta/reports/managedDeviceEnrollmentAbandonmentSummary(skip=null,top=null,filter='eventDateUTC%20ge%20dateTime''$lastmonthdate''%20and%20eventDateUTC%20le%20dateTime''$todaydate''',skipToken=null)/content"

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
    $selectedoutput | Out-GridView -PassThru
}

