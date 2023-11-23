##Get Policy ID
write-host "Getting Policy ID"
$policyid = (((Invoke-MgGraphRequest -Method GET -Uri "https://graph.microsoft.com/beta/deviceManagement/deviceEnrollmentConfigurations?`$filter=priority eq 0" -OutputType PSObject).value) | where-object '@odata.type' -eq "#microsoft.graph.deviceEnrollmentPlatformRestrictionsConfiguration").id
write-host "Policy ID: $policyid"

##Set URL
$url = "https://graph.microsoft.com/beta/deviceManagement/deviceEnrollmentConfigurations/$policyid"


##Populate JSON
$json = @"
{
	"@odata.type": "#microsoft.graph.deviceEnrollmentPlatformRestrictionsConfiguration",
	"androidForWorkRestriction": {
		"blockedManufacturers": [],
		"osMaximumVersion": "",
		"osMinimumVersion": "",
		"personalDeviceEnrollmentBlocked": true,
		"platformBlocked": false
	},
	"androidRestriction": {
		"blockedManufacturers": [],
		"osMaximumVersion": "",
		"osMinimumVersion": "",
		"personalDeviceEnrollmentBlocked": false,
		"platformBlocked": true
	},
	"macOSRestriction": {
		"blockedManufacturers": [],
		"osMaximumVersion": null,
		"osMinimumVersion": null,
		"personalDeviceEnrollmentBlocked": true,
		"platformBlocked": false
	},
	"windowsHomeSkuRestriction": {
		"blockedManufacturers": [],
		"osMaximumVersion": null,
		"osMinimumVersion": null,
		"personalDeviceEnrollmentBlocked": true,
		"platformBlocked": false
	},
	"windowsRestriction": {
		"blockedManufacturers": [],
		"osMaximumVersion": "",
		"osMinimumVersion": "",
		"personalDeviceEnrollmentBlocked": true,
		"platformBlocked": false
	}
}
"@

##Update Policy
write-host "Updating Policy"
Invoke-MgGraphRequest -Uri $url -Method PATCH -Body $json -ContentType "application/json"
write-host "Policy updated"