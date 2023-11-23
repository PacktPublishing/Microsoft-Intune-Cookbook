##Set variables
$name = "Script Approvals"
$description = "Require Approvals for Scripts"
$groupid = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
##Can be "scripts" or "apps"
$policytype = "scripts"

##Set URL
$url = "https://graph.microsoft.com/beta/deviceManagement/operationApprovalPolicies"

##Populate JSON
$json = @"
{
	"approverGroupIds": [
		"$groupid"
	],
	"description": "$description",
	"displayName": "$name",
	"policyType": "$policytype"
}
"@

##Create Approval Policy
write-host "Creating Approval Policy"
Invoke-MgGraphRequest -uri $url -Method Post -Body $json -ContentType "application/json"
write-host "Approval Policy created"