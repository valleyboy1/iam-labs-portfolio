<#
.SYNOPSIS
 Creates role-based security groups and assigns licenses to groups (group-based licensing).
#>

. "$PSScriptRoot\00-Variables.ps1"

Write-Host "== Create role-based groups ==" -ForegroundColor Cyan

function Ensure-SecurityGroup {
    param([string]$DisplayName, [string]$Description)
    $existing = Get-MgGroup -Filter "displayName eq '$DisplayName'" -ConsistencyLevel eventual -CountVariable cnt -All
    if ($existing) {
        Write-Host "Group exists: $DisplayName" -ForegroundColor DarkGray
        return $existing[0]
    }
    Write-Host "Creating group: $DisplayName" -ForegroundColor Yellow
    return New-MgGroup -DisplayName $DisplayName -MailEnabled:$false -MailNickname ($DisplayName -replace '\s','').ToLower() -SecurityEnabled:$true -Description $Description
}

$gHR    = Ensure-SecurityGroup -DisplayName $Group_HR    -Description "HR staff with access to HR apps"
$gIT    = Ensure-SecurityGroup -DisplayName $Group_IT    -Description "IT admins"
$gSales = Ensure-SecurityGroup -DisplayName $Group_Sales -Description "Sales team members"

Write-Host "== Assign group-based licenses ==" -ForegroundColor Cyan
# Prefer official cmdlet if available (Set-MgGroupLicense). Fallback to raw Graph call otherwise.
function Set-GroupLicense {
    param(
        [string]$GroupId,
        [string[]]$AddSkuIds,
        [string[]]$RemoveSkuIds = @()
    )

    $hasCmd = Get-Command Set-MgGroupLicense -ErrorAction SilentlyContinue
    if ($hasCmd) {
        $add = @()
        foreach ($sku in $AddSkuIds) { $add += @{ SkuId = $sku } }
        Set-MgGroupLicense -GroupId $GroupId -AddLicenses $add -RemoveLicenses $RemoveSkuIds
    } else {
        $body = @{
            addLicenses    = @()
            removeLicenses = $RemoveSkuIds
        }
        foreach ($sku in $AddSkuIds) { $body.addLicenses += @{ skuId = $sku } }
        Invoke-MgGraphRequest -Method POST -Uri "https://graph.microsoft.com/v1.0/groups/$GroupId/assignLicense" -Body ($body | ConvertTo-Json -Depth 5)
    }
}

$licensesToAssign = @()
if ($E5SkuId -and $E5SkuId -notmatch "^<") { $licensesToAssign += $E5SkuId }
if ($EntraIDP2SkuId -and $EntraIDP2SkuId -notmatch "^<") { $licensesToAssign += $EntraIDP2SkuId }

if ($licensesToAssign.Count -gt 0) {
    Set-GroupLicense -GroupId $gHR.Id    -AddSkuIds $licensesToAssign
    Set-GroupLicense -GroupId $gIT.Id    -AddSkuIds $licensesToAssign
    Set-GroupLicense -GroupId $gSales.Id -AddSkuIds $licensesToAssign
    Write-Host "Group-based licensing configured." -ForegroundColor Green
} else {
    Write-Host "NOTE: Skip licensing (no SKU IDs set). Update 00-Variables.ps1." -ForegroundColor Yellow
}
