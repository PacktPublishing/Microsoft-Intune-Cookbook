$admxpath = "PATH TO ADMX FILE"
$admlpath = "PATH TO ADML FILE"
$language = "en-US"
$url = "https://graph.microsoft.com/beta/deviceManagement/groupPolicyUploadedDefinitionFiles"

##Get the filenames only from the path
$admxfile = Split-Path -Path $admxpath -Leaf
$admlfile = Split-Path -Path $admlpath -Leaf

##Get the file contents and convert to base64
$admxcontent = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($admxpath))
$admlcontent = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($admlpath))

$json = @"
{
	"content": "$admxcontent",
	"defaultLanguageCode": "",
	"fileName": "$admxfile",
	"groupPolicyUploadedLanguageFiles": [
		{
			"content": "$admlcontent",
			"fileName": "$admlfile",
			"languageCode": "$language"
		}
	]
}
"@

invoke-mggraphrequest -Method POST -Uri $url -Body $json -ContentType "application/json"