# Replace <USER_OBJECT_ID> with your actual user object ID

$policy = @{
    displayName = "Require MFA for Test User"
    state = "enabled"
    conditions = @{
        users = @{
            includeUsers = @("<USER_OBJECT_ID>")
        }
        applications = @{
            includeApplications = @("00000003-0000-0000-c000-000000000000")  # Microsoft 365
        }
    }
    grantControls = @{
        operator = "OR"
        builtInControls = @("mfa")
    }
}

New-MgConditionalAccessPolicy -BodyParameter $policy
