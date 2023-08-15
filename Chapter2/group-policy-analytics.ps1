$url = "https://graph.microsoft.com/beta/deviceManagement/groupPolicyMigrationReports/createMigrationReport"
$filepath = ""

##Get file contents to find name
# Load the XML data from a file
$xml = [xml](Get-Content -Path "$filepath")
$policyname = $xml.gpo.name

##Grab file into base64
$bytes = [System.IO.File]::ReadAllBytes($filepath)
$base64 = [System.Convert]::ToBase64String($bytes)


$json = @"
{
	"groupPolicyObjectFile": {
		"content": "$base64",
		"ouDistinguishedName": "$policyname",
		"roleScopeTagIds": [
		]
	}
}
"@

Invoke-MgGraphRequest -Method POST -Uri $url -Body $json -ContentType "application/json"
