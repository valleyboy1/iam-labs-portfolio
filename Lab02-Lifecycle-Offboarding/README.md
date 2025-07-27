# 🔐 Lab 2 – Lifecycle Offboarding with Microsoft Entra ID

This lab simulates the secure offboarding process for a user in Microsoft Entra ID. Using both **portal navigation** and **PowerShell automation**, I demonstrate how to disable access, revoke sessions, clean up licenses and groups, and (optionally) delete the user account.

---

## 🎯 Lab Objectives

- Block user sign-in access
- Revoke all sign-in sessions
- Remove assigned licenses
- Remove user from groups (e.g., Box App Users)
- Delete user from directory (optional)

---

## 👤 User Offboarded

- **Display Name:** User1  
- **UPN:** `user1@brownsense.net`  
- **Group Membership:** Box App Users

---

## 📺 Lab Walkthrough Video

🎬 [Watch on YouTube](https://www.youtube.com/watch?v=If7aPiAOjoc)

---

## 📄 PowerShell Script

📂 [View Script → Scripts/offboarding_user1.ps1](./Scripts/offboarding_user1.ps1)

This script uses the Microsoft Graph PowerShell SDK to:
- Block sign-in
- Revoke sessions
- Remove licenses
- Remove group membership
- Delete the user

---

## 🖼️ Diagram

🧩 [View Diagram → Diagrams/lab02_offboarding_diagram_branded.png](./Diagrams/lab02_offboarding_diagram_branded.png)

> Branded visual representation of both **Portal** and **PowerShell** offboarding steps in a swimlane diagram.

---

## 📸 Screenshots

| Portal View | PowerShell View |
|-------------|-----------------|
| ![Revoke Session Portal](./Images/revoke_session_portal.png) | ![Revoke Session PS](./Images/revoke_session_powershell.png) |
| ![Remove License Portal](./Images/remove_license_portal.png) | ![Remove License PS](./Images/remove_license_powershell.png) |

---

## 🧠 Key Takeaways

- Offboarding must be systematic: disable, revoke, remove, clean
- PowerShell automates repeatable IAM tasks efficiently
- Group cleanup ensures access is fully removed
- Sessions must be revoked even if account is disabled

---

## 🔗 Back to Portfolio

[⬅️ Return to IAM Labs Portfolio](https://github.com/valleyboy1/iam-labs-portfolio)
