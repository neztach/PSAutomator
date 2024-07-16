function Get-WinADGroups {
    <#
    .SYNOPSIS
    Retrieves Active Directory groups based on specified criteria.

    .DESCRIPTION
    This function retrieves Active Directory groups based on the provided filter or organizational unit. It allows for filtering by various attributes to narrow down the search results.

    .PARAMETER Filter
    Specifies the filter criteria for retrieving groups.

    .PARAMETER OrganizationalUnit
    Specifies the organizational unit to search for groups within.
    #>
    [CmdletBinding()]
    param(
        $Filter,
        $OrganizationalUnit
    )
    $Splatting = @{}
    if ($null -eq $Filter -and $null -eq $OrganizationalUnit) {
        $Splatting = $Filter
    } else {
        if ($OrganizationalUnit) {
            $Splatting.SearchBase = $OrganizationalUnit
        }
        if ($Filter) {
            $Splatting.Filter = $Filter
        }
    }
    $Groups = Get-ADGroup @Splatting -Properties $Script:GroupProperties
    return $Groups
}

#Get-ADGroup -Filter * -Properties * # $Script:GroupProperties


#Get-WinADGroupsByDN -DistinguishedName 'CN=Disabled Users,OU=SecurityGroups,OU=Groups,OU=Production,DC=ad,DC=evotec,DC=xyz' -Field 'Name'
