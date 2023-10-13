$script = @'
$Path = "HKLM:\SOFTWARE\7-Zip"
$Name = "Path"
$Type = "STRING"
$Value = "C:\Program Files\7-Zip\"

Try {
    $Registry = Get-ItemProperty -Path $Path -Name $Name -ErrorAction Stop | Select-Object -ExpandProperty $Name
    If ($Registry -eq $Value){
        Write-Output "Detected"
       Exit 0
    } 
    Exit 1
} 
Catch {
    Exit 1
}
'@

$base64script = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($script))

$json = @"
	"rules": [
		{
			"@odata.type": "#microsoft.graph.win32LobAppPowerShellScriptRule",
			"comparisonValue": null,
			"displayName": null,
			"enforceSignatureCheck": false,
			"operationType": "notConfigured",
			"operator": "notConfigured",
			"ruleType": "detection",
			"runAs32Bit": false,
			"runAsAccount": null,
			"scriptContent": "$base64script"
		}
	],
"@