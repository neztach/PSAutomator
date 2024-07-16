function New-PSAutomatorConfiguration {
    <#
    .SYNOPSIS
    Creates a new PS Automator configuration and exports it to a specified path.

    .DESCRIPTION
    The New-PSAutomatorConfiguration function is used to create a new configuration object and export it to a specified path using Export-Clixml cmdlet.

    .PARAMETER Configuration
    Specifies the configuration object to be exported.

    .PARAMETER Path
    Specifies the path where the configuration object will be exported.

    .EXAMPLE
    New-PSAutomatorConfiguration -Configuration $config -Path "C:\Configurations\config.xml"
    Creates a new PS Automator configuration object and exports it to the specified path.

    #>
    [CmdletBinding()]
    param(
        [Object] $Configuration,
        $Path
    )
    if ($Configuration) {
        $Configuration | Export-Clixml -Path $Path -Encoding UTF8
    }
}