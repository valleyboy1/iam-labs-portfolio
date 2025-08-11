# Lab 08 – Script Explanations

This document explains the purpose and main logic of each script in `/scripts`.

---

## 00-Variables.sample.ps1
- Template for storing tenant-specific values like domain, default passwords, SKU IDs, group names, and demo user details.
- Copy this to `00-Variables.ps1` and fill in actual values.

---

## 01-Connect-Graph.ps1
- Connects to Microsoft Graph with all required scopes.
- Supports `-UseBeta` to switch to Graph beta profile (needed for PIM operations).

---

## 02-Setup-Groups-and-Licensing.ps1
- Creates HR, IT, and Sales security groups.
- Assigns Microsoft 365 and Entra ID P2 licenses to each group for group-based licensing.

---

## 03-Create-Users-and-Add-To-Groups.ps1
- Creates three demo users (Alice – HR, Bob – IT, Carol – Sales) with forced password reset.
- Adds them to the appropriate role groups.

---

## 04-RBAC-DirectoryRole-Assignments.ps1
- Activates built-in directory roles (if not already active).
- Assigns **User Administrator** to Bob and **Reports Reader** to Alice.

---

## 05-Conditional-Access-Policies.ps1
- Creates three Conditional Access policies:
  1. Require MFA for IT Admins
  2. Block HR Staff logins from outside the US
  3. Require compliant device for Sales Team
- Policies start in report-only mode for testing.

---

## 06-PIM-Eligibility-and-Activation.ps1
- Switches to Graph beta.
- Makes Bob eligible for Global Administrator role for 8 hours.
- Submits an activation request for testing.

---

## 07-Offboarding.ps1
- Disables a user (default: Carol), revokes sessions, removes groups and licenses, and sets a random temp password.

---

## 08-Export-Audit-Logs.ps1
- Exports sign-in logs and directory audit logs from the last 7 days to CSV files.

---

## 99-Cleanup.ps1
- Deletes the demo users and Conditional Access policies.
- Optional `-RemoveGroups` flag to also delete HR, IT, and Sales groups.

---

## Tips
- Run scripts in the order listed in `Scripts-README.md`.
- Verify `00-Variables.ps1` values before running to avoid accidental changes to production users.
