Connect-MgGraph -Scopes RoleAssignmentSchedule.ReadWrite.Directory, Domain.Read.All, Domain.ReadWrite.All, Directory.Read.All, Policy.ReadWrite.ConditionalAccess, DeviceManagementApps.ReadWrite.All, DeviceManagementConfiguration.ReadWrite.All, DeviceManagementManagedDevices.ReadWrite.All, openid, profile, email, offline_access, Policy.ReadWrite.PermissionGrant,RoleManagement.ReadWrite.Directory, Policy.ReadWrite.DeviceConfiguration, DeviceLocalCredential.Read.All, DeviceManagementManagedDevices.PrivilegedOperations.All, DeviceManagementServiceConfig.ReadWrite.All, Policy.Read.All, WindowsUpdates.ReadWrite.All

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

$allupdatesurl = "https://graph.microsoft.com/beta/admin/windows/updates/catalog/entries"

$allupdates = getallpagination -url $allupdatesurl

$selectedupdate = $allupdates | Where-Object '@odata.type' -EQ "#microsoft.graph.windowsUpdates.qualityUpdateCatalogEntry" | Where-Object 'qualityUpdateClassification' -eq "security" | select-object -First 3 | select-object catalogName, releaseDateTime | Out-GridView -PassThru -Title "Select Release"

$selectedupdatedate = $selectedupdate.releaseDateTime

##Convert to zulu
$selectedupdatedate = $selectedupdatedate.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
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

$updatepolicy = Invoke-MgGraphRequest -Uri $url -Method Post -Body $json -OutputType PSObject -ContentType "application/json"

$updatepolicyid = $updatepolicy.id


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

Invoke-MgGraphRequest -Uri $assignurl -Method Post -Body $assignjson -OutputType PSObject -ContentType "application/json"