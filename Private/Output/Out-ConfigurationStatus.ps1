function Out-ConfigurationStatus {
    <#
    .SYNOPSIS
    Outputs information about the configuration status.

    .DESCRIPTION
    The Out-ConfigurationStatus function is used to display status information about the configuration process.

    .PARAMETER CommandOutput
    Specifies the output of the command that is being executed.

    .PARAMETER Option
    Specifies the option for which the configuration status is being displayed. Default is 'Start'.

    .EXAMPLE
    Out-ConfigurationStatus -CommandOutput $output -Option 'Start'
    Outputs status information about the start of the configuration process.

    .EXAMPLE
    Out-ConfigurationStatus -CommandOutput $output -Option 'End'
    Outputs status information about the end of the configuration process.

    .EXAMPLE
    Out-ConfigurationStatus -CommandOutput $output -Option 'Invalid'
    Outputs status information about a failed configuration process.

    #>
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $false)][Array] $CommandOutput,
        [string] $Option = 'Start'
    )

    $WriteStatusSuccess = @{
        StartSpaces = 4
        Color       = 'Green', 'White', 'Green', 'White', 'Green', 'White', 'Green'
    }
    $WriteStatusEnd = @{
        StartSpaces = 4
        Color       = 'Green', 'White', 'Green', 'White', 'Green', 'White', 'Green'
    }
    $WriteStatusFail = @{
        StartSpaces = 4
        Color       = 'Red', 'White', 'Red', 'White', 'Red', 'White', 'Red'
    }
    if ($Option -eq 'Start') {
        Write-Color @WriteStatusSuccess -Text '[+] ', 'Running ', 'Configuration'
    } elseif ($Option -eq 'End') {
        Write-Color @WriteStatusEnd -Text '[+] ', 'Ending ', 'Configuration'
    } else {
        Write-Color @WriteStatusFail -Text '[-] ', 'Failed ', 'Configuration'
    }
}