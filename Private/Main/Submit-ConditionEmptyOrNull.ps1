function Submit-ConditionEmptyOrNull {
    <#
    .SYNOPSIS
    This function filters objects based on whether a specified field is empty or null.

    .DESCRIPTION
    The Submit-ConditionEmptyOrNull function is used to filter objects based on whether a specified field is empty or null.

    .PARAMETER Object
    Specifies the object to filter.

    .PARAMETER Value
    Specifies the field to check for empty or null values.

    .EXAMPLE
    Submit-ConditionEmptyOrNull -Object $object -Value 'FieldName'
    Filters the object based on whether the 'FieldName' is empty or null.

    #>
    param(
        [Object] $Object,
        [Object] $Value
    )
    $Field = "$Value"
    $ObjectOutput = $Object | Where-Object { $null -ne $_.$Field -and $_.$Field -ne '' }

    #$CountBefore = $Object.Count
    #$CountAfter = $ObjectOutput.Count

    return $ObjectOutput
}