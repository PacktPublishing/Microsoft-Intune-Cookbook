$script = @'
$Manufacturer = Get-WmiObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty Manufacturer
$Manufacturer
'@

$base64script = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($script))

$json = @"
"requirementRules": [
    {
        "@odata.type": "#microsoft.graph.win32LobAppPowerShellScriptRequirement",
        "operator": "equal",
        "detectionValue": "ACME",
        "displayName": "requirements-manufacturer.ps1",
        "enforceSignatureCheck": false,
        "runAs32Bit": false,
        "runAsAccount": "system",
        "scriptContent": "$base64script",
        "detectionType": "string"
    }
],
"@