# ==============================
# Lab 08 - Variables (Sample)
# Copy this file to 00-Variables.ps1 and fill in your values.
# ==============================

# Tenant-wide settings
$TenantDomain      = "contoso.onmicrosoft.com"     # your tenant
$DefaultPassword   = "P@ssw0rd!2025"               # for demo users (force change at next sign-in)

# SKU IDs (run: Get-MgSubscribedSku | Select SkuPartNumber, SkuId)
$E5SkuId           = "<GUID of ENTERPRISEPREMIUM or SPE_E5>"
$EntraIDP2SkuId    = "<GUID of AAD_PREMIUM_P2>"

# Group display names
$Group_HR          = "HR Staff"
$Group_IT          = "IT Admins"
$Group_Sales       = "Sales Team"

# Demo users
$User_HR           = @{
    GivenName      = "Alice"
    Surname        = "Adams"
    UserPrincipalName = "alice.hr@{0}" -f $TenantDomain
    Department     = "Human Resources"
    JobTitle       = "HR Specialist"
}
$User_IT           = @{
    GivenName      = "Bob"
    Surname        = "Baker"
    UserPrincipalName = "bob.it@{0}" -f $TenantDomain
    Department     = "Information Technology"
    JobTitle       = "IT Support Admin"
}
$User_Sales        = @{
    GivenName      = "Carol"
    Surname        = "Carter"
    UserPrincipalName = "carol.sales@{0}" -f $TenantDomain
    Department     = "Sales"
    JobTitle       = "Account Executive"
}

# Conditional Access policy names
$CAPolicy_MFA_ITAdmins    = "CAP-Require-MFA-for-IT-Admins"
$CAPolicy_Block_HR_OutsideUS = "CAP-Block-HR-Outside-US"
$CAPolicy_Compliant_Sales = "CAP-Require-Compliant-Device-for-Sales"

# PIM
$PIM_EligibleRoleDisplayName = "Global Administrator"
$PIM_Justification           = "Emergency eligibility for capstone testing"
$PIM_EligibilityDuration     = "PT8H"   # 8 hours ISO-8601
