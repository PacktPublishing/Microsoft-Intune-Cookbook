$displayname = "All Users Terms of Use"
$filename = "PATH TO PDF HERE"
$filenamebase64 = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($filename))
$filenameonly = [System.IO.Path]::GetFileName($filename)
$url = "https://graph.microsoft.com/v1.0/agreements"
$json = @"
{
	"displayName": "$displayname",
	"file": {
		"localizations": [
			{
				"displayName": "$displayname",
				"fileData": {
					"data": "$filenamebase64",
                },
				"fileName": "$filenameonly",
				"isDefault": true,
				"language": "en-GB"
			}
		]
	},
	"isPerDeviceAcceptanceRequired": false,
	"isViewingBeforeAcceptanceRequired": false,
	"userReacceptRequiredFrequency": null
}
"@

Invoke-MgGraphRequest -uri $url -method post -body $json -ContentType "application/json"