
# Lab 2: Lifecycle Offboarding Script for user1@brownsense.net
# Author: Valdez Lamont Brown
# Description: PowerShell script to offboard a user in Microsoft Entra ID using Microsoft Graph SDK

# Connect to Microsoft Graph with required scopes
Connect-MgGraph -Scopes "User.ReadWrite.All", "Directory.AccessAsUser.All", "Group.ReadWrite.All", "Directory.ReadWrite.All"

# Define the user UPN
$userUPN = "user1@brownsense.net"

# Get the user object
$user = Get-MgUser -UserId $userUPN

# STEP 1: Block sign-in (Account already disabled in Lab 1, but included for reference)
Update-MgUser -UserId $user.Id -BodyParameter @{ AccountEnabled = $false }

# STEP 2: Revoke sign-in sessions
Revoke-MgUserSignInSession -UserId $user.Id

# STEP 3: Remove licenses
$userLicenses = Get-MgUserLicenseDetail -UserId $user.Id
$licenseSkuIds = $userLicenses.SkuId
Set-MgUserLicense -UserId $user.Id -AddLicenses @() -RemoveLicenses $licenseSkuIds

# STEP 4: Remove from groups
$groups = Get-MgUserMemberOf -UserId $user.Id
foreach ($group in $groups) {
    if ($group.AdditionalProperties["@odata.type"] -eq "#microsoft.graph.group") {
        $groupId = $group.Id
        Remove-MgGroupMemberByRef -GroupId $groupId -DirectoryObjectId $user.Id
        Write-Host "Removed from group: $groupId"
    }
}

# STEP 5: Delete user (optional)
# Remove-MgUser -UserId $user.Id -Confirm:$false

# Disconnect session
Disconnect-MgGraph
