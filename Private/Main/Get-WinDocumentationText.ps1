function Get-WinDocumentationText {
    <#
    .SYNOPSIS
    Retrieves and replaces placeholders in documentation text based on provided Forest and Domain information.

    .DESCRIPTION
    The Get-WinDocumentationText function retrieves documentation text and replaces placeholders with actual values based on the provided Forest and Domain information.

    .PARAMETER Text
    Specifies an array of documentation text with placeholders to be replaced.

    .PARAMETER Forest
    Specifies the Forest object containing Forest-related information.

    .PARAMETER Domain
    Specifies the Domain name for which the documentation text is being retrieved.

    .EXAMPLE
    Get-WinDocumentationText -Text @('This is <ForestName> documentation for <Domain>', 'Another example for <DomainNetBios>') -Forest $ForestObject -Domain 'DomainName'
    Retrieves and replaces placeholders in the documentation text for the specified Forest and Domain.

    #>
    [CmdletBinding()]
    param (
        [string[]] $Text,
        [Object] $Forest,
        [string] $Domain
    )

    $Replacement = @{
        '<ForestName>'    = $Forest.ForestName
        '<ForestNameDN>'  = $Forest.RootDSE.defaultNamingContext
        '<Domain>'        = $Domain
        '<DomainNetBios>' = $Forest.FoundDomains.$Domain.DomainInformation.NetBIOSName
        '<DomainDN>'      = $Forest.FoundDomains.$Domain.DomainInformation.DistinguishedName
    }
    $Array = @()
    foreach ($T in $Text) {
        foreach ($Key in $Replacement.Keys) {
            if ($T -like "*$Key*") {
                if ($Replacement.$Key) {
                    $T = $T.Replace($Key, $Replacement.$Key)
                } else {
                    Write-Warning "Replacing $Key failed. No value available for substition"
                }
            }
        }
        $Array += $T
    }
    return $Array
}