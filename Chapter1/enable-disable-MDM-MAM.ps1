##Set to 2 to enable or 0 to disable
$MDMstatus = 2
$MAMstatus = 2
$policyid = "Policy ID grabbed from browser"

$json = @"
{
	"appCategory": "Mdm",
	"appData": {
		"complianceUrl": "https://portal.manage.microsoft.com/?portalAction=Compliance",
		"enrollmentUrl": "https://enrollment.manage.microsoft.com/enrollmentserver/discovery.svc",
		"mamComplianceUrl": "",
		"mamEnrollmentUrl": "https://wip.mam.manage.microsoft.com/Enroll",
		"mamTermsOfUseUrl": "",
		"termsOfUseUrl": "https://portal.manage.microsoft.com/TermsofUse.aspx"
	},
	"appDisplayName": "Microsoft Intune",
	"appId": "0000000a-0000-0000-c000-000000000000",
	"isOnPrem": false,
	"logoUrl": null,
	"mamAppliesTo": $MAMstatus,
	"mamAppliesToGroups": [],
	"mdmAppliesTo": $MDMstatus,
	"mdmAppliesToGroups": [],
	"objectId": "$policyid",
	"originalAppData": {
		"complianceUrl": "https://portal.manage.microsoft.com/?portalAction=Compliance",
		"enrollmentUrl": "https://enrollment.manage.microsoft.com/enrollmentserver/discovery.svc",
		"mamComplianceUrl": "",
		"mamEnrollmentUrl": "https://wip.mam.manage.microsoft.com/Enroll",
		"mamTermsOfUseUrl": "",
		"termsOfUseUrl": "https://portal.manage.microsoft.com/TermsofUse.aspx"
	}
}
"@

$url = "https://main.iam.ad.ext.azure.com/api/MdmApplications/$policyid?mdmAppliesToChanged=true&mamAppliesToChanged=true"

##Create Access Token
$clientid = "1950a258-227b-4e31-a9cf-717495945fc2"

$response = Invoke-RestMethod -Method POST -UseBasicParsing -Uri "https://login.microsoftonline.com/$tenantId/oauth2/devicecode" -ContentType "application/x-www-form-urlencoded" -Body "resource=https%3A%2F%2Fmain.iam.ad.ext.azure.com&client_id=$clientId"
Write-Output $response.message
$waited = 0
while($true){
    try{
        $authResponse = Invoke-RestMethod -uri "https://login.microsoftonline.com/$tenantId/oauth2/token" -ContentType "application/x-www-form-urlencoded" -Method POST -Body "grant_type=device_code&resource=https%3A%2F%2Fmain.iam.ad.ext.azure.com&code=$($response.device_code)&client_id=$clientId" -ErrorAction Stop
        $refreshToken = $authResponse.refresh_token
        break
    }catch{
        if($waited -gt 300){
            Write-Verbose "No valid login detected within 5 minutes"
            Throw
        }
        #try again
        Start-Sleep -s 5
        $waited += 5
    }
}

$response = (Invoke-RestMethod "https://login.windows.net/$tenantId/oauth2/token" -Method POST -Body "resource=74658136-14ec-4630-ad9b-26e160ff0fc6&grant_type=refresh_token&refresh_token=$refreshToken&client_id=$clientId&scope=openid" -ErrorAction Stop)
    $resourceToken = $response.access_token

$Headers = @{
    "Authorization" = "Bearer " + $resourceToken
    "Content-type"  = "application/json"
    "X-Requested-With" = "XMLHttpRequest"
    "x-ms-client-request-id" = [guid]::NewGuid()
    "x-ms-correlation-id" = [guid]::NewGuid()
}


Invoke-RestMethod -Uri $url -Headers $Headers -Method PUT -Body $json -ErrorAction Stop




