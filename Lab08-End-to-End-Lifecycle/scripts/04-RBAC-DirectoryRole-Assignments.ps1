<#
.SYNOPSIS
 Ensures chosen directory roles are activated and assigns users as members of those roles.
#>

. "$PSScriptRoot\00-Variables.ps1"

function Get-DirectoryRoleByDisplayName {
    param([string]$DisplayName)
    $role = Get-MgDirectoryRole -All | Where-Object DisplayName -eq $DisplayName
    if ($null -eq $role) {
        # activate from template
        $tpl = Get-MgDirectoryRoleTemplate -All | Where-Object DisplayName -eq $DisplayName
        if ($null -eq $tpl) { throw "Role template not found: $DisplayName" }
        $role = New-MgDirectoryRole -DirectoryRoleTemplateId $tpl.Id
    }
    return $role
}

function Add-UserToDirectoryRole {
    param([string]$RoleId, [string]$UserId)
    $members = Get-MgDirectoryRoleMember -DirectoryRoleId $RoleId -All
    if ($members | Where-Object Id -eq $UserId) {
        Write-Host "User already in role." -ForegroundColor DarkGray
        return
    }
    $body = @{ "@odata.id" = "https://graph.microsoft.com/v1.0/directoryObjects/$UserId" }
    New-MgDirectoryRoleMemberByRef -DirectoryRoleId $RoleId -BodyParameter $body | Out-Null
}

# Map role -> user
$assignments = @(
    @{ RoleName="User Administrator";   UserUpn=$User_IT.UserPrincipalName },    # Bob
    @{ RoleName="Reports Reader";       UserUpn=$User_HR.UserPrincipalName }     # Alice
)

foreach ($a in $assignments) {
    $role = Get-DirectoryRoleByDisplayName -DisplayName $a.RoleName
    $user = Get-MgUser -Filter "userPrincipalName eq '$($a.UserUpn)'"
    Write-Host ("Assigning {0} to {1}" -f $a.RoleName, $a.UserUpn) -ForegroundColor Yellow
    Add-UserToDirectoryRole -RoleId $role.Id -UserId $user.Id
}
Write-Host "RBAC assignments complete." -ForegroundColor Green
