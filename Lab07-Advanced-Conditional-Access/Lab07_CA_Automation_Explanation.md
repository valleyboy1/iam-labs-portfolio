# Lab 07 (Phase 2) – PowerShell Automation: Advanced Conditional Access

This document explains what each **PowerShell script block** in `Lab07_CA_Automation.ps1` does, the **Graph permissions** it needs, and how to **validate** the results.

## Prerequisites
- Microsoft Graph PowerShell SDK installed (`Microsoft.Graph`)
- Role: **Global Administrator** or **Conditional Access Administrator**
- Named Location **"United States"** created under: *Entra Admin Center → Protection → Conditional Access → Named locations → Countries location*

## Connect to Graph
The script ensures you are connected with the required scopes:
- `Policy.ReadWrite.ConditionalAccess`
- `Directory.Read.All`

If the current context lacks these scopes, it re-connects automatically.

## Policy 1 – Block Access from Outside US
**DisplayName:** `CA07-PowerShell - Block Access from Outside US`

- **Users:** All
- **Apps:** All cloud apps
- **Condition (Network/Locations):** Include `Any location`, **Exclude** the named location `United States`
- **Grant control:** `block`

**Purpose:** Prevent sign-ins unless they originate from the US. Useful for geo-bounding access during testing or for specific compliance needs.

## Policy 2 – Require MFA for High-Risk Sign-ins
**DisplayName:** `CA07-PowerShell - Require MFA for High-Risk Sign-Ins`

- **Users:** All
- **Apps:** All cloud apps
- **Condition:** `SignInRiskLevels = high`
- **Grant control:** `mfa`

**Purpose:** Enforce MFA only when a risky sign-in is detected by Microsoft Entra risk signals.

## Policy 3 – Limit Session Persistence
**DisplayName:** `CA07-PowerShell - Limit Session Persistence`

- **Users:** All
- **Apps:** All cloud apps (required for session controls)
- **Session controls:**
  - **Sign-in frequency:** every 4 hours
  - **Persistent browser:** `never` (object form: `{ Mode = "never"; IsEnabled = $true }`)

**Purpose:** Reduces long-lived browser sessions and forces periodic re-authentication.

## Idempotency & Safety
- The script **checks for existing policies** by name and skips creation if found. Run it multiple times safely.
- Use `-WhatIfOnly` to simulate actions without creating policies:
  ```powershell
  .\Lab07_CA_Automation.ps1 -WhatIfOnly
  ```

## Validation
List the policies:
```powershell
Get-MgIdentityConditionalAccessPolicy -All | Where-Object {$_.DisplayName -like "CA07-PowerShell*"} | Select DisplayName, Id, State
```

## Troubleshooting
- **400 BadRequest / schema**: Ensure `PersistentBrowser` is an object: `@{ Mode = "never"; IsEnabled = $true }`
- **Named location not found**: Create **Countries location** called `United States` and re-run.
- **Insufficient privileges**: Reconnect with the required scopes.

---

**Files in this lab phase:**
- `Lab07_CA_Automation.ps1` — Creates/ensures the three policies
- `Lab07_CA_Automation_Explanation.md` — This file
