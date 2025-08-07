# Lab 07 – Advanced Conditional Access Policies (Microsoft Entra)

## 🎯 Objective
In this lab, we configure **advanced Conditional Access policies** using the Microsoft Entra Admin Center to strengthen access control based on:
- Geographic location
- Risk level
- Session behavior

This lab builds upon the basics learned in **Lab 4: Conditional Access** by layering real-world policy scenarios.

---

## 🛠️ Tools Used
- Microsoft Entra Admin Center (`https://entra.microsoft.com`)
- Microsoft Entra ID E5 Trial
- Conditional Access Policies

---

## 🔐 Policies Created

### 1. **CA07 - Block Access from Outside US**
- **Users:** All users or test group
- **Cloud apps:** All cloud apps
- **Condition:** 
  - Network (formerly "Location"): Include *Any location*, Exclude *Named location: United States*
- **Access control:** Block access

---

### 2. **CA07 - Require MFA for High-Risk Sign-Ins**
- **Users:** All users or test group
- **Cloud apps:** All cloud apps
- **Condition:** 
  - Sign-in risk: High
- **Access control:** Require multi-factor authentication

---

### 3. **CA07 - Limit Session Persistence**
- **Users:** All users or test group
- **Cloud apps:** All cloud apps (⚠️ Required for session controls)
- **Session controls:**
  - Sign-in frequency: Every 4 hours
  - Persistent browser session: Never persistent

---

## 🧪 Outcomes
- Successfully enforced location-based access controls
- Applied risk-aware MFA requirements
- Reduced long-lived browser sessions for added security

---

## 📺 Demo Video

[![Watch the Lab 07 video on YouTube](https://img.youtube.com/vi/Qp_mlMXNGzo/0.jpg)](https://www.youtube.com/watch?v=Qp_mlMXNGzo)

> 🎥 This video walks through creating advanced conditional access policies using the Microsoft Entra Admin Center, including blocking by location, enforcing MFA on high‑risk sign‑ins, and applying session controls.


---

## 🔗 Related Labs
- [Lab 04 - Basic Conditional Access](../Lab04-Conditional-Access/README.md)
- [Lab 06 - Privileged Identity Management (PIM)](../Lab06-PIM/README.md)

---

## ✅ Next Step
You can now automate these policies using PowerShell and the Microsoft Graph SDK in **Lab 07 (Phase 2)**.

---
