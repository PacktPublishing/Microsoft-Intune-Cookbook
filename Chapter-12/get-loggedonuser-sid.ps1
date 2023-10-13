Function Get-LoggedOnUserSID {
    # ref https://www.reddit.com/r/PowerShell/comments/7coamf/query_no_user_exists_for/
    # Modified from https://smsagent.blog/2022/03/03/user-context-detection-rules-for-intune-win32-apps/ 
    $header=@('SESSIONNAME', 'USERNAME', 'ID', 'STATE', 'TYPE', 'DEVICE')
    $Sessions = query session
    [array]$ActiveSessions = $Sessions | Select-object -Skip 1 | Where-object {$_ -match "Active"}
    If ($ActiveSessions.Count -ge 1)
    {
        $LoggedOnUsers = @()
        $indexes = $header | ForEach-Object {($Sessions[0]).IndexOf(" $_")}        
        for($row=0; $row -lt $ActiveSessions.Count; $row++)
        {
            $obj=New-Object psobject
            for($i=0; $i -lt $header.Count; $i++)
            {
                $begin=$indexes[$i]
                $end=if($i -lt $header.Count-1) {$indexes[$i+1]} else {$ActiveSessions[$row].length}
                $obj | Add-Member NoteProperty $header[$i] ($ActiveSessions[$row].substring($begin, $end-$begin)).trim()
            }
            $LoggedOnUsers += $obj
        }
 
        $LoggedOnUser = $LoggedOnUsers[0]
        $LoggedOnUserSID = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\SessionData\$($LoggedOnUser.ID)" -Name LoggedOnUserSID -ErrorAction SilentlyContinue |
            Select-object -ExpandProperty LoggedOnUserSID
        $loggedonUserName = $LoggedOnUser.USERNAME
        $UserObject = New-Object -TypeName PSObject -Property @{
            SID = $LoggedOnUserSID
            Username = $loggedonUserName
        }
        Return $UserObject    } 
}


$User = Get-LoggedOnUserSID
Write-Output "User SID: $($User.SID)"
Write-Output "Username: $($User.Username)"