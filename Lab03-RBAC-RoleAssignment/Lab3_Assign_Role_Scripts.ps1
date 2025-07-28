# Lab 3 - Assign Azure AD Joined Device Local Administrator role to user5
# Author: Valdez Brown

# Connect to Microsoft Graph
Connect-MgGraph -Scopes "RoleManagement.ReadWrite.Directory", "User.Read.All", "Directory.Read.All"

# Set the user and role
$userUPN = "user5@brownsense.net"
$roleName = "Azure AD Joined Device Local Administrator"

# Get the user
$user = Get-MgUser -UserId $userUPN

if (-not $user) {
    Write-Error "❌ User '$userUPN' not found."
    return
}

# Get the role
$role = Get-MgRoleManagementDirectoryRoleDefinition -All | Where-Object {
    $_.DisplayName -eq $roleName
}

if (-not $role) {
    Write-Error "❌ Role '$roleName' not found in your tenant."
    return
}

# Assign the role
New-MgRoleManagementDirectoryRoleAssignment `
    -PrincipalId $user.Id `
    -RoleDefinitionId $role.Id `
    -DirectoryScopeId "/"

Write-Host "`n✅ Role '$roleName' has been assigned to '$userUPN'."

# Confirm the assignment
Get-MgRoleManagementDirectoryRoleAssignment -Filter "principalId eq '$($user.Id)'" -All |
    Where-Object { $_.RoleDefinitionId -eq $role.Id } |
    Format-List Id, PrincipalId, RoleDefinitionId
