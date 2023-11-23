##Set Variables
$name = "Android Enrollment Profile"
$description = "Corporate Owned, Fully Managed"

##Set URL
$url = "https://graph.microsoft.com/beta/deviceManagement/androidDeviceOwnerEnrollmentProfiles"

##Set the token expiration date
$tokenExpirationDateTime = (Get-Date).AddDays(90).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffZ")

##Populate JSON
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

##Create Profile
write-host "Creating Android Enrollment Profile"
$androidprofile = Invoke-MgGraphRequest -Uri $url -Method Post -Body $json
write-host "Profile created successfully"

##Get ID
$profileid = $androidprofile.id

##Populate URK
$tokenurl = "https://graph.microsoft.com/beta/deviceManagement/androidDeviceOwnerEnrollmentProfiles/$profileid"

##Get Token details
write-host "Getting Token Details"
$androidtokendetails = Invoke-MgGraphRequest -Uri $tokenurl -Method Get
write-host "Token Details retrieved successfully"

##Get QR Code
$qrbase64 = ($androidtokendetails.qrcodeimage).value

$Image = "c:\temp\AndroidQR.png"
[byte[]]$Bytes = [convert]::FromBase64String($qrbase64)
[System.IO.File]::WriteAllBytes($Image, $Bytes)

##Get Token
$androidtoken2 = ($androidtokendetails.tokenvalue)

##Export Token
write-host "Exporting Token"
$androidtoken2 | out-file "c:\temp\token.txt"
write-host "Token exported successfully to c:\temp\token.txt"