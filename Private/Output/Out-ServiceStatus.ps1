function Out-ServiceStatus {
    <#
    .SYNOPSIS
    Outputs information about the service status.

    .DESCRIPTION
    The Out-ServiceStatus function is used to display status information about a specific service.

    .PARAMETER Name
    Specifies the name of the service for which the status information is being displayed.

    .EXAMPLE
    Out-ServiceStatus -Name "MyService"
    Outputs status information about the service named "MyService".

    #>
    param(
        [string] $Name
    )
    $WriteInformation = @{
        Text        = '[i]', ' Running ', 'Service', ' for ', $Name
        Color       = [ConsoleColor]::Green, [ConsoleColor]::White, [ConsoleColor]::Green, [ConsoleColor]::White, [ConsoleColor]::Green
        StartSpaces = 0
    }
    Write-Color @WriteInformation
}