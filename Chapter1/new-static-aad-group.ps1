$groupname = "TestGroup123"
$groupdescription = "TestGroupDescription"


##We will use the group name as the mail nickname but remove all spaces and special characters and convert to lowercase
$groupnickname = ($groupname -replace '[^a-zA-Z0-9]', '').ToLower()


$uri = "https://graph.microsoft.com/beta/groups/"

$json = @"
{
	"description": "$groupdescription",
	"displayName": "$groupname",
	"mailEnabled": false,
	"mailNickname": "$groupnickname",
	"securityEnabled": true
}
"@

Invoke-MgGraphRequest -Uri $uri -Method Post -Body $json -ContentType "application/json"