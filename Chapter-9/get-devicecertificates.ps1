$exportpath = "c:\temp\devicecertificates.csv"

$url = "https://graph.microsoft.com/beta/deviceManagement/reports/getAllCertificatesReport"

$json = @"
{
	"filter": "",
	"orderBy": [],
	"select": [
		"DeviceName",
		"UPN",
		"Thumbprint",
		"SerialNumber",
		"SubjectName",
		"IssuerName",
		"KeyUsage",
		"EnhancedKeyUsage",
		"ValidFrom",
		"ValidTo",
		"CertificateStatus",
		"PolicyId"
	]
}
"@

$tempfilepath = $env:TEMP + "\devicecertificates.txt"

Invoke-MgGraphRequest -Method POST -Uri $url -Body $json -ContentType "application/json" -OutputFilePath $tempfilepath

$parsedData = get-content $tempfilepath | ConvertFrom-Json
$fullvalues = $parsedData.Values

$allrows = $parsedData.TotalRowCount
$n = 0
while ($n -lt $allrows) {
    $n += 50
    $tempfilepath2 = $env:TEMP + "\devicecertificates-$n.txt"
    $url = "https://graph.microsoft.com/beta/deviceManagement/reports/getAllCertificatesReport"
    $json = @"
{
	"filter": "",
	"orderBy": [],
	"select": [
		"DeviceName",
		"UPN",
		"Thumbprint",
		"SerialNumber",
		"SubjectName",
		"IssuerName",
		"KeyUsage",
		"EnhancedKeyUsage",
		"ValidFrom",
		"ValidTo",
		"CertificateStatus",
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
    $devicename = $value[1]
    $username = $value[9]
    $thumbprint = $value[8]
    $serialnumber = $value[6]
    $subjectname = $value[7]
    $issuername = $value[3]
    $keyusage = $value[4]
    $enhancedkeyusage = $value[2]
    $validfrom = $value[10]
    $validto = $value[11]
    $certificatestatus = $value[0]
    $policyid = $value[5]

    $objectdetails = [pscustomobject]@{
        DeviceName = $devicename
        Username = $username
        Thumbprint = $thumbprint
        SerialNumber = $serialnumber
        SubjectName = $subjectname
        IssuerName = $issuername
        KeyUsage = $keyusage
        EnhancedKeyUsage = $enhancedkeyusage
        ValidFrom = $validfrom
        ValidTo = $validto
        CertificateStatus = $certificatestatus
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

Remove-Item $tempfilepath
$allrows = $parsedData.TotalRowCount
$n = 0
while ($n -lt $allrows) {
    $n += 50
    $tempfilepath2 = $env:TEMP + "\appconfigstatus-$n.txt"
    Remove-Item $tempfilepath2
}