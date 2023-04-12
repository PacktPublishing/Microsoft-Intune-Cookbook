Install-Module -Name Microsoft.Graph.Authentication -Scope CurrentUser -Repository PSGallery -Force

import-module microsoft.graph.authentication

Connect-MgGraph -Scopes RoleAssignmentSchedule.ReadWrite.Directory, Domain.Read.All, Domain.ReadWrite.All, Directory.Read.All, Policy.ReadWrite.ConditionalAccess, DeviceManagementApps.ReadWrite.All, DeviceManagementConfiguration.ReadWrite.All, DeviceManagementManagedDevices.ReadWrite.All, openid, profile, email, offline_access, Policy.ReadWrite.PermissionGrant,RoleManagement.ReadWrite.Directory
