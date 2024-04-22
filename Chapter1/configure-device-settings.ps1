# Define the device quota
$devicequota = 50
# Set to 0 to block Azure AD Registration
$azureadregister = 1
# Set to 0 to block Azure AD Join
$azureadjoin = 1
# Set to 1 to require MFA
$mfa = 0
# Set to False to block Bitlocker
$bitlocker = "true"
# Set to False to block LAPS
$laps = "true"

# Define the JSON settings for device registration
$jsonsettings = @"
    {
    "@odata.context":"https://graph.microsoft.com/beta/$metadata#policies/deviceRegistrationPolicy/$entity",
    "multiFactorAuthConfiguration":"$mfa",
    "id":"deviceRegistrationPolicy",
    "displayName":"Device Registration Policy",
    "description":"Tenant-wide policy that manages intial provisioning controls using quota restrictions, additional authentication and authorization checks",
    "userDeviceQuota":$devicequota,
    "azureADRegistration":{"appliesTo":"$azureadregister","allowedUsers":null,"allowedGroups":null,"isAdminConfigurable":false},
    "azureADJoin":{"appliesTo":"$azureadjoin","allowedUsers":[],"allowedGroups":[],"isAdminConfigurable":true},
	"localAdminPassword": {
		"isEnabled": $laps
	}
}
"@

# Define the JSON settings for Bitlocker
$jsonbitlocker = @"
{"defaultUserRolePermissions":{"allowedToReadBitlockerKeysForOwnedDevice":$bitlocker}}
"@

# Define the URIs for device registration and Bitlocker
$registrationuri = "https://graph.microsoft.com/beta/policies/deviceRegistrationPolicy"
$bitlockeruri = "https://graph.microsoft.com/beta/policies/authorizationPolicy/authorizationPolicy"

# Send the device registration settings to Microsoft Graph
Write-Host "Sending device registration settings to Microsoft Graph"
Invoke-MgGraphRequest -Method PUT -Uri $registrationuri -Body $jsonsettings -ContentType "application/json"
Write-Host "Device registration settings sent successfully"

# Send the Bitlocker settings to Microsoft Graph
Write-Host "Sending Bitlocker settings to Microsoft Graph"
Invoke-MgGraphRequest -Method PATCH -Uri $bitlockeruri -Body $jsonbitlocker -ContentType "application/json"
Write-Host "Bitlocker settings sent successfully"