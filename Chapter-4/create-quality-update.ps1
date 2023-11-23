##Set variables
$name = "Expedited Updates Policy"
$description = "Expedited Quality Updates"
$groupid = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
$url = "https://graph.microsoft.com/beta/deviceManagement/windowsQualityUpdateProfiles"
$daysuntilforced = "1"

function getallpagination () {
    <#
.SYNOPSIS
This function is used to grab all items from Graph API that are paginated
.DESCRIPTION
The function connects to the Graph API Interface and gets all items from the API that are paginated
.EXAMPLE
getallpagination -url "https://graph.microsoft.com/v1.0/groups"
 Returns all items
.NOTES
 NAME: getallpagination
#>
[cmdletbinding()]
    
param
(
    $url
)
    $response = (Invoke-MgGraphRequest -uri $url -Method Get -OutputType PSObject)
    $alloutput = $response.value
    
    $alloutputNextLink = $response."@odata.nextLink"
    
    while ($null -ne $alloutputNextLink) {
        $alloutputResponse = (Invoke-MGGraphRequest -Uri $alloutputNextLink -Method Get -outputType PSObject)
        $alloutputNextLink = $alloutputResponse."@odata.nextLink"
        $alloutput += $alloutputResponse.value
    }
    
    return $alloutput
    }

##Set URL
$allupdatesurl = "https://graph.microsoft.com/beta/admin/windows/updates/catalog/entries"

##Get all available updates
write-host "Getting all available updates"
$allupdates = getallpagination -url $allupdatesurl
write-host "Retrieved all available updates"
##Display them
$selectedupdate = $allupdates | Where-Object '@odata.type' -EQ "#microsoft.graph.windowsUpdates.qualityUpdateCatalogEntry" | Where-Object 'qualityUpdateClassification' -eq "security" | select-object -First 3 | select-object catalogName, releaseDateTime | Out-GridView -PassThru -Title "Select Release"

$selectedupdatedate = $selectedupdate.releaseDateTime
write-host "Selected update date is $selectedupdatedate"

##Convert to zulu
write-host "Converting to Zulu"
$selectedupdatedate = $selectedupdatedate.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")

##Populate JSON
write-host "Populating JSON"
$json = @"
{
	"description": "$description",
	"displayName": "$name",
	"expeditedUpdateSettings": {
		"daysUntilForcedReboot": $daysuntilforced,
		"qualityUpdateRelease": "$selectedupdatedate"
	},
	"roleScopeTagIds": []
}
"@
write-host "JSON populated"


##Create policy
write-host "Creating policy"
$updatepolicy = Invoke-MgGraphRequest -Uri $url -Method Post -Body $json -OutputType PSObject -ContentType "application/json"
write-host "Policy created"

$updatepolicyid = $updatepolicy.id
write-host "Policy ID is $updatepolicyid"

##Set Assignment URL and JSON
$assignurl = "https://graph.microsoft.com/beta/deviceManagement/windowsQualityUpdateProfiles/$updatepolicyid/assign"
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

##Assign
write-host "Assigning policy"
Invoke-MgGraphRequest -Uri $assignurl -Method Post -Body $assignjson -OutputType PSObject -ContentType "application/json"
write-host "Policy assigned"