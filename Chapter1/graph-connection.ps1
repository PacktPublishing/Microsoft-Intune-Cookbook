        $module = Import-Module microsoft.graph.authentication -PassThru -ErrorAction Ignore
        if (-not $module) {
            Write-Host "Installing module microsoft.graph.authentication"
            Install-Module microsoft.graph.authentication -Force -ErrorAction Ignore
        }
        Import-Module microsoft.graph.authentication -Scope Global

Connect-MgGraph -Scopes RoleAssignmentSchedule.ReadWrite.Directory, Domain.Read.All, Domain.ReadWrite.All, Directory.Read.All, Policy.ReadWrite.ConditionalAccess, DeviceManagementApps.ReadWrite.All, DeviceManagementConfiguration.ReadWrite.All, DeviceManagementManagedDevices.ReadWrite.All, openid, profile, email, offline_access, Policy.ReadWrite.PermissionGrant,RoleManagement.ReadWrite.Directory, Policy.ReadWrite.DeviceConfiguration, DeviceLocalCredential.Read.All, DeviceManagementManagedDevices.PrivilegedOperations.All, DeviceManagementServiceConfig.ReadWrite.All, Policy.Read.All