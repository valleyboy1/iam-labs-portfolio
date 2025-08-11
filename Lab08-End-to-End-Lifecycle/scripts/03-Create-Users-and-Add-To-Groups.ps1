<#
.SYNOPSIS
 Creates demo users and adds them to the corresponding role groups.
#>

. "$PSScriptRoot\00-Variables.ps1"

function Ensure-User {
    param(
        [hashtable]$User,
        [string]$Password
    )
    $upn = $User.UserPrincipalName
    $existing = Get-MgUser -Filter "userPrincipalName eq '$upn'"
    if ($existing) {
        Write-Host "User exists: $upn" -ForegroundColor DarkGray
        return $existing
    }

    $pwdProfile = @{
        forceChangePasswordNextSignIn = $true
        password                      = $Password
    }

    $userParams = @{
        AccountEnabled   = $true
        DisplayName      = "$($User.GivenName) $($User.Surname)"
        GivenName        = $User.GivenName
        Surname          = $User.Surname
        UserPrincipalName= $upn
        MailNickname     = ($User.GivenName + $User.Surname).ToLower()
        Department       = $User.Department
        JobTitle         = $User.JobTitle
        PasswordProfile  = $pwdProfile
    }

    Write-Host "Creating user: $upn" -ForegroundColor Yellow
    New-MgUser @userParams
    return (Get-MgUser -Filter "userPrincipalName eq '$upn'")
}

function Get-GroupByName { param([string]$Name) Get-MgGroup -Filter "displayName eq '$Name'" }

function Add-UserToGroup {
    param([string]$UserId, [string]$GroupId)
    $already = Get-MgGroupMember -GroupId $GroupId -All | Where-Object { $_.Id -eq $UserId }
    if ($already) { Write-Host " - already in group" -ForegroundColor DarkGray; return }

    $body = @{ "@odata.id" = "https://graph.microsoft.com/v1.0/directoryObjects/$UserId" }
    New-MgGroupMemberByRef -GroupId $GroupId -BodyParameter $body | Out-Null
}

$uHR    = Ensure-User -User $User_HR    -Password $DefaultPassword
$uIT    = Ensure-User -User $User_IT    -Password $DefaultPassword
$uSales = Ensure-User -User $User_Sales -Password $DefaultPassword

$gHR    = Get-GroupByName $Group_HR
$gIT    = Get-GroupByName $Group_IT
$gSales = Get-GroupByName $Group_Sales

Write-Host "== Add users to role groups ==" -ForegroundColor Cyan
Add-UserToGroup -UserId $uHR.Id    -GroupId $gHR.Id
Add-UserToGroup -UserId $uIT.Id    -GroupId $gIT.Id
Add-UserToGroup -UserId $uSales.Id -GroupId $gSales.Id
Write-Host "Users added to groups." -ForegroundColor Green
