$groupid = "00000000000000000000"

$baselines = @()
$edgebaseline = [pscustomobject]@{
    id = "a8d6fa0e-1e66-455b-bb51-8ce0dde1559e"
    name = "Edge Security Baseline"
    description = "Edge Security Baseline"
}
$baselines += $edgebaseline
$windowsbaseline = [pscustomobject]@{
    id = "a034ccd46-190c-4afc-adf1-ad7cc11262eb"
    name = "Windows Security Baseline"
    description = "Windows Security Baseline"
}
$baselines += $windowsbaseline

$windows365baseline = [pscustomobject]@{
    id = "cef15778-c3b9-4d53-a00a-042929f0aad0"
    name = "Windows 365 Security Baseline"
    description = "Windows 365 Security Baseline"
}
$baselines += $windows365baseline

$mdebaseline = [pscustomobject]@{
    id = "2209e067-9c8c-462e-9981-5a8c79165dcc"
    name = "MDE Security Baseline"
    description = "Microsoft Defender for Endpoint Security Baseline"
}
$baselines += $mdebaseline

foreach ($baseline in $baselines) {
    $policyname = $baseline.name
    $policydescription = $baseline.description
    $basepolicyid = $baseline.id
$uri = "https://graph.microsoft.com/beta/deviceManagement/templates/$basepolicyid/createInstance"

$json = @"

{
	"description": "$policyname",
	"displayName": "$policydescription",
	"roleScopeTagIds": [
		"0"
	],
	"settingsDelta": [
	]
}
"@

$policy = Invoke-MgGraphRequest -Method POST -Uri $uri -Body $json -ContentType "application/json" -OutputType PSObject

$policyid = $policy.id

$assignuri = "https://graph.microsoft.com/beta/deviceManagement/intents/$policyid/assign"

$assignjson = @"

{
	"assignments": [
		{
			"target": {
				"@odata.type": "#microsoft.graph.groupAssignmentTarget",
				"groupId": "$groupid"
			}
		}
	]
}

"@

Invoke-MgGraphRequest -Method POST -Uri $assignuri -Body $assignjson -ContentType "application/json"

}