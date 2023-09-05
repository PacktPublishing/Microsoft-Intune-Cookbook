$displayname = "User One"
$givenname = "User"
$surname = "One"
$usageLocation = "GB"
$mailNickname = "user1"
$password = "PASSWORD HERE"
$domainname = "DOMAIN HERE"

$json = @"
{
	"accountEnabled": true,
	"displayName": "$displayname",
	"givenName": "$givenname",
	"mailNickname": "$mailNickname",
	"passwordProfile": {
		"forceChangePasswordNextSignIn": true,
		"password": "$password"
	},
	"surname": "$surname",
	"usageLocation": "$usageLocation",
	"userPrincipalName": "$mailnickname@$domainname"
}
"@

$uri = "https://graph.microsoft.com/beta/users"

Invoke-MgGraphRequest -Method POST -Uri $uri -Body $json -ContentType "application/json"