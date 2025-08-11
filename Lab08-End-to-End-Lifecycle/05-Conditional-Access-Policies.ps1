<#
.SYNOPSIS
 Creates three Conditional Access policies using Microsoft Graph.
#>

. "$PSScriptRoot\00-Variables.ps1"

function Get-GroupId([string]$name) {
    (Get-MgGroup -Filter "displayName eq '$name'").Id
}

$gIT    = Get-GroupId $Group_IT
$gHR    = Get-GroupId $Group_HR
$gSales = Get-GroupId $Group_Sales

Write-Host "== Creating Conditional Access policies ==" -ForegroundColor Cyan

# Helper to create or update CA policy
function Ensure-CAPolicy {
    param([hashtable]$Policy)

    $existing = Get-MgIdentityConditionalAccessPolicy -All | Where-Object DisplayName -eq $Policy.displayName
    if ($existing) {
        Write-Host "Updating policy: $($Policy.displayName)" -ForegroundColor Yellow
        Update-MgIdentityConditionalAccessPolicy -ConditionalAccessPolicyId $existing.Id -BodyParameter $Policy
        return $existing.Id
    } else {
        Write-Host "Creating policy: $($Policy.displayName)" -ForegroundColor Yellow
        $created = New-MgIdentityConditionalAccessPolicy -BodyParameter $Policy
        return $created.Id
    }
}

# Policy 1: Require MFA for all IT Admins
$policy1 = @{
    displayName = $CAPolicy_MFA_ITAdmins
    state       = "enabledForReportingButNotEnforced" # switch to "enabled" after testing
    conditions  = @{
        users = @{
            includeGroups = @($gIT)
        }
        applications = @{
            includeApplications = @("All")
        }
        clientAppTypes = @("all")
    }
    grantControls = @{
        operator         = "OR"
        builtInControls  = @("mfa")
    }
}

# Policy 2: Block sign-ins from outside the US for HR Staff
$policy2 = @{
    displayName = $CAPolicy_Block_HR_OutsideUS
    state       = "enabledForReportingButNotEnforced"
    conditions  = @{
        users = @{
            includeGroups = @($gHR)
        }
        locations = @{
            includeLocations = @("All")
            excludeLocations = @("AllTrusted") # trusted named locations
        }
        clientAppTypes = @("all")
    }
    grantControls = @{
        operator        = "OR"
        builtInControls = @("block")
    }
}

# Policy 3: Require compliant device for Sales Team
$policy3 = @{
    displayName = $CAPolicy_Compliant_Sales
    state       = "enabledForReportingButNotEnforced"
    conditions  = @{
        users = @{
            includeGroups = @($gSales)
        }
        clientAppTypes = @("all")
    }
    grantControls = @{
        operator        = "OR"
        builtInControls = @("compliantDevice")
    }
}

$id1 = Ensure-CAPolicy -Policy $policy1
$id2 = Ensure-CAPolicy -Policy $policy2
$id3 = Ensure-CAPolicy -Policy $policy3

Write-Host "Conditional Access policies created/updated:" -ForegroundColor Green
Write-Host " - $CAPolicy_MFA_ITAdmins ($id1)"
Write-Host " - $CAPolicy_Block_HR_OutsideUS ($id2)"
Write-Host " - $CAPolicy_Compliant_Sales ($id3)"
