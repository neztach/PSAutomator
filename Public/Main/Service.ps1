Function Service {
    <#
    .SYNOPSIS
    This function provides a service with specified parameters and executes a workflow based on the provided data.

    .DESCRIPTION
    The Service function is used to manage and execute a service with the given name, status, tags, configuration path, and service data script block. It starts by logging the time and then proceeds to execute the service workflow.

    .PARAMETER Name
    Specifies the name of the service.

    .PARAMETER Status
    Specifies the status of the service. If set to 'Disable', the service will not be executed.

    .PARAMETER Tag
    Specifies tags associated with the service.

    .PARAMETER ConfigurationPath
    Specifies the path to the configuration for the service.

    .PARAMETER ServiceData
    Specifies the script block containing the service data to be executed.

    .EXAMPLE
    Service -Name "MyService" -Status "Enable" -Tag "Tag1", "Tag2" -ConfigurationPath "C:\Config" -ServiceData { Write-Host "Executing service data" }

    Initiates the service named "MyService" with status "Enable", tags "Tag1" and "Tag2", configuration path "C:\Config", and executes the provided service data script block.

    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)][string] $Name,
        [string] $Status,
        [Alias('Tags')][string[]] $Tag = @(),
        [string] $ConfigurationPath,
        [Parameter(Position = 1)][ValidateNotNull()][ScriptBlock] $ServiceData = $(Throw "No test script block is provided. (Have you put the open curly brace on the next line?)")
    )
    Begin {
        $TimeRun = Start-TimeLog
    }
    Process {
        if ($Status -eq 'Disable') { return }
        Out-ServiceStatus -Name $Name
        Get-PSAutomatorConfiguration -ConfigurationPath $ConfigurationPath

        $Object = Invoke-Command -ScriptBlock $ServiceData
        $Final = Complete-WorkFlow -Object $Object
    }
    End {
        $TimeEnd = $TimeRun | Stop-TimeLog -Option 'Array'

        $WriteInformation = @{
            Text        = '[i]', ' Ending Service for ', $Name, ' - Time to Execute: ', $TimeEnd
            Color       = [ConsoleColor]::Green, [ConsoleColor]::White, [ConsoleColor]::Green, [ConsoleColor]::Green, [ConsoleColor]::White
            LinesAfter  = 1
            StartSpaces = 0
        }
        Write-Color @WriteInformation

        # Finish Service
        $Script:Configuration = $null
        return #$Final
    }
}