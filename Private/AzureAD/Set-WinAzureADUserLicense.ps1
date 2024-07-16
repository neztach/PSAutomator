function Set-WinAzureADUserLicense {
    <#
    .SYNOPSIS
    Sets the license options for a user in Azure AD by adding, removing, replacing licenses, or removing all licenses.

    .DESCRIPTION
    This function allows you to manage the license options for a user in Azure AD. You can add a new license, remove a specific license, remove all licenses, or replace an existing license with a new one. It interacts with Azure AD to update the user's license options accordingly.

    .PARAMETER User
    Specifies the user object for which the license options need to be updated.

    .PARAMETER Option
    Specifies the action to be performed on the user's licenses. Valid options are 'Add', 'Remove', 'RemoveAll', or 'Replace'.

    .PARAMETER License
    Specifies the license to be added, removed, or replaced.

    .PARAMETER LicenseToReplace
    Specifies the license to be replaced when the 'Replace' option is chosen.

    .PARAMETER WhatIf
    Indicates that the cmdlet should display what changes would occur rather than actually making changes.

    .EXAMPLE
    Set-WinAzureADUserLicense -User $userObject -Option 'Add' -License 'LicenseSKU123'
    Adds the specified license to the user in Azure AD.

    .EXAMPLE
    Set-WinAzureADUserLicense -User $userObject -Option 'Remove' -License 'LicenseSKU456'
    Removes the specified license from the user in Azure AD.

    .EXAMPLE
    Set-WinAzureADUserLicense -User $userObject -Option 'RemoveAll'
    Removes all licenses associated with the user in Azure AD.

    .EXAMPLE
    Set-WinAzureADUserLicense -User $userObject -Option 'Replace' -License 'LicenseSKU789' -LicenseToReplace 'LicenseSKU456'
    Replaces the existing license with 'LicenseSKU456' with the new license 'LicenseSKU789' for the user in Azure AD.

    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)][Object] $User,
        [parameter(Mandatory = $true)][ValidateSet("Add", "Remove", "RemoveAll", "Replace")][String] $Option,
        [parameter(Mandatory = $false)][string] $License,
        [parameter(Mandatory = $false)][string] $LicenseToReplace,
        [switch] $WhatIf
    )
    $Object = @()
    if ($Option -eq 'Add') {
        try {
            if (-not $WhatIf) {
                Set-MsolUserLicense -UserPrincipalName $User.UserPrincipalName -AddLicenses $License -ErrorAction Stop
            }
            $Object += @{ Status = $true; Output = $User.UserPrincipalName; Extended = "Added license $License to user." }
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            $Object += @{ Status = $false; Output = $User.UserPrincipalName; Extended = $ErrorMessage }
        }
    } elseif ($Option -eq 'Remove') {
        try {
            if (-not $WhatIf) {
                Set-MsolUserLicense -UserPrincipalName $User.UserPrincipalName -RemoveLicenses $License -ErrorAction Stop
            }
            $Object += @{ Status = $true; Output = $User.UserPrincipalName; Extended = "Removed license $License from user." }
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            $Object += @{ Status = $false; Output = $User.UserPrincipalName; Extended = $ErrorMessage }
        }
    } elseif ($Option -eq 'RemoveAll') {
        try {
            foreach ($License in $User.Licenses.AccountSKUID) {
                if (-not $WhatIf) {
                    Set-MsolUserLicense -UserPrincipalName $User.UserPrincipalName -RemoveLicenses $License -ErrorAction Stop
                }
                $Object += @{ Status = $true; Output = $User.UserPrincipalName; Extended = "Removed license $License from user." }
            }
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            $Object += @{ Status = $false; Output = $User.UserPrincipalName; Extended = $ErrorMessage }
        }
    } elseif ($Option -eq 'Replace') {
        [bool] $Success = $true
        try {
            if (-not $WhatIf) {
                Set-MsolUserLicense -UserPrincipalName $User.UserPrincipalName -AddLicenses $License
            }
            $Object += @{ Status = $true; Output = $User.UserPrincipalName; Extended = "Added license $License to user before removing $LicenseToReplace." }
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            $Object += @{ Status = $false; Output = $User.UserPrincipalName; Extended = $ErrorMessage }
            $Success = $false
        }
        if ($Success) {
            try {
                if (-not $WhatIf) {
                    Set-MsolUserLicense -UserPrincipalName $User.UserPrincipalName -RemoveLicenses $License -ErrorAction Stop
                }
                $Object += @{ Status = $true; Output = $User.UserPrincipalName; Extended = "Removed license $LicenseToReplace from user." }
            } catch {
                $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                $Object += @{ Status = $false; Output = $User.UserPrincipalName; Extended = $ErrorMessage }
            }
        }
    }
    return $Object
}