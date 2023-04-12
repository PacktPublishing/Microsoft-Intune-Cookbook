$devicequota = 50
##Set to 0 to block Azure AD Registration
$azureadregister = 1
##Set to 0 to block Azure AD Join
$azureadjoin = 1
##Set to 1 to require MFA
$mfa = 0
##Set to False to block Bitlocker
$bitlocker = "true"


$jsonsettings = @"
{"@odata.context":"https://graph.microsoft.com/beta/$metadata#policies/deviceRegistrationPolicy/$entity",
"multiFactorAuthConfiguration":"$mfa",
"id":"deviceRegistrationPolicy",
"displayName":"Device Registration Policy",
"description":"Tenant-wide policy that manages intial provisioning controls using quota restrictions, additional authentication and authorization checks",
"userDeviceQuota":$devicequota,
"azureADRegistration":{"appliesTo":"$azureadregister","allowedUsers":null,"allowedGroups":null,"isAdminConfigurable":false},
"azureADJoin":{"appliesTo":"$azureadjoin","allowedUsers":[],"allowedGroups":[],"isAdminConfigurable":true}
}
"@

$jsonbitlocker = @"
{"defaultUserRolePermissions":{"allowedToReadBitlockerKeysForOwnedDevice":$bitlocker}}
"@

$registrationuri = "https://graph.microsoft.com/beta/policies/deviceRegistrationPolicy"
$bitlockeruri = "https://graph.microsoft.com/beta/policies/authorizationPolicy/authorizationPolicy"

Invoke-MgGraphRequest -Method PUT -Uri $registrationuri -Body $jsonsettings -ContentType "application/json"

Invoke-MgGraphRequest -Method PATCH -Uri $bitlockeruri -Body $jsonbitlocker -ContentType "application/json"
