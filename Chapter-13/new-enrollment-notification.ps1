##Set Variables
$policyname = "Windows Enrollment"
$policydescription = "Windows Enrollment Policy"
$emailsubject = "New Windows Device Enrolled"
$pushsubject = "New Windows Enrollment"
$emailcontent = "A new Windows device has been enrolled using your credentials. (see device details)\r\nIf this was not completed by you, please contact us on the details below.\r\n\r\nTo view a list of your devices, click on the link to Company Portal."
$pushcontent = "A new Windows device has been enrolled into Intune using your credentials. If this was not completed by you, please contact the ServiceDesk"

##Set Notification URL
$notificationurl = "https://graph.microsoft.com/beta/deviceManagement/deviceEnrollmentConfigurations"

##Set Notification JSON
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

##Create Notification Policy
write-host "Creating Notification Policy"
$notificationpolicy = Invoke-MgGraphRequest -Uri $notificationurl -Method Post -Body $notificationjson -OutputType PSObject -ContentType "application/json"
write-host "Notification Policy created"

##Get Email and Push Template IDs
$emailtemplateid = ($notificationpolicy.notificationtemplates | Where-Object { $_ -like "Email*" }).split("_")[1]
$pushtemplateid = ($notificationpolicy.notificationtemplates | Where-Object { $_ -like "Push*" }).split("_")[1]


##Set Email URL and JSON
$emailurl = "https://graph.microsoft.com/beta/deviceManagement/notificationMessageTemplates/$emailtemplateid/localizedNotificationMessages"
$emailjson = @"
{
	"isDefault": true,
	"locale": "en-US",
	"messageTemplate": "$emailcontent",
	"subject": "$emailsubject"
}
"@

##Create Email Template
write-host "Creating Email Template"
Invoke-MgGraphRequest -Uri $emailurl -Method Post -Body $emailjson -OutputType PSObject -ContentType "application/json"
write-host "Email Template created"


##Set Push URL and JSON
$pushurl = "https://graph.microsoft.com/beta/deviceManagement/notificationMessageTemplates/$pushtemplateid/localizedNotificationMessages"
$pushjson = @"
{
	"isDefault": true,
	"locale": "en-US",
	"messageTemplate": "$pushcontent",
	"subject": "$pushsubject"
}
"@
##Create Push Template
write-host "Creating Push Template"
Invoke-MgGraphRequest -Uri $pushurl -Method Post -Body $pushjson -OutputType PSObject -ContentType "application/json"
write-host "Push Template created"