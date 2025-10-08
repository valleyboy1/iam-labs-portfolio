# Phase 1 - IAM Analyst Labs
# Lab 01 — User Onboarding (Automation)

## 🎯 Objective
The purpose of this lab is to automate the **user onboarding process** in Microsoft Entra ID (Azure AD) using **PowerShell and Microsoft Graph SDK v2**.  
This simulates a real-world Identity & Access Management (IAM) scenario where new employees are provisioned, added to department-based groups, and required to change their password at first sign-in.

---

## 🧰 Tools & Permissions Used
| Tool | Purpose |
|------|----------|
| **PowerShell 5/7** | Executes automation scripts |
| **Microsoft Graph SDK (v2)** | Provides access to Microsoft Entra ID via API |
| **Microsoft Entra Admin Center** | Used for validation and verification |
| **Global Administrator Role** | Required for user and group provisioning |

---

## 🧩 Lab Structure

---

## ⚙️ Steps Performed

### 1️⃣ CSV File Preparation
Created a **new-hires.csv** file containing 25 users with their:
- Display Name  
- First Name / Last Name  
- Job Title  
- Department (Sales, Ops, IT)  
- User Principal Name (UPN)

Example:
```csv
displayName,givenName,surname,userPrincipalName,jobTitle,department
Alicia Reed,Alicia,Reed,alicia.reed@brownsense.net,Account Executive,Sales
Jordan King,Jordan,King,jordan.king@brownsense.net,Ops Coordinator,Ops
...
2️⃣ PowerShell Script Execution

Executed the following command to onboard all users and create department groups if they did not exist:

cd "C:\Users\brown\OneDrive\Documents\iam-labs-portfolio-IAM-Analyst-Role-Labs\phase-1\lab01-user-onboarding"
.\scripts\New-OnboardUsers.ps1 -CsvPath .\new-hires.csv `
-ExportPath .\artifacts\exports\new-hire-passwords.csv `
-VerboseLog


What the script does:

Connects to Microsoft Graph API

Creates 3 department security groups:

GG-Dept-Sales

GG-Dept-Ops

GG-Dept-IT

Reads each record from new-hires.csv

Creates users in Microsoft Entra ID

Assigns users to their department groups

Generates a unique temporary password for each user

Exports those credentials to new-hire-passwords.csv (local only — not committed to GitHub)

3️⃣ Validation
🔹 Entra Admin Center

Verified all 25 users appear under Users → All users

Confirmed Job title and Department populated correctly

Checked each user’s Group membership (e.g., “Sales” users in GG-Dept-Sales)

Confirmed GG-Dept-* groups were created automatically

🔹 Password Policy Test

Signed in as a sample user (e.g., alicia.reed@brownsense.net)

Confirmed the “Change Password at first sign-in” policy triggered successfully

🔹 Audit Logs

Verified activity under Entra → Audit logs showing “Add user” and “Add member to group” actions executed via Graph API
📁 Exported Artifacts
File	Purpose	Commit Status
artifacts/exports/new-hire-passwords.csv	Stores generated temp passwords	🚫 Ignored (for security)
artifacts/screenshots/	Stores proof of successful onboarding	✅ Committed
lab01-verification.csv	Optional validation report of users/groups	✅ Committed (if created)
🧾 Deliverables (Screenshots)

Microsoft Entra → Users list

One user’s Overview page

That user’s Group memberships

Password change prompt at first login (redacted)

PowerShell output of successful onboarding

🧠 Key Learnings

Automated onboarding eliminates manual account creation errors.

Department-based group structure simplifies future license assignment and conditional access policies.

Microsoft Graph SDK provides a secure, scalable way to perform IAM operations across multiple users.

🔜 Next Lab

Lab 02 — Lifecycle Offboarding:
We’ll automate user disablement, group cleanup, and move offboarded users into a GG-DisabledUsers holding group.


---


