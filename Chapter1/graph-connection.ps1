# Import the Microsoft Graph Authentication module
$module = Import-Module microsoft.graph.authentication -PassThru -ErrorAction Ignore

# If the module is not imported, install it
if (-not $module) {
    Write-Host "Installing module microsoft.graph.authentication"
    Install-Module microsoft.graph.authentication -Force -ErrorAction Ignore
    Write-Host "Module microsoft.graph.authentication installed successfully"
}

# Import the module globally
Write-Host "Importing module microsoft.graph.authentication globally"
Import-Module microsoft.graph.authentication -Scope Global
Write-Host "Module microsoft.graph.authentication imported globally"

# Connect to Microsoft Graph with the specified scopes
Write-Host "Connecting to Microsoft Graph with specified scopes"
Connect-MgGraph -Scopes RoleAssignmentSchedule.ReadWrite.Directory, Domain.Read.All, Domain.ReadWrite.All, Directory.Read.All, Policy.ReadWrite.ConditionalAccess, DeviceManagementApps.ReadWrite.All, DeviceManagementConfiguration.ReadWrite.All, DeviceManagementManagedDevices.ReadWrite.All, openid, profile, email, offline_access, Policy.ReadWrite.PermissionGrant,RoleManagement.ReadWrite.Directory, Policy.ReadWrite.DeviceConfiguration, DeviceLocalCredential.Read.All, DeviceManagementManagedDevices.PrivilegedOperations.All, DeviceManagementServiceConfig.ReadWrite.All, Policy.Read.All, DeviceManagementRBAC.ReadWrite.All
Write-Host "Connected to Microsoft Graph"