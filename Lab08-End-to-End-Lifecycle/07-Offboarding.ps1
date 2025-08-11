<#
.SYNOPSIS
 Offboards a user: disable, revoke sessions, remove groups & licenses, set temp password.
#>

. "$PSScriptRoot\00-Variables.ps1"

param(
    [string]$UserUpn = $User_Sales.UserPrincipalName   # Default: Carol
)

$user = Get-MgUser -Filter "userPrincipalName eq '$UserUpn'"
if (-not $user) { throw "User not found: $UserUpn" }

Write-Host "== Offboarding $UserUpn ==" -ForegroundColor Cyan

# Disable sign-in
Update-MgUser -UserId $user.Id -AccountEnabled:$false
Write-Host "Account disabled." -ForegroundColor Green

# Revoke sessions
Revoke-MgUserSignInSession -UserId $user.Id | Out-Null
Write-Host "Sessions revoked." -ForegroundColor Green

# Remove from all groups
$groups = Get-MgUserMemberOf -UserId $user.Id -All | Where-Object '@odata.type' -match 'group'
foreach ($g in $groups) {
    try {
        Remove-MgGroupMemberByRef -GroupId $g.Id -DirectoryObjectId $user.Id -ErrorAction Stop
        Write-Host ("Removed from group: {0}" -f $g.AdditionalProperties.displayName) -ForegroundColor DarkGray
    } catch {
        Write-Warning "Could not remove from group $($g.Id): $($_.Exception.Message)"
    }
}

# Remove licenses (leave required service plans as needed)
$sub = Get-MgUserLicenseDetail -UserId $user.Id -All
$remove = @()
foreach ($l in $sub) { $remove += $l.SkuId }
if ($remove.Count -gt 0) {
    Set-MgUserLicense -UserId $user.Id -AddLicenses @() -RemoveLicenses $remove
    Write-Host "Licenses removed." -ForegroundColor Green
} else {
    Write-Host "No licenses to remove." -ForegroundColor DarkGray
}

# Set a random temp password
$pwd = -join ((48..57 + 65..90 + 97..122) | Get-Random -Count 16 | ForEach-Object {[char]$_})
$pwdProfile = @{
    forceChangePasswordNextSignIn = $true
    password                      = $pwd
}
Update-MgUser -UserId $user.Id -PasswordProfile $pwdProfile
Write-Host "Temporary password set." -ForegroundColor Green

Write-Host "Offboarding completed for $UserUpn." -ForegroundColor Cyan
