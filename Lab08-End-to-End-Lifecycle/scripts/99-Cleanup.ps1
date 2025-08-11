<#
.SYNOPSIS
 Cleanup script: removes demo users, CA policies, and (optionally) groups created for the capstone.
#>

. "$PSScriptRoot\00-Variables.ps1"

param(
    [switch]$RemoveGroups
)

Write-Host "== Cleanup demo users ==" -ForegroundColor Cyan
$upns = @($User_HR.UserPrincipalName, $User_IT.UserPrincipalName, $User_Sales.UserPrincipalName)
foreach ($u in $upns) {
    $user = Get-MgUser -Filter "userPrincipalName eq '$u'"
    if ($user) {
        Write-Host "Deleting $u" -ForegroundColor Yellow
        Remove-MgUser -UserId $user.Id -Confirm:$false
    } else {
        Write-Host "User not found: $u" -ForegroundColor DarkGray
    }
}

Write-Host "== Remove Conditional Access policies ==" -ForegroundColor Cyan
$names = @($CAPolicy_MFA_ITAdmins, $CAPolicy_Block_HR_OutsideUS, $CAPolicy_Compliant_Sales)
$policies = Get-MgIdentityConditionalAccessPolicy -All | Where-Object { $names -contains $_.DisplayName }
foreach ($p in $policies) {
    Write-Host "Deleting policy: $($p.DisplayName)" -ForegroundColor Yellow
    Remove-MgIdentityConditionalAccessPolicy -ConditionalAccessPolicyId $p.Id -Confirm:$false
}

if ($RemoveGroups) {
    Write-Host "== Remove role-based groups ==" -ForegroundColor Cyan
    foreach ($gName in @($Group_HR, $Group_IT, $Group_Sales)) {
        $g = Get-MgGroup -Filter "displayName eq '$gName'"
        if ($g) {
            Remove-MgGroup -GroupId $g.Id -Confirm:$false
            Write-Host "Deleted group: $gName" -ForegroundColor Yellow
        }
    }
}

Write-Host "Cleanup completed." -ForegroundColor Green
