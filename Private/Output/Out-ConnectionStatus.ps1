function Out-ConnectionStatus {
    <#
    .SYNOPSIS
    Outputs information about the connection status.

    .DESCRIPTION
    The Out-ConnectionStatus function is used to display status information about a specific connection.

    .PARAMETER CommandOutput
    Specifies the output of the command that is being executed.

    .EXAMPLE
    Out-ConnectionStatus -CommandOutput $output
    Outputs status information about the connection based on the provided output.

    #>
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $false)][Array] $CommandOutput
    )

    $WriteStatusSuccess = @{
        StartSpaces = 8
        Color       = 'Green', 'White', 'Green', 'White', 'Green', 'White', 'Green'
    }
    $WriteStatusFail = @{
        StartSpaces = 8
        Color       = 'Red', 'White', 'Red', 'White', 'Red', 'White', 'Red'
    }
    if ($CommandOutput) {
        foreach ($Output in $CommandOutput) {
            if ($Output.Status) {
                Write-Color @WriteStatusSuccess -Text '[+] ', 'Running ', 'Connection', ' for ', $Output.Output, ' Extended information: ', $Output.Extended
            } else {
                Write-Color @WriteStatusFail -Text '[-] ', 'Running ', 'Connection', ' for ', $Output.Output, ' Extended information: ', $Output.Extended
            }
        }
    }
}