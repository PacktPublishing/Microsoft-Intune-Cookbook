##Set Variables
$displayname = "All Users Terms of Use"
$filename = "PATH TO PDF HERE"

##Convert PDF to Base64
$filenamebase64 = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($filename))

##Get Filename
$filenameonly = [System.IO.Path]::GetFileName($filename)

##Set URL
$url = "https://graph.microsoft.com/v1.0/agreements"

##Populate JSON
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

##Create Terms of Use
write-host "Creating Terms of Use"
Invoke-MgGraphRequest -uri $url -method post -body $json -ContentType "application/json"
write-host "Terms of Use created"