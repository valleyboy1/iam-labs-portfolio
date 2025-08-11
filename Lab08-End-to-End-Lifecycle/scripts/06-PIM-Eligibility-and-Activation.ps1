<#
.SYNOPSIS
 Makes Bob eligible for Global Administrator using PIM (Graph beta), then requests activation.
 NOTE: Requires Entra ID P2 and Graph Beta profile.
#>

. "$PSScriptRoot\00-Variables.ps1"

# Switch to beta profile (required for schedule requests)
Select-MgProfile -Name "beta"

# Resolve principal (Bob)
$bob = Get-MgUser -Filter "userPrincipalName eq '$($User_IT.UserPrincipalName)'"

# Resolve role definition for Global Administrator
$gaRole = Get-MgRoleManagementDirectoryRoleDefinition -All | Where-Object DisplayName -eq $PIM_EligibleRoleDisplayName
if (-not $gaRole) { throw "Role definition not found: $PIM_EligibleRoleDisplayName" }

Write-Host "== Creating eligibility request for $($bob.UserPrincipalName) ==" -ForegroundColor Cyan

$eligibilityRequest = @{
    action            = "adminAssign"
    justification     = $PIM_Justification
    roleDefinitionId  = $gaRole.Id
    directoryScopeId  = "/"
    principalId       = $bob.Id
    scheduleInfo      = @{
        startDateTime = (Get-Date).ToUniversalTime().ToString("o")
        expiration    = @{
            type     = "afterDuration"
            duration = $PIM_EligibilityDuration
        }
    }
}

$eligReq = New-MgRoleManagementDirectoryRoleEligibilityScheduleRequest -BodyParameter $eligibilityRequest
Write-Host "Eligibility request submitted. ID: $($eligReq.Id)" -ForegroundColor Green

# Optional: request activation (requires an approver policy if configured)
Write-Host "Requesting activation (if approvals required, complete via portal)..." -ForegroundColor Yellow
$activationRequest = @{
    action            = "selfActivate"
    justification     = "Testing activation for capstone"
    roleDefinitionId  = $gaRole.Id
    directoryScopeId  = "/"
    principalId       = $bob.Id
    scheduleInfo      = @{
        startDateTime = (Get-Date).ToUniversalTime().ToString("o")
        expiration    = @{
            type     = "afterDuration"
            duration = "PT1H"
        }
    }
}

try {
    $actReq = New-MgRoleManagementDirectoryRoleAssignmentScheduleRequest -BodyParameter $activationRequest -ErrorAction Stop
    Write-Host "Activation request submitted. ID: $($actReq.Id)" -ForegroundColor Green
} catch {
    Write-Warning "Activation request failed. You may need to configure PIM approval settings or eligible assignment first. Error: $($_.Exception.Message)"
}

# Switch back to v1 profile for other scripts
Select-MgProfile -Name "v1.0"
