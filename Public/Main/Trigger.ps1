Function Trigger {
    <#
    .SYNOPSIS
    This function triggers a specific action based on the provided parameters.

    .DESCRIPTION
    The Trigger function is used to initiate a specific action based on the input parameters. It allows for triggering actions for different types of objects such as users, groups, computers, etc.

    .PARAMETER Object
    Specifies the object on which the action is triggered.

    .PARAMETER Name
    Specifies the name of the trigger.

    .PARAMETER User
    Specifies the user object for the trigger (Parameter Set Name: User).

    .PARAMETER UserAzureAD
    Specifies the Azure Active Directory user object for the trigger (Parameter Set Name: UserAzureAD).

    .PARAMETER Group
    Specifies the group object for the trigger (Parameter Set Name: Group).

    .PARAMETER Computer
    Specifies the computer object for the trigger (Parameter Set Name: Computer).

    .PARAMETER Value
    Specifies the value associated with the trigger.

    .EXAMPLE
    Trigger -Object $obj -Name "Trigger1" -User $user -Value "12345"
    Initiates a trigger named "Trigger1" for the specified user with the value "12345".

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, Position = 0)] $Object,
        [parameter(Mandatory = $false)] [string] $Name,
        [parameter(Mandatory = $false, ParameterSetName = "User")][PSAutomator.TriggerUserAD] $User,
        [parameter(Mandatory = $false, ParameterSetName = "UserAzureAD")][PSAutomator.TriggerUserAzureAD] $UserAzureAD,
        [parameter(Mandatory = $false, ParameterSetName = "Group")][PSAutomator.TriggerGroup] $Group,
        [parameter(Mandatory = $false, ParameterSetName = "Computer")][PSAutomator.TriggerComputer] $Computer,
        [parameter(Mandatory = $false)] [Object] $Value
    )
    Begin {

    }
    Process {
        if ($null -eq $Object) {
            # if object is null it's the first one
            $Object = [ordered] @{
                Triggers       = @()
                Conditions     = @()
                Ignores        = @()
                Actions        = @()
                ProcessingData = @{
                    Users = @()
                }
            }
        }
        $Trigger += @{
            Name  = $Name
            Value = $Value
            Type  = $PSCmdlet.ParameterSetName
        }
        switch ($PSCmdlet.ParameterSetName) {
            User {
                $Trigger.Trigger = $User
            }
            UserAzureAD {
                $Trigger.Trigger = $UserAzureAD
            }
            Group {
                $Trigger.Trigger = $Group
            }
            Computer {
                $Trigger.Trigger = $Computer
            }

        }
        $Object.Triggers += $Trigger
    }
    End {
        return $Object
    }
}