# Define the role name and user
$rolename = "Azure AD Joined Device Local Administrator"
$user = "test@test.onmicrosoft.com"

# Install the Microsoft.Graph.DeviceManagement.Enrolment module for the current user
Write-Host "Installing Microsoft.Graph.DeviceManagement.Enrolment module"
Install-Module Microsoft.Graph.DeviceManagement.Enrolment -Scope CurrentUser -Repository PSGallery -Force
Write-Host "Module installed successfully"

# Import the Microsoft.Graph.DeviceManagement.Enrolment module
Write-Host "Importing Microsoft.Graph.DeviceManagement.Enrolment module"
Import-Module Microsoft.Graph.DeviceManagement.Enrolment
Write-Host "Module imported successfully"

# Get the user ID from Microsoft Graph
Write-Host "Getting user ID"
$userid = (Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/beta/users/$user" -Method Get -OutputType PSObject).id
Write-Host "User ID obtained: $userid"

# Get the role ID to assign from Microsoft Graph
Write-Host "Getting role ID"
$uri = "https://graph.microsoft.com/beta/roleManagement/directory/roleDefinitions"
$roletoassign = (((Invoke-MgGraphRequest -Uri $uri -Method Get -OutputType PSObject).value) | where-object DisplayName -eq $rolename).id
Write-Host "Role ID obtained: $roletoassign"

# Define the parameters for the new role assignment
$params = @{
    "@odata.type" = "#microsoft.graph.unifiedRoleAssignment"
    RoleDefinitionId = "$roletoassign"
    PrincipalId = "$userid"
    DirectoryScopeId = "/"
}

# Create a new role assignment
Write-Host "Creating new role assignment"
New-MgRoleManagementDirectoryRoleAssignment -BodyParameter $params
Write-Host "Role assignment created successfully"