function Set-WinAzureADUserStatus {
    <#
    .SYNOPSIS
    Sets the status of a user in Azure AD by enabling or disabling their credentials.

    .DESCRIPTION
    This function allows you to enable or disable a user's credentials in Azure AD based on the specified option. 
    It interacts with Azure AD to update the user's status accordingly.

    .PARAMETER User
    Specifies the user object for which the status needs to be updated.

    .PARAMETER Option
    Specifies whether to 'Enable' or 'Disable' the user's credentials.

    .PARAMETER WhatIf
    Indicates that the cmdlet should display what changes would occur rather than actually making changes.

    .EXAMPLE
    Set-WinAzureADUserStatus -User $userObject -Option 'Enable'
    Enables the credentials for the specified user.

    .EXAMPLE
    Set-WinAzureADUserStatus -User $userObject -Option 'Disable' -WhatIf
    Disables the credentials for the specified user but only shows what would happen without actually making changes.

    .NOTES
    File Name      : Set-WinAzureADUserStatus.ps1
    Prerequisite   : Requires AzureAD module to be installed.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)][Object] $User,
        [parameter(Mandatory = $true)][ValidateSet("Enable", "Disable")][String] $Option,
        [switch] $WhatIf
    )
    $Object = @()
    if ($Option -eq 'Enable' -and $User.BlockCredential -eq $true) {
        try {
            if (-not $WhatIf) {
                Set-MsolUser -UserPrincipalName $User.UserPrincipalName -BlockCredential $false
            }
            $Object += @{ Status = $true; Output = $User.UserPrincipalName; Extended = 'Enabled user.' }
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            $Object += @{ Status = $false; Output = $User.UserPrincipalName; Extended = $ErrorMessage }
        }
    } elseif ($Option -eq 'Disable' -and $User.BlockCredential -eq $false) {
        try {
            if (-not $WhatIf) {
                Set-MsolUser -UserPrincipalName $User.UserPrincipalName -BlockCredential $true
            }
            $Object += @{ Status = $true; Output = $User.UserPrincipalName; Extended = 'Disabled user.' }
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            $Object += @{ Status = $false; Output = $User.UserPrincipalName; Extended = $ErrorMessage }
        }
    }
    return $Object
}