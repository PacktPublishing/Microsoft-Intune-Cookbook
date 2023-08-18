$exportpath = "c:\temp\auditlog.csv"


function getallpagination () {
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
    

$uri = "https://graph.microsoft.com/beta/deviceManagement/auditEvents"
$eventsvalues = getallpagination -url $uri
$eventsvalues =  $eventsvalues | select-object * -ExpandProperty Actor
$eventsvalues =  $eventsvalues | select-object resources, userPrincipalName, displayName, category, activityType, activityDateTime, activityOperationType, id 

$listofevents = @()
$counter = 0
foreach ($event in $eventsvalues)
{
    $counter++
    $id = $event.id
    Write-Progress -Activity 'Processing Entries' -CurrentOperation $id -PercentComplete (($counter / $eventsvalues.count) * 100)
    $eventobject = [pscustomobject]@{
        changedItem = $event.Resources.displayName
        changedBy = $event.userPrincipalName
        change = $event.displayName
        changeCategory = $event.category
        activityType = $event.activityType
        activityDateTime = $event.activityDateTime
        id = $event.id
    }
    $listofevents += $eventobject
}



Add-Type -AssemblyName System.Windows.Forms

$form = New-Object System.Windows.Forms.Form
$form.Text = "Export or View"
$form.Width = 300
$form.Height = 150
$form.StartPosition = "CenterScreen"

$label = New-Object System.Windows.Forms.Label
$label.Text = "Select an option:"
$label.Location = New-Object System.Drawing.Point(10, 20)
$label.AutoSize = $true
$form.Controls.Add($label)

$exportButton = New-Object System.Windows.Forms.Button
$exportButton.Text = "Export"
$exportButton.Location = New-Object System.Drawing.Point(100, 60)
$exportButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $exportButton
$form.Controls.Add($exportButton)

$viewButton = New-Object System.Windows.Forms.Button
$viewButton.Text = "View"
$viewButton.Location = New-Object System.Drawing.Point(180, 60)
$viewButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $viewButton
$form.Controls.Add($viewButton)

$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    # Export code here    
    if ($null -eq $listofevents) {
       write-host "Nothing to display"
    }
    else {
        $listofevents | export-csv $exportpath
    }

} elseif ($result -eq [System.Windows.Forms.DialogResult]::Cancel) {
    # View code here
    if ($null -eq $listofevents) {
       write-host "Nothing to display"
    }
    else {
        $selected = $listofevents | Out-GridView -PassThru

$selectedevents = @()

foreach ($item in $selected) {
    $selectedid = $item.id
$uri = "https://graph.microsoft.com/beta/deviceManagement/auditEvents/$selectedid"
$changedcontent = (Invoke-MgGraphRequest -Uri $uri -Method GET -ContentType "application/json" -OutputType PSObject)

$eventobject = [pscustomobject]@{
    change = $changedcontent.displayName
    changeCategory = $changedcontent.category
    activityType = $changedcontent.activityType
    activityDateTime = $changedcontent.activityDateTime
    id = $changedcontent.id
    activity = $changedcontent.activity
    activityResult = $changedcontent.activityResult
    activityOperationType = $changedcontent.activityOperationType
    componentName = $changedcontent.componentName
    type = $changedcontent.actor.type
    auditActorType = $changedcontent.actor.auditActorType
    userPermissions = $changedcontent.actor.userPermissions
    applicationId = $changedcontent.actor.applicationId
    applicationDisplayName = $changedcontent.actor.applicationDisplayName
    userPrincipalName = $changedcontent.actor.userPrincipalName
    servicePrincipalName = $changedcontent.actor.servicePrincipalName
    ipAddress = $changedcontent.actor.ipAddress
    userId = $changedcontent.actor.userId
    remoteTenantId = $changedcontent.actor.remoteTenantId
    remoteUserId = $changedcontent.actor.remoteUserId
    resourcedisplayname = $changedcontent.resource.displayName
    resourcetype = $changedcontent.resource.type
    auditResourceType = $changedcontent.resource.auditResourceType
    resourceId = $changedcontent.resource.resourceId
}

##Resources is an open-ended array depending on the size of the policy
##We can't have multiple items in the object with the same name so we'll use an incrementing number

##Set to 0
$i = 0
##Loop through the array
foreach ($resource in $changedcontent.resources.modifiedproperties) {
    ##Create a new property with the name and value
    $name = "Name" + $i
    $oldvalue = "OldValue" + $i
    $newvalue = "NewValue" + $i
    $eventobject | Add-Member -MemberType NoteProperty -Name $name -Value $resource.displayName
    $eventobject | Add-Member -MemberType NoteProperty -Name $oldvalue -Value $resource.oldValue
    $eventobject | Add-Member -MemberType NoteProperty -Name $newvalue -Value $resource.newValue
    ##Increment
    $i++
}
$selectedevents += $eventobject
}
$selectedevents | Out-GridView
    }
}




