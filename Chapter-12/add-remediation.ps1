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
$url = "https://graph.microsoft.com/beta/deviceManagement/deviceHealthScripts"


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

$detectionbase64encoded = [System.Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($detectionscriptcontent))

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

$remediationbase64encoded = [System.Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($remediationscriptcontent))

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

$addscript = Invoke-MgGraphRequest -Uri $url -Method Post -Body $json -ContentType "application/json" -OutputType PSObject
$scriptid = $addscript.id


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

$assignurl = "https://graph.microsoft.com/beta/deviceManagement/deviceHealthScripts/$scriptid/assign"
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
Invoke-MgGraphRequest -Uri $assignurl -Method Post -Body $assignjson -ContentType "application/json" -OutputType PSObject