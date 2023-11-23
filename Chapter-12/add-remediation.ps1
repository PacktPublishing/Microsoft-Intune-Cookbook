##Set Variables
$DisplayName = "Clean Disk Space"
$Description = "Clears if less than 15Gb free"
$Publisher = "Your Name Here"
##RunAs can be "system" or "user"
$RunAs = "system"
##True for 32-bit, false for 64-bit
$RunAs32 = "true"
##Daily or Hourly
$ScheduleType = "Daily"
##How Often
$ScheduleFrequency = "1"
##Start Time (if daily)
$StartTime = "01:00"
$groupid = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

##Set URL
$url = "https://graph.microsoft.com/beta/deviceManagement/deviceHealthScripts"

##Set Script Content
$detectionscriptcontent = @'
$storageThreshold = 15
$utilization = (Get-PSDrive | Where {$_.name -eq "C"}).free
if(($storageThreshold *1GB) -lt $utilization){
    write-output "Storage is fine, no remediation needed"
    exit 0}
else{
    write-output "Storage is low, remediation needed"
    exit 1}
'@

##Convert to Base64
$detectionbase64encoded = [System.Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($detectionscriptcontent))


##Set Remediation Content
$remediationscriptcontent = @'
$cleanupTypeSelection = 'Temporary Sync Files', 'Downloaded Program Files', 'Memory Dump Files', 'Recycle Bin'
foreach ($keyName in $cleanupTypeSelection) {
    $newItemParams = @{
        Path         = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\$keyName"
        Name         = 'StateFlags0001'
        Value        = 1
        PropertyType = 'DWord'
        ErrorAction  = 'SilentlyContinue'
    }
    New-ItemProperty @newItemParams | Out-Null
}
Start-Process -FilePath CleanMgr.exe -ArgumentList '/sagerun:1' -NoNewWindow -Wait
'@

##Convert to Base64
$remediationbase64encoded = [System.Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($remediationscriptcontent))


##Populate JSON
$json = @"
{
	"description": "$description",
	"detectionScriptContent": "$detectionbase64encoded",
	"displayName": "$displayname",
	"enforceSignatureCheck": false,
	"publisher": "$publisher",
	"remediationScriptContent": "$remediationbase64encoded",
	"roleScopeTagIds": [
		"0"
	],
	"runAs32Bit": $runas32,
	"runAsAccount": "$runas"
}
"@

##Add Script
write-host "Adding Script"
$addscript = Invoke-MgGraphRequest -Uri $url -Method Post -Body $json -ContentType "application/json" -OutputType PSObject
write-host "Script Added"

##Get Script ID
$scriptid = $addscript.id
write-host "Script ID is $scriptid"

##Check Schedule Type and Set JSON
if($ScheduleType -eq "Daily"){
    $Schedule = @"
    "runSchedule": {
        "@odata.type": "#microsoft.graph.deviceHealthScriptDailySchedule",
        "interval": $scheduleFrequency,
        "time": "$startTime",
        "useUtc": false
    },
"@
}
else{
    $Schedule = @"
    "runSchedule": {
        "@odata.type": "#microsoft.graph.deviceHealthScriptHourlySchedule",
        "interval": $interval
    },
"@
}


##Populate ID into Assign JSON
$assignurl = "https://graph.microsoft.com/beta/deviceManagement/deviceHealthScripts/$scriptid/assign"

##Populate JSON
$assignjson = @"
{
	"deviceHealthScriptAssignments": [
		{
			"runRemediationScript": true,
            $schedule
			"target": {
				"@odata.type": "#microsoft.graph.groupAssignmentTarget",
				"groupId": "$groupid"
			}
		}
	]
}
"@

##Assign Script
write-host "Assigning Script"
Invoke-MgGraphRequest -Uri $assignurl -Method Post -Body $assignjson -ContentType "application/json" -OutputType PSObject
write-host "Script Assigned"