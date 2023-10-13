$policyname = "Windows Enrollment"
$policydescription = "Windows Enrollment Policy"
$emailsubject = "New Windows Device Enrolled"
$pushsubject = "New Windows Enrollment"
$emailcontent = "A new Windows device has been enrolled using your credentials. (see device details)\r\nIf this was not completed by you, please contact us on the details below.\r\n\r\nTo view a list of your devices, click on the link to Company Portal."
$pushcontent = "A new Windows device has been enrolled into Intune using your credentials. If this was not completed by you, please contact the ServiceDesk"

$notificationurl = "https://graph.microsoft.com/beta/deviceManagement/deviceEnrollmentConfigurations"
$notificationjson = @"
{
	"@odata.type": "#microsoft.graph.deviceEnrollmentNotificationConfiguration",
	"brandingOptions": "includeCompanyLogo,includeCompanyName,includeCompanyPortalLink,includeContactInformation,includeDeviceDetails",
	"defaultLocale": "en-US",
	"description": "$policydescription",
	"displayName": "$policyname",
	"notificationTemplates": [
		"email_00000000-0000-0000-0000-000000000000",
		"push_00000000-0000-0000-0000-000000000000"
	],
	"platformType": "windows",
	"roleScopeTagIds": [
		"0"
	]
}
"@

$notificationpolicy = Invoke-MgGraphRequest -Uri $notificationurl -Method Post -Body $notificationjson -OutputType PSObject -ContentType "application/json"
$emailtemplateid = ($notificationpolicy.notificationtemplates | Where-Object { $_ -like "Email*" }).split("_")[1]
$pushtemplateid = ($notificationpolicy.notificationtemplates | Where-Object { $_ -like "Push*" }).split("_")[1]


$emailurl = "https://graph.microsoft.com/beta/deviceManagement/notificationMessageTemplates/$emailtemplateid/localizedNotificationMessages"
$emailjson = @"
{
	"isDefault": true,
	"locale": "en-US",
	"messageTemplate": "$emailcontent",
	"subject": "$emailsubject"
}
"@
Invoke-MgGraphRequest -Uri $emailurl -Method Post -Body $emailjson -OutputType PSObject -ContentType "application/json"

$pushurl = "https://graph.microsoft.com/beta/deviceManagement/notificationMessageTemplates/$pushtemplateid/localizedNotificationMessages"
$pushjson = @"
{
	"isDefault": true,
	"locale": "en-US",
	"messageTemplate": "$pushcontent",
	"subject": "$pushsubject"
}
"@
Invoke-MgGraphRequest -Uri $pushurl -Method Post -Body $pushjson -OutputType PSObject -ContentType "application/json"