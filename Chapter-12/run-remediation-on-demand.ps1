$deviceid = "DeviceID"
$remediationid = "RemediationID"
$json = @"
{
	"ScriptPolicyId": "$remediationid",
}
"@
    $url = "https://graph.microsoft.com/beta/deviceManagement/managedDevices('$deviceID')/initiateOnDemandProactiveRemediation"
    Invoke-MgGraphRequest -uri $url -Method Post -Body $json -ContentType "application/json"
