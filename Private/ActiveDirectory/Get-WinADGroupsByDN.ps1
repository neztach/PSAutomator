function Get-WinADGroupsByDN {
    <#
    .SYNOPSIS
    Retrieves Active Directory groups based on their DistinguishedName.

    .DESCRIPTION
    This function retrieves Active Directory groups by their DistinguishedName. It returns specific properties of the groups such as DistinguishedName, GroupCategory, GroupScope, Name, ObjectClass, ObjectGUID, SamAccountName, and SID.

    .PARAMETER DistinguishedName
    Specifies the DistinguishedName of the Active Directory groups to retrieve.

    .PARAMETER Field
    Specifies the field to return for each group. Default is 'Name'.

    .PARAMETER All
    Indicates whether to return all properties of the groups.

    .EXAMPLE
    Get-WinADGroupsByDN -DistinguishedName 'CN=Disabled Users,OU=SecurityGroups,OU=Groups,OU=Production,DC=ad,DC=evotec,DC=xyz'
    Retrieves the group with the specified DistinguishedName.

    #>

    <# Returns one of the values
    DistinguishedName : CN=Disabled Users,OU=SecurityGroups,OU=Groups,OU=Production,DC=ad,DC=evotec,DC=xyz
    GroupCategory     : Security
    GroupScope        : Universal
    Name              : Disabled Users
    ObjectClass       : group
    ObjectGUID        : b7b5961e-e190-4f01-973f-abdf824261a3
    SamAccountName    : Disabled Users
    SID               : S-1-5-21-853615985-2870445339-3163598659-1162
    #>

    param(
        [alias('DN')][string[]] $DistinguishedName,
        [string] $Field = 'Name', # return field
        [switch] $All
    )
    $Output = foreach ($DN in $DistinguishedName) {
        try {
            Get-AdGroup -Identity $DN
        } catch {
            # returns empty, basically ignores stuff
        }
    }
    if ($All) {
        return $Output
    } else {
        return $Output.$Field
    }
}




#Get-WinADUsersByDN -DistinguishedName 'CN=Przemyslaw Klys,OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz'