<#
.SYNOPSIS
 Connects to Microsoft Graph with required scopes for Lab 08.
#>

param(
    [switch]$UseBeta # switch profiles to beta when needed (PIM)
)

Write-Host "== Lab 08: Connect to Microsoft Graph ==" -ForegroundColor Cyan

$scopes = @(
    "User.ReadWrite.All",
    "Group.ReadWrite.All",
    "Directory.ReadWrite.All",
    "Policy.ReadWrite.ConditionalAccess",
    "RoleManagement.ReadWrite.Directory",
    "AuditLog.Read.All"
)

# Install module if missing
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph)) {
    Write-Host "Installing Microsoft.Graph..." -ForegroundColor Yellow
    Install-Module Microsoft.Graph -Scope CurrentUser -Force
}

Import-Module Microsoft.Graph -ErrorAction Stop

if ($UseBeta) {
    Write-Host "Selecting Graph Beta profile..." -ForegroundColor Yellow
    Select-MgProfile -Name "beta"
} else {
    Select-MgProfile -Name "v1.0"
}

Connect-MgGraph -Scopes $scopes -NoWelcome

$ctx = Get-MgContext
Write-Host ("Connected to tenant: {0}" -f $ctx.TenantId) -ForegroundColor Green
