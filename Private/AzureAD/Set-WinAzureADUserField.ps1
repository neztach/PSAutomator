function Set-WinAzureADUserField {
    <#
    .SYNOPSIS
    Sets a specific field for a user in Azure AD.

    .DESCRIPTION
    This function allows you to set a specific field for a user in Azure AD. You can update various user attributes such as UserPrincipalName, DisplayName, etc. It interacts with Azure AD to update the user's field accordingly.

    .PARAMETER User
    Specifies the user object for which the field needs to be updated.

    .PARAMETER Value
    Specifies the field and its value to be set for the user.

    .PARAMETER WhatIf
    Indicates that the cmdlet should display what changes would occur rather than actually making changes.

    .EXAMPLE
    Set-WinAzureADUserField -User $userObject -Value @{ Field = 'DisplayName'; Value = 'John Doe' }
    Sets the DisplayName field to 'John Doe' for the specified user in Azure AD.

    .EXAMPLE
    Set-WinAzureADUserField -User $userObject -Value @{ Field = 'UserPrincipalName'; Value = 'john.doe@contoso.com' }
    Sets the UserPrincipalName field to 'john.doe@contoso.com' for the specified user in Azure AD.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)][Object] $User,
        [parameter(Mandatory = $false)][Object] $Value,
        [switch] $WhatIf
    )

    $Splat = @{}
    $Splat.UserPrincipalName = $User.UserPrincipalName
    $Splat.ErrorAction = 'Stop'
    if ($Value) {
        $Field = "$($Value.Field)"
        if ($Field -eq 'UserPrincipalName') {
            # if UserPrincipalName it means user wants to rename UserPrincipalName
            # that requires different method
            $Field = 'NewUserPrincipalName'
        }
        $Data = $Value.Value
        $Splat.$Field = $Data
    }

    $Object = @()
    if ($User.$Field -ne $Data) {
        try {
            if (-not $WhatIf) {
                if ($Field -eq 'UserPrincipalName') {
                    Set-MsolUserPrincipalName @Splat
                } else {
                    Set-MsolUser @Splat
                }
            }

            $Object += @{ Status = $true; Output = $User.UserPrincipalName; Extended = "Set $Field to $Data" }
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " " -Replace '  ',' '
            $Object += @{ Status = $false; Output = $User.UserPrincipalName; Extended = $ErrorMessage }
        }
    }
    return $Object
}