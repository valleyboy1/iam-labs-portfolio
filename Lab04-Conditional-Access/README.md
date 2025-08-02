# Lab 4 – Conditional Access Policy (Microsoft Entra ID)

## 🎯 Objective
This lab demonstrates how to create a Conditional Access policy in Microsoft Entra ID to enforce Multi-Factor Authentication (MFA) for a test user when accessing Microsoft 365 apps. This mirrors real-world scenarios where organizations use Conditional Access for Zero Trust enforcement.

---

## 📺 Video Demonstration

[![Watch the video](https://img.youtube.com/vi/zhszRd8eC0A/hqdefault.jpg)](https://www.youtube.com/watch?v=zhszRd8eC0A)  
👉 Click the image or link to watch: [https://www.youtube.com/watch?v=zhszRd8eC0A](https://www.youtube.com/watch?v=zhszRd8eC0A)

---

## 🖼️ Conditional Access Diagram

![Conditional Access Diagram](Conditional%20Access%20diagram.png)
 
**Diagram designed by Valdez Brown**

---

## 📁 Files Included in This Lab

| File Name | Description |
|-----------|-------------|
| `connect-graph.ps1` | Script to connect to Microsoft Graph with the correct scopes |
| `create-ca-policy.ps1` | Creates a Conditional Access policy that enforces MFA |
| `cleanup-ca-policy.ps1` | Deletes the created Conditional Access policy |
| `how-to-use-scripts.txt` | Explains how to use each PowerShell script |
| `troubleshooting.txt` | Documents Security Defaults issue and how to resolve it |
| `conditional-access-diagram.png` | Visual representation of policy logic and flow |

---

## 🛠️ Tools Used
- Microsoft Entra ID Portal
- Microsoft Graph PowerShell SDK
- Microsoft Visio (for diagram)
- Microsoft 365 E5 Developer Tenant

---

## 🧯 Troubleshooting Covered
If you encountered issues creating Conditional Access policies, refer to:
📄 [`troubleshooting.txt`](./troubleshooting.txt)  
Common issue: **Security Defaults** must be disabled before Conditional Access policies can be created.

---

## 🔗 Related Labs
- [Lab 1 – Lifecycle Onboarding](../Lab01-Lifecycle-Onboarding)
- [Lab 2 – Conditional Access MFA by Location](../Lab02-Conditional-Access)
- [Lab 3 – Role-Based Access Control (RBAC)](../Lab03-RBAC)

---

## 🧠 Key Concepts
- Conditional Access
- Multi-Factor Authentication (MFA)
- Microsoft Graph Automation
- Identity and Access Management (IAM)
