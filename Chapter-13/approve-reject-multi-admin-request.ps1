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

    ##Get all requests
    write-host "Getting all requests"
$requests = getallpagination -url "https://graph.microsoft.com/beta/deviceManagement/operationApprovalRequests"
##Select the request to approve
$selecectedrequest = $requests | where-object status -ne "completed" | Out-GridView -PassThru

##Get the request ID
$requestid = $selecectedrequest.id
write-host "Approving request $requestid"

##Set URL
$url = "https://graph.microsoft.com/beta/deviceManagement/operationApprovalRequests('$requestid')/approve"
##Approval can be Approved or Denied
$approval = "Approved"

##Set JSON
$json = @"
{
	"justification": "$approval"
}
"@

##Send request
write-host "Sending request"
Invoke-MgGraphRequest -uri $url -Method Post -Body $json -ContentType "application/json"
write-host "Request sent"