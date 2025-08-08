<# 
Lab 07 (Phase 2): Advanced Conditional Access via Microsoft Graph PowerShell
Author: Valdez Brown (iam-labs-portfolio)
Purpose: Create 3 CA policies that mirror the portal lab, using clear "PowerShell" identifiers.
Prereqs:
  - Microsoft.Graph PowerShell SDK installed
  - Role: Global Administrator or Conditional Access Administrator
  - Named Location: "United States" (Countries/Regions) already created
#>

param(
    [switch]$WhatIfOnly = $false
)

# ---- Helper: Connect to Microsoft Graph with correct scopes ----
function Connect-GraphIfNeeded {
    $ctx = Get-MgContext -ErrorAction SilentlyContinue
    if (-not $ctx) {
        Write-Host "Connecting to Microsoft Graph..." -ForegroundColor Cyan
        Connect-MgGraph -Scopes "Policy.ReadWrite.ConditionalAccess","Directory.Read.All"
    } else {
        # Ensure scopes contain Policy.ReadWrite.ConditionalAccess
        if ($ctx.Scopes -notcontains "Policy.ReadWrite.ConditionalAccess") {
            Write-Host "Reconnecting with required scopes..." -ForegroundColor Yellow
            Disconnect-MgGraph -ErrorAction SilentlyContinue
            Connect-MgGraph -Scopes "Policy.ReadWrite.ConditionalAccess","Directory.Read.All"
        }
    }
}

# ---- Helper: Get a policy by displayName ----
function Get-CA7PolicyByName([string]$name) {
    return Get-MgIdentityConditionalAccessPolicy -All | Where-Object { $_.DisplayName -eq $name }
}

# ---- Helper: Create or Skip policy if already exists ----
function Ensure-CAPolicy {
    param(
        [Parameter(Mandatory)]
        [string]$DisplayName,
        [Parameter(Mandatory)]
        [hashtable]$Body
    )

    $existing = Get-CA7PolicyByName -name $DisplayName
    if ($existing) {
        Write-Host "Policy exists, skipping: $DisplayName" -ForegroundColor Yellow
        return $existing
    }

    if ($WhatIfOnly) {
        Write-Host "WhatIfOnly: would create policy: $DisplayName" -ForegroundColor DarkGray
        return $null
    }

    Write-Host "Creating policy: $DisplayName" -ForegroundColor Green
    return New-MgIdentityConditionalAccessPolicy @Body
}

# ---- Start ----
Connect-GraphIfNeeded

# ---- Resolve the "United States" named location ----
$usNamedLocation = Get-MgIdentityConditionalAccessNamedLocation -All | Where-Object { $_.DisplayName -eq "United States" }
if (-not $usNamedLocation) {
    throw "Named location 'United States' not found. Create it under Entra > Protection > Conditional Access > Named locations (Countries/Regions)."
}

# =========================================
# Policy 1: Block Non-US Sign-ins (PowerShell)
# =========================================
$pol1Name = "CA07-PowerShell - Block Access from Outside US"
$pol1Body = @{
    DisplayName = $pol1Name
    State       = "enabled"
    Conditions  = @{
        Users = @{
            IncludeUsers = @("All")
        }
        Applications = @{
            IncludeApplications = @("All")
        }
        Locations = @{
            IncludeLocations = @("All")
            ExcludeLocations = @($usNamedLocation.Id)
        }
    }
    GrantControls = @{
        Operator        = "OR"
        BuiltInControls = @("block")
    }
}
$pol1 = Ensure-CAPolicy -DisplayName $pol1Name -Body $pol1Body

# =========================================
# Policy 2: Require MFA for High-Risk Sign-ins (PowerShell)
# =========================================
$pol2Name = "CA07-PowerShell - Require MFA for High-Risk Sign-Ins"
$pol2Body = @{
    DisplayName = $pol2Name
    State       = "enabled"
    Conditions  = @{
        Users = @{
            IncludeUsers = @("All")
        }
        Applications = @{
            IncludeApplications = @("All")
        }
        SignInRiskLevels = @("high")
    }
    GrantControls = @{
        Operator        = "OR"
        BuiltInControls = @("mfa")
    }
}
$pol2 = Ensure-CAPolicy -DisplayName $pol2Name -Body $pol2Body

# =========================================
# Policy 3: Limit Session Persistence (PowerShell)
# =========================================
$pol3Name = "CA07-PowerShell - Limit Session Persistence"
$pol3Body = @{
    DisplayName = $pol3Name
    State       = "enabled"
    Conditions  = @{
        Users = @{
            IncludeUsers = @("All")
        }
        Applications = @{
            IncludeApplications = @("All")
        }
    }
    SessionControls = @{
        SignInFrequency = @{
            Value     = 4
            Type      = "hours"   # allowed: "hours" or "days"
            IsEnabled = $true
        }
        PersistentBrowser = @{
            Mode      = "never"   # allowed: "always" or "never"
            IsEnabled = $true
        }
    }
}
$pol3 = Ensure-CAPolicy -DisplayName $pol3Name -Body $pol3Body

# ---- Output summary ----
Write-Host "`nCreated/Existing CA07 Policies:" -ForegroundColor Cyan
Get-MgIdentityConditionalAccessPolicy -All | Where-Object { $_.DisplayName -like "CA07-PowerShell*" } | Select-Object DisplayName, Id, State | Format-Table -AutoSize

Write-Host "`nDone." -ForegroundColor Cyan
