# Lab 08 – Script Pack (IAM End‑to‑End Lifecycle)

> Run order and quick notes.

## Prereqs
- PowerShell 7+ recommended
- `Microsoft.Graph` module
- Global Administrator or sufficient delegated permissions
- Fill out `00-Variables.ps1` (copy from `00-Variables.sample.ps1`)

## Run Order
1. `01-Connect-Graph.ps1` — connect to Graph (`-UseBeta` when doing PIM)
2. `02-Setup-Groups-and-Licensing.ps1` — creates HR/IT/Sales groups + assigns group-based licensing
3. `03-Create-Users-and-Add-To-Groups.ps1` — creates Alice/Bob/Carol and adds to groups
4. `04-RBAC-DirectoryRole-Assignments.ps1` — assigns RBAC roles (User Admin to Bob, Reports Reader to Alice)
5. `05-Conditional-Access-Policies.ps1` — creates 3 CA policies (start in **report-only**)
6. `06-PIM-Eligibility-and-Activation.ps1` — makes Bob **eligible** for Global Admin (beta) and tries activation
7. `07-Offboarding.ps1` — disables and deprovisions a user (defaults to Carol)
8. `08-Export-Audit-Logs.ps1` — exports sign-ins and directory audits to CSV
9. `99-Cleanup.ps1` — removes demo artifacts (pass `-RemoveGroups` to also delete groups)

## Tips
- Flip CA policy `state` from `enabledForReportingButNotEnforced` to `enabled` after testing.
- For PIM approvals, complete the approval in the Entra portal if activation request is pending.
- If `Set-MgGroupLicense` cmdlet is unavailable, the scripts will fallback to a raw Graph request.
- Use `Get-MgSubscribedSku | Select SkuPartNumber, SkuId` to discover your tenant's SKU IDs.
