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

$requests = getallpagination -url "https://graph.microsoft.com/beta/deviceManagement/operationApprovalRequests"
$selecectedrequest = $requests | where-object status -ne "completed" | Out-GridView -PassThru


$requestid = $selecectedrequest.id
$url = "https://graph.microsoft.com/beta/deviceManagement/operationApprovalRequests('$requestid')/approve"
##Approval can be Approved or Denied
$approval = "Approved"
$json = @"
{
	"justification": "$approval"
}
"@
Invoke-MgGraphRequest -uri $url -Method Post -Body $json -ContentType "application/json"