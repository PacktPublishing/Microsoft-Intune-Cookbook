$groupid = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
$Title = "Test Message"
$Body = "Alert! Alert!  That is all"

$url = "https://graph.microsoft.com/beta/deviceManagement/sendCustomNotificationToCompanyPortal"
$json= @"
{
	"groupsToNotify": [
		"$groupid"
	],
	"notificationBody": "$body",
	"notificationTitle": "$title"
}
"@

Invoke-MgGraphRequest -uri $url -Method Post -Body $json -ContentType "application/json"