function Get-WinAzureADUsers {
    <#
    .SYNOPSIS
    Retrieves Azure AD users based on specified criteria.

    .DESCRIPTION
    This function retrieves Azure AD users based on various criteria such as user principal name, domain name, country, city, department, etc. It allows filtering by different attributes and options to narrow down the search results.

    .PARAMETER Filter
    Specifies the filter criteria for retrieving users. Valid options are 'All', 'DisabledOnly', 'EnabledOnly'.

    .PARAMETER MaxResults
    Specifies the maximum number of results to return. Default is set to 5000000.

    .PARAMETER UserPrincipalName
    Specifies the user principal name to search for.

    .PARAMETER ReturnDeletedUsers
    Indicates whether to include deleted users in the search results.

    .PARAMETER ReturnUnlicensedUsers
    Indicates whether to include unlicensed users in the search results.

    .PARAMETER Country
    Specifies the country of the users to search for.

    .PARAMETER City
    Specifies the city of the users to search for.

    .PARAMETER Department
    Specifies the department of the users to search for.

    .PARAMETER State
    Specifies the state of the users to search for.

    .PARAMETER Synchronized
    Indicates whether to include synchronized users in the search results.

    .PARAMETER DomainName
    Specifies the domain name of the users to search for.

    .PARAMETER Title
    Specifies the title of the users to search for.

    .PARAMETER All
    Indicates to retrieve all users without any filtering.

    .PARAMETER LicenseReconciliationNeededOnly
    Indicates to retrieve users for whom license reconciliation is needed.

    .PARAMETER SearchString
    Specifies a search string to filter users based on specific criteria.

    .PARAMETER HasErrorsOnly
    Indicates to retrieve users with errors only.

    .PARAMETER TenantId
    Specifies the tenant ID to search for.

    .PARAMETER UsageLocation
    Specifies the usage location of the users to search for.
    #>
    [CmdletBinding()]
    param(
        [ValidateSet("All", "DisabledOnly", "EnabledOnly")][string] $Filter = 'All',
        [int] $MaxResults = 5000000,
        [string] $UserPrincipalName,
        [switch] $ReturnDeletedUsers,
        [switch] $ReturnUnlicensedUsers,
        [string] $Country,
        [string] $City,
        [string] $Department,
        [string] $State,
        [switch] $Synchronized,
        [string] $DomainName,
        [string] $Title,
        [switch] $All,
        [switch] $LicenseReconciliationNeededOnly,
        [string] $SearchString,
        [switch] $HasErrorsOnly,
        [Guid] $TenantId,
        [string] $UsageLocation

    )

    $UserSplat = @{}
    if ($UserPrincipalName) { $UserSplat.UserPrincipalName = $UserPrincipalName }

    if ($DomainName) { $UserSplat.DomainName = $DomainName }

    if ($MaxResults) { $UserSplat.MaxResults = $MaxResults }

    <#
    EnabledFilter                   = $Filter
    ReturnDeletedUsers              = $ReturnDeletedUsers
    UnlicensedUsersOnly             = $ReturnUnlicensedUsers

    Country                         = $Country
    City                            = $City
    State                           = $State
    UsageLocation                   = $UsageLocation

    Title                           = $Title
    Department                      = $Department



    LicenseReconciliationNeededOnly = $LicenseReconciliationNeededOnly
    SearchString                    = $SearchString
    HasErrorsOnly                   = $HasErrorsOnly
    TenantID                        = $TenantId
    #>

    if ($All) {
        #$UserSplat.All = $All
        #$UserSplat.DomainName = 'evotec.xyz'

    }

    $Users = Get-MsolUser -All:$All -Synchronized:$Synchronized -ReturnDeletedUsers:$ReturnDeletedUsers -UnlicensedUsersOnly:$ReturnUnlicensedUsers
    $Users

}

#Get-WinAzureADUsers -MaxResults 3 -Country 'Poland' -ReturnDeletedUsers -ReturnUnlicensedUsers