

##Enable LAPS in AAD
$checkuri = "https://graph.microsoft.com/beta/policies/deviceRegistrationPolicy"
$currentpolicy = Invoke-MgGraphRequest -Method GET -Uri $checkuri -OutputType PSObject -ContentType "application/json"
$currentpolicy.localAdminPassword.isEnabled = $true
$policytojson = $currentpolicy | ConvertTo-Json
Invoke-MgGraphRequest -Method PUT -Uri $checkuri -Body $policytojson -ContentType "application/json"
