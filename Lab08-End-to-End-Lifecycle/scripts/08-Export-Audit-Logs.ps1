<#
.SYNOPSIS
 Exports recent sign-ins and directory audit logs to CSV files.
#>

param(
    [int]$Days = 7
)

$since = (Get-Date).AddDays(-$Days).ToUniversalTime().ToString("o")

$outDir = Join-Path $PSScriptRoot "..\docs\audit-exports"
New-Item -ItemType Directory -Path $outDir -Force | Out-Null

Write-Host "== Exporting Audit Logs since $since ==" -ForegroundColor Cyan

$signins = Get-MgAuditLogSignIn -All | Where-Object { $_.CreatedDateTime -ge $since }
$signins | Select-Object userDisplayName, userPrincipalName, ipAddress, appDisplayName, status, createdDateTime |
    Export-Csv (Join-Path $outDir "signins.csv") -NoTypeInformation

$audits = Get-MgAuditLogDirectoryAudit -All | Where-Object { $_.ActivityDateTime -ge $since }
$audits | Select-Object activityDateTime, activityDisplayName, initiatedBy, targetResources |
    Export-Csv (Join-Path $outDir "directoryAudits.csv") -NoTypeInformation

Write-Host "Exports saved to $outDir" -ForegroundColor Green
