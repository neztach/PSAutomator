Clear-Host
Import-Module PSAutomator -Force #-Verbose
Import-Module PSSharedGoods #-Force

<#

Service -Name 'Active Directory Offboarding' -Status Enable -ConfigurationPath 'C:\Support\GitHub\PSAutomator\Examples\MyConfiguration1.xml' {
    Trigger -Name 'OU Offboarded Users' -Trigger OrganizationalUnit -Value 'OU=Users-Offboarded,OU=Production,DC=ad,DC=evotec,DC=xyz'
}



Service -Name 'Active Directory Prepare Users' {
    Trigger -Name 'Enable already disabled users' -Trigger OrganizationalUnit -Value 'OU=Users-Offboarded,OU=Production,DC=ad,DC=evotec,DC=xyz' |
        Ignore |
        ActionActiveDirectory -Name 'Enable Evotec Users' -Action AccountEnable |
        ActionActiveDirectory -Name 'Add to group' -Action AccountAddGroupsSpecific -Value 'Disabled Users'
}
#>

<#


Service -Name 'Active Directory Disable Users in Group' {
    Trigger -Name 'Dwa' -Trigger GroupMembership -Value 'Disabled Users' |
        Ignore |
        ActionActiveDirectory -Name 'Disable Evotec Users' -Action AccountDisable
}
#>

Service -Name 'Active Directory Offboarding' -ConfigurationPath 'C:\Support\GitHub\PSAutomator\Examples\MyConfiguration.xml' {
    Trigger -Name 'OU Offboarded Users' -User Filter -Value @{ Filter = "UserPrincipalName -eq 'przemyslaw.klys@ad.evotec.xyz'"; SearchBase = 'OU=Users,OU=Production,DC=ad,DC=evotec,DC=xyz' }  |
        Condition -Name 'No conditions' |
        Ignore -Name 'Ignore Windows Email Address if Empty or null' -Ignore MatchingEmptyOrNull -Value EmailAddress |
        ActionActiveDirectory -Name 'Make User Snapshot' -Action AccountSnapshot -Value 'C:\Users\pklys\Desktop\MyExpor'
}


return

Service -Name 'Active Directory Offboarding' -ConfigurationPath 'C:\Support\GitHub\PSAutomator\Examples\MyConfiguration.xml' {
    Trigger -Name 'OU Offboarded Users' -User OrganizationalUnit -Value 'OU=Users-Offboarded,OU=Production,DC=ad,DC=evotec,DC=xyz' |
        Condition -Name 'No conditions' |
        Ignore -Name 'Ignore Windows Email Address if Empty or null' -Ignore MatchingEmptyOrNull -Value EmailAddress |
        ActionActiveDirectory -Name 'Make User Snapshot' -Action AccountSnapshot -Value 'C:\Users\pklys\Desktop\MyExport' |
        ActionActiveDirectory -Name 'Disable AD Account' -Action AccountDisable |
        ActionActiveDirectory -Name 'Hide account in GAL' -Action AccountHideInGAL |
        ActionActiveDirectory -Name 'Rename Account' -Action AccountRename -Value @{ Action = 'AddText'; Where = 'After'; Text = ' (offboarded)'; } |
        ActionActiveDirectory -Name 'Remove all security groups' -Action AccountRemoveGroupsSecurity
}

<#

Service -Name 'Active Directory Offboarding' -ConfigurationPath 'C:\Support\GitHub\PSAutomator\Examples\MyConfiguration.xml' {
    Trigger -Name 'Reenabling my users for testing purposes' -Trigger OrganizationalUnit -Value 'OU=Users-Offboarded,OU=Production,DC=ad,DC=evotec,DC=xyz' |
        Condition -Name 'No conditions' |
        Ignore -Name 'Ignore Windows Email Address if Empty or null' -Ignore MatchingEmptyOrNull -Value WindowsEmailAddress |
        ActionActiveDirectory -Name 'Enable AD Account' -Action AccountEnable |
        ActionActiveDirectory -Name 'Add Domain Admins' -Action AccountAddGroupsSpecific -Value 'Domain Admins'
}

#>
