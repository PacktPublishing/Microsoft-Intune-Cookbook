$name = "Android Enrollment Profile"
$description = "Corporate Owned, Fully Managed"

$url = "https://graph.microsoft.com/beta/deviceManagement/androidDeviceOwnerEnrollmentProfiles"

##Set the token expiration date
$tokenExpirationDateTime = (Get-Date).AddDays(90).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffZ")

$json = @"
{
	"configureWifi": false,
	"description": "$description",
	"displayName": "$name",
	"enrollmentMode": "corporateOwnedFullyManaged",
	"roleScopeTagIds": [],
	"tokenExpirationDateTime": "$tokenexpirationdatetime",
	"wifiHidden": false,
	"wifiPassword": "",
	"wifiSecurityType": "none",
	"wifiSsid": ""
}
"@

$androidprofile = Invoke-MgGraphRequest -Uri $url -Method Post -Body $json

$profileid = $androidprofile.id

$tokenurl = "https://graph.microsoft.com/beta/deviceManagement/androidDeviceOwnerEnrollmentProfiles/$profileid"

$androidtokendetails = Invoke-MgGraphRequest -Uri $tokenurl -Method Get

$qrbase64 = ($androidtokendetails.qrcodeimage).value

$Image = "c:\temp\AndroidQR.png"
[byte[]]$Bytes = [convert]::FromBase64String($qrbase64)
[System.IO.File]::WriteAllBytes($Image, $Bytes)

##Get Token
$androidtoken2 = ($androidtokendetails.tokenvalue)
$androidtoken2 | out-file "c:\temp\token.txt"