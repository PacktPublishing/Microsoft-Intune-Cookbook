$groupname = "TestGroup123"
$groupdescription = "TestGroupDescription"

##Note: We have single quotes around the rule because we are using double quotes in the rule and also escaping the double quotes
$membershiprule = '(user.assignedPlans -any (assignedPlan.servicePlanId -eq \"43de0ff5-c92c-492b-9116-175376d08c38\" -and assignedPlan.capabilityStatus -eq \"Enabled\")'


##We will use the group name as the mail nickname but remove all spaces and special characters and convert to lowercase
$groupnickname = ($groupname -replace '[^a-zA-Z0-9]', '').ToLower()


$url = "https://graph.microsoft.com/beta/groups"

$json = @"
{
	"description": "$groupdescription",
	"displayName": "$groupname",
	"groupTypes": [
		"DynamicMembership"
	],
	"mailEnabled": false,
	"mailNickname": "$groupnickname",
	"membershipRule": $membershiprule,
	"membershipRuleProcessingState": "On",
	"securityEnabled": true
}
"@

Invoke-MgGraphRequest -Uri $url -Method Post -Body $json -ContentType "application/json"