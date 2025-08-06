# 🔐 Lab 6: Privileged Identity Management (PIM)

This lab demonstrates how to use **Microsoft Entra Privileged Identity Management (PIM)** to manage just-in-time access to privileged roles such as **Security Administrator**.

> 🎥 **YouTube Demo**: [Watch the Lab Video](https://www.youtube.com/watch?v=1bRKIHS2rA0)  


---

## ✅ Lab Tasks Completed (Portal Only)

- Enabled Microsoft Entra PIM
- Assigned PIM eligibility for the **Security Administrator** role
- Configured activation settings:
  - Required MFA
  - Required justification
- Activated the eligible role as a test user
- Verified that the role was assigned and active

---

## ⚠️ Automation Status (PowerShell + Graph SDK)

Due to instability and function overflow issues with the Microsoft Graph PowerShell SDK (v2.x), automation for this lab is currently postponed.

The command `Get-MgDirectoryRoleDefinition` and related PIM cmdlets are not available or functional under current SDK constraints. A `.ps1` script is in progress using known role IDs instead.

✅ Once stable, automation for eligibility assignment and activation will be included in this repo.

---

## 🧠 Key Concepts

- **Privileged Role Administrator** vs **Global Administrator**
- **Eligible** vs **Active** role assignment
- **Just-In-Time (JIT)** role access
- Using PIM to reduce standing access

---

## 🛠️ Tools Used

- Microsoft Entra Admin Center (Portal)
- Microsoft Entra E5 Developer Tenant

---

## 📂 Folder Contents

| File | Description |
|------|-------------|
| `README.md` | This file |
| *(optional)* `Lab06-PIM-Eligibility.ps1` | PowerShell automation script (in progress) |
| *(optional)* `diagram.png` | Visual flow of the lab |

---

## 🔗 Related Labs

- [Lab 4: Conditional Access (Basic)](https://github.com/valleyboy1/iam-labs-portfolio/blob/main/Lab04-Conditional-Access/README.md)
- [Lab 5: Group-Based Licensing](https://github.com/valleyboy1/iam-labs-portfolio/blob/main/Lab05-Group-Based-Licensing/README.md)

---

