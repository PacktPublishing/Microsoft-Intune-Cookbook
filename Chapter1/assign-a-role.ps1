$rolename = "Azure AD Joined Device Local Administrator"
$user = "test@test.onmicrosoft.com"

$userid = (Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/beta/users/$user" -Method Get -OutputType PSObject).id
$uri = "https://graph.microsoft.com/beta/roleManagement/directory/roleDefinitions"
$roletoassign = (((Invoke-MgGraphRequest -Uri $uri -Method Get -OutputType PSObject).value) | where-object DisplayName -eq $rolename).id

$params = @{
	"@odata.type" = "#microsoft.graph.unifiedRoleAssignment"
	RoleDefinitionId = "$roletoassign"
	PrincipalId = "$userid"
	DirectoryScopeId = "/"
}
New-MgRoleManagementDirectoryRoleAssignment -BodyParameter $params