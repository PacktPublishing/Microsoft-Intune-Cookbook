$policyid = ((Invoke-MgGraphRequest -Method GET -uri "https://graph.microsoft.com/beta/deviceManagement/deviceEnrollmentConfigurations" -OutputType PSObject).value | where-object '@odata.type' -eq "#microsoft.graph.deviceEnrollmentWindowsHelloForBusinessConfiguration").id

$url = "https://graph.microsoft.com/beta/deviceManagement/deviceEnrollmentConfigurations/$policyid"

$json = @"
{
	"@odata.type": "#microsoft.graph.deviceEnrollmentWindowsHelloForBusinessConfiguration",
	"enhancedBiometricsState": "enabled",
	"pinLowercaseCharactersUsage": "allowed",
	"pinPreviousBlockCount": 3,
	"pinSpecialCharactersUsage": "allowed",
	"pinUppercaseCharactersUsage": "allowed",
	"securityDeviceRequired": true,
	"securityKeyForSignIn": "enabled",
	"state": "enabled"
}
"@

Invoke-MgGraphRequest -Method PATCH -Uri $url -Body $json -ContentType "application/json" -OutputType PSObject
