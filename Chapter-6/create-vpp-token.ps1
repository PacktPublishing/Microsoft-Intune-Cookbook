##Set Variables
$url = "https://graph.microsoft.com/beta/deviceAppManagement/vppTokens"
$tokenpath = "c:\temp\vpptoken.vpp"
$appleid = "APPLEID"
$tokentype = "business"
$name = "Apple VPP"

##Convert the token to base64
write-host "Converting token to base64"
$token = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes([System.IO.File]::ReadAllText($tokenpath)))
write-host "Token converted to base64"

##Populate JSON
$json = @"
{
	"@odata.type": "#microsoft.graph.vppToken",
	"appleId": "$appleid",
	"automaticallyUpdateApps": true,
	"claimTokenManagementFromExternalMdm": false,
	"countryOrRegion": "gb",
	"dataSharingConsentGranted": true,
	"displayName": "$name",
	"roleScopeTagIds": [
		"0"
	],
	"token": "$token",
	"vppTokenAccountType": "$tokentype"
}
"@

##Create Token
write-host "Creating token"
Invoke-MgGraphRequest -Uri $url -Method Post -Body $json -ContentType "application/json"
write-host "Token created"