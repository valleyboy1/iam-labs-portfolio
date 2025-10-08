# Lab 01 — User Onboarding (Automation)

**Objective:** Create dept groups, onboard users from CSV, and place them into correct groups with temp passwords.

## How to run
```powershell
cd phase-1/lab01-user-onboarding
.\scripts\New-OnboardUsers.ps1 -CsvPath .\new-hires.csv -ExportPath .\artifacts\exports\new-hire-passwords.csv -VerboseLog
Copy code
