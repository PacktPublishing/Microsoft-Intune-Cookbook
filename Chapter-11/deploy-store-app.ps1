$appname = "Company Portal"
$scope = "user" ##Can be user or system
$groupid = "000-000-000-000"
$storeSearchUrl = "https://storeedgefd.dsx.mp.microsoft.com/v9.0/manifestSearch"
$body = @{
    Query = @{
        KeyWord   = $appName
        MatchType = "Substring"
    }
} | ConvertTo-Json
$appSearch = Invoke-RestMethod -Uri $storeSearchUrl -Method POST -ContentType 'application/json' -body $body
$exactApp = $appSearch.Data | Where-Object { $_.PackageName -eq $appName }

$appUrl = "https://storeedgefd.dsx.mp.microsoft.com/v9.0/packageManifests/{0}" -f $exactApp.PackageIdentifier
$app = Invoke-RestMethod -Uri $appUrl -Method GET 
$appId = $app.Data.PackageIdentifier
$appInfo = $app.Data.Versions[-1].DefaultLocale
$appInstaller = $app.Data.Versions[-1].Installers


$imageUrl = "https://apps.microsoft.com/store/api/ProductsDetails/GetProductDetailsById/{0}?hl=en-US&gl=US" -f $exactApp.PackageIdentifier
$image = Invoke-RestMethod -Uri $imageUrl -Method GET 
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($image.IconUrl, "./temp.jpg")
$base64string = [Convert]::ToBase64String([IO.File]::ReadAllBytes('./temp.jpg'))

    $appdescription = ($appInfo.Shortdescription).ToString()
    $appdescription2 = $appdescription.replace("`n"," ").replace("`r"," ").replace("\n"," ").replace("\\n"," ")
    $appdeveloper = $appInfo.Publisher
    $appdisplayName = $appInfo.packageName
    $appinformationUrl = $appInfo.PublisherSupportUrl
    $apprunAsAccount = $scope
    $appisFeatured = $false
    $apppackageIdentifier = $appId
    $appprivacyInformationUrl = $appInfo.PrivacyUrl
    $apppublisher = $appInfo.publisher

    $deployUrl = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps"
$json = @"
{
	"@odata.type": "#microsoft.graph.winGetApp",
	"categories": [],
	"description": "$appdescription2",
	"developer": "$appdeveloper",
	"displayName": "$appdisplayName",
	"informationUrl": "$appinformationUrl",
	"installExperience": {
		"runAsAccount": "$apprunAsAccount"
	},
	"isFeatured": false,
	"largeIcon": {
        "@odata.type": "#microsoft.graph.mimeContent",
        "type": "string",
        "value": "$base64string"
    	},
	"notes": "",
	"owner": "",
	"packageIdentifier": "$apppackageIdentifier",
	"privacyInformationUrl": "$appprivacyInformationUrl",
	"publisher": "$apppublisher",
	"repositoryType": "microsoftStore",
	"roleScopeTagIds": []
}
"@

$appDeploy = Invoke-mggraphrequest -uri $deployUrl -Method POST -Body $json -ContentType "application/JSON"
$appdeployid = $appDeploy.id

$JSON = @"
{
    "mobileAppAssignments": [
        {
            "@odata.type": "#microsoft.graph.mobileAppAssignment",
            "intent": "Required",
            "settings": {
                "@odata.type": "#microsoft.graph.winGetAppAssignmentSettings",
                "installTimeSettings": null,
                "notifications": "showAll",
                "restartSettings": null
            },
            "target": {
                "@odata.type": "#microsoft.graph.groupAssignmentTarget",
                "groupId": "$groupid"
            }
        }
    ]
}
"@

$uri = "https://graph.microsoft.com/Beta/deviceAppManagement/mobileApps/$appdeployid/assign"
Invoke-MgGraphRequest -Uri $uri -Method Post -Body $JSON -ContentType "application/json"