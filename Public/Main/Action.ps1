Function Action {
    <#
    .SYNOPSIS
    Performs an action on an object.

    .DESCRIPTION
    This function performs a specified action on an object based on the parameters provided.

    .PARAMETER Object
    The object on which the action will be performed.

    .PARAMETER Name
    The name of the action.

    .PARAMETER ActiveDirectory
    Specifies an action related to Active Directory.

    .PARAMETER AzureActiveDirectory
    Specifies an action related to Azure Active Directory.

    .PARAMETER Exchange
    Specifies an action related to Exchange.

    .PARAMETER Value
    The value associated with the action.

    .PARAMETER WhatIf
    Shows what would happen if the action is run without actually running it.

    .EXAMPLE
    Action -Object $obj -Name "ExampleAction" -Value "123" -WhatIf
    Performs the action "ExampleAction" on the object $obj with the value "123" in a simulated environment.

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, Position = 0)] $Object,
        [parameter(Mandatory = $false)] [string] $Name,
        [parameter(Mandatory = $false, ParameterSetName = "ActiveDirectory")][PSAutomator.ActionAD] $ActiveDirectory,
        [parameter(Mandatory = $false, ParameterSetName = "AzureActiveDirectory")][PSAutomator.ActionAzureAD] $AzureActiveDirectory,
        [parameter(Mandatory = $false, ParameterSetName = "Exchange")][PSAutomator.ActionExchange] $Exchange,
        [parameter(Mandatory = $false)] [Object] $Value,
        [parameter(Mandatory = $false)] [switch] $WhatIf
    )
    Begin {}
    Process {
        if ($null -eq $Object) {
            Write-Warning "Action can't be used out of order. Terminating!"
            Exit
        }
        $Action = @{
            Name   = $Name
            Value  = $Value
            Type   = $PSCmdlet.ParameterSetName
            WhatIf = $WhatIf
        }
        switch ($PSCmdlet.ParameterSetName) {
            ActiveDirectory {
                $Action.Action = $ActiveDirectory
            }
            AzureActiveDirectory {
                $Action.Action = $AzureActiveDirectory
            }
            Exchange {
                $Action.Action = $Exchange
            }
        }

        # Add prepared data to Object
        $Object.Actions += $Action
    }
    End {
        return $Object
    }
}