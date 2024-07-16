function Out-TriggerStatus {
    <#
    .SYNOPSIS
    Outputs information about the trigger being executed.

    .DESCRIPTION
    The Out-TriggerStatus function is used to display status information about the trigger currently being executed.

    .PARAMETER Trigger
    Specifies the trigger object for which the status information is being displayed.

    .EXAMPLE
    Out-TriggerStatus -Trigger $trigger
    Outputs status information about the specified trigger.

    #>
    param(
        $Trigger
    )
    $WriteInformation = @{
        Text        = '[+]', ' Running Trigger', ' for ', $Trigger.Name
        Color       = [ConsoleColor]::Green, [ConsoleColor]::White, [ConsoleColor]::White, [ConsoleColor]::Green
        StartSpaces = 4
    }
    Write-Color @WriteInformation
}