function Condition {
    <#
    .SYNOPSIS
    This function defines a condition for a specific object based on the provided parameters.

    .DESCRIPTION
    The Condition function is used to set a condition for a given object. It allows for defining conditions that need to be met for further processing.

    .PARAMETER Object
    Specifies the object to which the condition is applied.

    .PARAMETER Name
    Specifies a name for the condition.

    .PARAMETER Condition
    Specifies the condition to be set.

    .PARAMETER Value
    Specifies the value associated with the condition.

    .EXAMPLE
    Condition -Object $obj -Name "Condition1" -Condition $condition -Value "12345"
    Sets a condition named "Condition1" for the specified object with the value "12345".

    #>
    [CmdletBinding()]
    [alias('Ignore')]
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $false, Position = 0)] $Object,
        [string] $Name,
        [alias('Ignore')][PSAutomator.Condition] $Condition,
        [Object] $Value
    )
    Begin {}
    Process {
        if ($null -eq $Object) {
            Write-Warning "Condition can't be used out of order. Terminating!"
            Exit
        }
        $Object.Conditions += @{
            Name      = if ($Name -eq '') { 'No name given' } else { $Name }
            Condition = $Condition
            Value     = $Value
        }
    }
    End {
        return $Object
    }
}