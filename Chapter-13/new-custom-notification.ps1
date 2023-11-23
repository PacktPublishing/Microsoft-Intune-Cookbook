##Set Variables
groupid = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
$Title = "Test Message"
$Body = "Alert! Alert!  That is all"
##Set URL
$url = "https://graph.microsoft.com/beta/deviceManagement/sendCustomNotificationToCompanyPortal"

##Populate JSON
$json= @"
{
	"groupsToNotify": [
		"$groupid"
	],
	"notificationBody": "$body",
	"notificationTitle": "$title"
}
"@

##Create Custom Notification
write-host "Creating Custom Notification"
Invoke-MgGraphRequest -uri $url -Method Post -Body $json -ContentType "application/json"
write-host "Custom Notification created"