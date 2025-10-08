<#
.SYNOPSIS
  Onboard users from CSV, create baseline department groups if missing,
  add users to the proper group, and export temporary passwords.
  Graph SDK v2 (no Select-MgProfile). Safe to re-run.

.PARAMETER CsvPath
  Path to new-hires CSV.

.PARAMETER ExportPath
  Where to write temp passwords (local only, do NOT commit).

.EXAMPLE
  .\scripts\New-OnboardUsers.ps1 -CsvPath .\new-hires.csv `
    -ExportPath .\artifacts\exports\new-hire-passwords.csv
#>

[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)][string]$CsvPath,
  [Parameter()][string]$ExportPath = ".\artifacts\exports\new-hire-passwords.csv",
  [Parameter()][switch]$VerboseLog
)

Import-Module Microsoft.Graph -ErrorAction Stop
$scopes = @("User.ReadWrite.All","Group.ReadWrite.All","Directory.ReadWrite.All","Organization.Read.All")
try {
  if ($VerboseLog) { Write-Host "Connecting to Microsoft Graph..." -ForegroundColor Cyan }
  Connect-MgGraph -Scopes $scopes | Out-Null
} catch {
  Write-Error "Failed to connect to Microsoft Graph. $_"
  exit 1
}

function Ensure-Group {
  param([Parameter(Mandatory)][string]$DisplayName)
  $g = Get-MgGroup -Filter "displayName eq '$DisplayName'" | Select-Object -First 1
  if (-not $g) {
    if ($VerboseLog) { Write-Host "Creating group $DisplayName..." -ForegroundColor Yellow }
    $g = New-MgGroup -DisplayName $DisplayName -MailEnabled:$false -MailNickname $DisplayName -SecurityEnabled:$true
  }
  return $g
}

function Add-UserToGroup {
  param(
    [Parameter(Mandatory)][string]$GroupId,
    [Parameter(Mandatory)][string]$UserId
  )
  try {
    New-MgGroupMemberByRef -GroupId $GroupId -OdataId "https://graph.microsoft.com/v1.0/directoryObjects/$UserId" -ErrorAction Stop | Out-Null
  } catch {
    if ($_.Exception.Message -match "already exist") {
      # already a member
    } else { throw }
  }
}

$deptGroups = @("GG-Dept-Sales","GG-Dept-Ops","GG-Dept-IT")
$deptMap = @{}
foreach ($name in $deptGroups) { $deptMap[$name] = (Ensure-Group -DisplayName $name).Id }
$deptToGroup = @{ "Sales"=$deptMap["GG-Dept-Sales"]; "Ops"=$deptMap["GG-Dept-Ops"]; "IT"=$deptMap["GG-Dept-IT"] }

$exportDir = Split-Path -Path $ExportPath -Parent
if (-not (Test-Path $exportDir)) { New-Item -ItemType Directory -Force -Path $exportDir | Out-Null }
if (-not (Test-Path $ExportPath)) { "userPrincipalName,TempPassword,CreatedUtc" | Out-File -FilePath $ExportPath -Encoding utf8 }

if (-not (Test-Path $CsvPath)) { Write-Error "CSV not found at $CsvPath"; exit 1 }
$hires = Import-Csv -Path $CsvPath

foreach ($row in $hires) {
  $upn  = $row.userPrincipalName.Trim()
  $dept = $row.department.Trim()

  $existing = $null
  try { $existing = Get-MgUser -UserId $upn -ErrorAction Stop } catch {}

  if ($existing) {
    if ($VerboseLog) { Write-Host "User exists -> $upn (skipping create)" -ForegroundColor DarkYellow }
    if ($deptToGroup.ContainsKey($dept)) { Add-UserToGroup -GroupId $deptToGroup[$dept] -UserId $existing.Id }
    continue
  }

  $tempPwd = [Guid]::NewGuid().Guid + "!"
  $params = @{
    AccountEnabled    = $true
    DisplayName       = $row.displayName
    GivenName         = $row.givenName
    Surname           = $row.surname
    JobTitle          = $row.jobTitle
    Department        = $dept
    MailNickname      = ($upn -split "@")[0]
    UserPrincipalName = $upn
    PasswordProfile   = @{ Password = $tempPwd; ForceChangePasswordNextSignIn = $true }
  }

  try {
    $user = New-MgUser @params
    if ($deptToGroup.ContainsKey($dept)) { Add-UserToGroup -GroupId $deptToGroup[$dept] -UserId $user.Id }
    "$upn,$tempPwd,$([DateTime]::UtcNow.ToString('u'))" | Out-File -FilePath $ExportPath -Append -Encoding utf8
    Write-Host "Created $upn" -ForegroundColor Green
  } catch {
    Write-Error "Failed creating $upn. $_"
  }
}

Write-Host "Onboarding complete. Temp passwords -> $ExportPath" -ForegroundColor Cyan
