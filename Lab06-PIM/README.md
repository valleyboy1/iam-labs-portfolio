# 🔐 Lab 6: Privileged Identity Management (PIM)

This lab demonstrates how to use Microsoft Entra's Privileged Identity Management (PIM) to make a user eligible for a privileged role, activate the role, and configure activation settings—all from the **Microsoft Entra admin center**.

> 🎥 **YouTube Demo**: [Watch the Lab Video](https://www.youtube.com/your-video-link-here)  
> *(Replace with your actual video link)*

---

## ⚙️ Steps to Complete PIM Lab (Portal Only)

### ✅ Step 1: Navigate to PIM
1. Sign in at [https://entra.microsoft.com](https://entra.microsoft.com)
2. Go to **Identity** > **Privileged Identity Management**
3. Click **Microsoft Entra roles**

---

### ✅ Step 2: Assign Eligibility to Yourself
1. In the PIM blade, click **Assignments**
2. Click **+ Add assignments**
3. Complete the wizard:
   - **Role**: Select a role (e.g., `Security Administrator`)
   - **Assignment type**: `Eligible`
   - **Members**: Select **your own account**
4. Click **Next** and then **Assign**

---

### ✅ Step 3: Configure Role Activation Settings (Optional)
1. From **Microsoft Entra roles**, click **Role settings**
2. Choose the same role (e.g., `Security Administrator`)
3. Adjust settings as needed:
   - ✅ Require MFA: **Yes**
   - ✅ Require Justification: **Yes**
   - ❌ Require Ticket Number: Optional
4. Click **Save**

---

### ✅ Step 4: Activate the Role
1. In the left menu, go to **My roles**
2. Find the **Eligible** role you just assigned
3. Click **Activate**
4. Provide required justification
5. Click **Activate**

---

### ✅ Step 5: Verify Activation
- Navigate to **Active assignments**
- Confirm the role is now listed as **Active**

---

## 📌 Notes
- This lab focuses only on using the **Entra portal**.
- PowerShell and Microsoft Graph API automation will be handled in a separate follow-up lab.

---

