$name = "Script Approvals"
$description = "Require Approvals for Scripts"
$groupid = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
##Can be "scripts" or "apps"
$policytype = "scripts"
$url = "https://graph.microsoft.com/beta/deviceManagement/operationApprovalPolicies"
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

Invoke-MgGraphRequest -uri $url -Method Post -Body $json -ContentType "application/json"