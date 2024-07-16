function Out-ActionStatus {
    <#
    .SYNOPSIS
    Outputs information about the action status.

    .DESCRIPTION
    The Out-ActionStatus function is used to display status information about a specific action being executed.

    .PARAMETER CommandOutput
    Specifies the output of the command that is being executed.

    .PARAMETER User
    Specifies the user object for which the action status is being displayed.

    .PARAMETER UserAzureAD
    Specifies the Azure Active Directory user object for which the action status is being displayed.

    .PARAMETER Name
    Specifies the name of the action being executed.

    .PARAMETER WhatIf
    Indicates whether the action is a simulation or actual execution.

    .EXAMPLE
    Out-ActionStatus -CommandOutput $output -User $user -Name "Action1" -WhatIf
    Outputs status information about the action named "Action1" for the specified user in simulation mode.

    .EXAMPLE
    Out-ActionStatus -CommandOutput $output -UserAzureAD $userAzureAD -Name "Action2"
    Outputs status information about the action named "Action2" for the specified Azure Active Directory user.

    #>
    [CmdletBinding(DefaultParameterSetName = 'ActiveDirectory')]
    param(
        [parameter(Mandatory = $false)][Array] $CommandOutput,
        [parameter(Mandatory = $true, ParameterSetName = "ActiveDirectory")][Object] $User,
        [parameter(Mandatory = $true, ParameterSetName = "AzureActiveDirectory")][Object] $UserAzureAD, # [Microsoft.Online.Administration.User] $UserAzureAD,
        [parameter(Mandatory = $true)][string] $Name,
        [switch] $WhatIf
    )
    switch ($PSCmdlet.ParameterSetName) {
        ActiveDirectory {
            $UserInformation = $User.DistinguishedName
        }
        AzureActiveDirectory {
            $UserInformation = $UserAzureAD.UserPrincipalName
        }
    }
    if ($WhatIf) {
        $WriteSuccess = @{
            Text        = '[+] ', 'WhatIf: ', 'Execution ', $Name, ' on account ', $UserInformation, ' done.'
            Color       = [System.ConsoleColor]::Cyan, [System.ConsoleColor]::DarkMagenta, [System.ConsoleColor]::White, [System.ConsoleColor]::Cyan,
            [System.ConsoleColor]::White, [System.ConsoleColor]::Cyan, [System.ConsoleColor]::White, [System.ConsoleColor]::Cyan,
            [System.ConsoleColor]::White, [System.ConsoleColor]::Cyan
            StartSpaces = 8
        }
        $WriteSkip = @{
            Text        = '[+] ', 'WhatIf: ', 'Execution ', $Name, ' on account ', $UserInformation, ' done.'
            Color       = 'Yellow', [System.ConsoleColor]::DarkMagenta, 'White', 'Yellow', 'White', 'Yellow', 'White', 'Yellow', 'White', 'Yellow'
            StartSpaces = 8
        }

        $WriteStatusSuccess = @{
            StartSpaces = 12
            Color       = 'Green', [System.ConsoleColor]::DarkMagenta, 'White', 'Green', 'White', 'Green'
        }
        $WriteStatusFail = @{
            StartSpaces = 12
            Color       = 'Red', [System.ConsoleColor]::DarkMagenta, 'White', 'Red', 'White', 'Red'
        }

    } else {
        $WriteSuccess = @{
            Text        = '[+] ', 'Execution ', $Name, ' on account ', $UserInformation, ' done.'
            Color       = 'Cyan', 'White', 'Cyan', 'White', 'Cyan', 'White', 'Cyan', 'White', 'Cyan'
            StartSpaces = 8
        }
        $WriteSkip = @{
            Text        = '[+] ', 'Execution ', $Name, ' on account ', $UserInformation, ' done.'
            Color       = 'Yellow', 'White', 'Yellow', 'White', 'Yellow', 'White', 'Yellow', 'White', 'Yellow'
            StartSpaces = 8
        }

        $WriteStatusSuccess = @{
            StartSpaces = 12
            Color       = 'Green', 'White', 'Green', 'White', 'Green'
        }
        $WriteStatusFail = @{
            StartSpaces = 12
            Color       = 'Red', 'White', 'Red', 'White', 'Red'
        }
    }

    if ($CommandOutput) {
        Write-Color @WriteSuccess
        foreach ($Output in $CommandOutput) {
            if ($Output.Status) {
                if ($WhatIf) {
                    Write-Color @WriteStatusSuccess -Text '[+] ', 'WhatIf: ', 'Successfully processed ', $Output.Output, ' Extended information: ', $Output.Extended
                } else {
                    Write-Color @WriteStatusSuccess -Text '[+] ', 'Successfully processed ', $Output.Output, ' Extended information: ', $Output.Extended
                }
            } else {
                if ($WhatIf) {
                    Write-Color @WriteStatusFail -Text '[-] ', 'Whatif: ', 'Skipped ', $Output.Output, ' Extended information: ', $Output.Extended
                } else {
                    Write-Color @WriteStatusFail -Text '[-] ', 'Skipped ', $Output.Output, ' Extended information: ', $Output.Extended
                }
            }
        }
    } else {
        Write-Color @WriteSkip
    }
}