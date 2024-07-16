function Resolve-IgnoreTexts {
    <#
    .SYNOPSIS
    Resolves the ignore texts based on Active Directory domains.

    .DESCRIPTION
    The Resolve-IgnoreTexts function is used to resolve ignore texts based on Active Directory domains. It retrieves documentation text for each ignore text provided and adds them to the list of ignores.

    .PARAMETER IgnoreText
    Specifies an array of ignore texts to be resolved.

    .EXAMPLE
    Resolve-IgnoreTexts -IgnoreText @('Text1', 'Text2')
    Resolves the ignore texts 'Text1' and 'Text2' based on Active Directory domains.

    #>
    param (
        [string[]] $IgnoreText
    )
    $Ignores = New-ArrayList
    foreach ($Ignore in $IgnoreText) {
        if ($Script:ActiveDirectory.Domains) {
            foreach ($Domain in $Script:ActiveDirectory.Domains) {
                $Text = Get-WinDocumentationText -Text $Ignore -Forest $Script:ActiveDirectory.Forest -Domain $Domain
                Add-ToArrayAdvanced -List $Ignores -Element $Text -SkipNull -RequireUnique
            }
        } else {
            $Text = Get-WinDocumentationText -Text $Ignore -Forest $Script:ActiveDirectory.Forest -Domain ''
            Add-ToArrayAdvanced -List $Ignores -Element $Text -SkipNull -RequireUnique
        }
    }
    return $Ignores
}
