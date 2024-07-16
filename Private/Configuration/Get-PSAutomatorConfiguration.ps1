function Get-PSAutomatorConfiguration {
    <#
    .SYNOPSIS
    Retrieves the configuration settings for the PS Automator tool.

    .DESCRIPTION
    The Get-PSAutomatorConfiguration function is used to retrieve the configuration settings for the PS Automator tool. It loads the configuration from the specified path and stores it in the global variable $Script:Configuration.

    .PARAMETER ConfigurationPath
    Specifies the path to the configuration file containing the settings for the PS Automator tool.

    .EXAMPLE
    Get-PSAutomatorConfiguration -ConfigurationPath 'C:\Configurations\PSAutomatorConfig.xml'
    Retrieves the configuration settings from the specified path for the PS Automator tool.

    #>
    [CmdletBinding()]
    param(
        $ConfigurationPath
    )
    if (($ConfigurationPath) -and (Test-Path $ConfigurationPath)) {
        $Script:Configuration = Import-Clixml -Path $ConfigurationPath
    } else {
        $Script:Configuration = $null
    }
}