function Add-PriorityFieldToProject{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory,Position=0)] [string]$ProjectNumber,
        [Parameter()] [string]$Owner,
        [Parameter()][switch]$Update
    )

    $owner = Get-EnvironmentOwner -Owner $Owner

    $fieldName = "Priority"
    $options= "🔥Critical,🥵High,😊Normal,🥶Low"

    Add-FieldSingleSelectToProject -ProjectNumber $ProjectNumber -Owner $Owner -FieldName $fieldName -Options $options

    if($Update){
        Update-FieldValueWithSingleSelect -ProjectNumber $ProjectNumber -FieldName $fieldName -Owner $Owner
    }

} Export-ModuleMember -Function Add-PriorityFieldToProject

function Add-SeverityFieldToProject{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory,Position=0)] [string]$ProjectNumber,
        [Parameter()][switch]$Update,
        [Parameter()] [string]$Owner
    )

    $owner = Get-EnvironmentOwner -Owner $Owner

    $fieldName = "Severity"
    $options= "Critical⭐️⭐️⭐️⭐️,Important⭐️⭐️⭐️,Needed⭐️⭐️,Nice⭐️" 

    Add-FieldSingleSelectToProject -ProjectNumber $ProjectNumber -Owner $Owner -FieldName $fieldName -Options $options

    if($Update){
        Update-FieldValueWithSingleSelect -ProjectNumber $ProjectNumber -FieldName $fieldName -Owner $Owner
    }

} Export-ModuleMember -Function Add-SeverityFieldToProject

function Add-CommentFieldToProject{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory,Position=0)] [string]$ProjectNumber,
        [Parameter()][switch]$Update,
        [Parameter()] [string]$Owner
    )

    $owner = Get-EnvironmentOwner -Owner $Owner

    $fieldname = "Comment"

    Add-FieldText -ProjectNumber $ProjectNumber -FieldName $fieldname -Owner $Owner

    if($Update){
        Update-FieldValueWithText -ProjectNumber $ProjectNumber -FieldName $fieldname -Owner $Owner -options @("This is a comment", "This is another comment", "This is a third comment")
    }

} Export-ModuleMember -Function Add-CommentFieldToProject

function Add-TimeTrackerFieldToProject{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory,Position=0)] [string]$ProjectNumber,
        [Parameter()][switch]$Update,
        [Parameter()] [string]$Owner
    )

    $owner = Get-EnvironmentOwner -Owner $Owner

    $fieldname = "TimeTraker"

    Add-FieldNumber -ProjectNumber $ProjectNumber -FieldName $fieldname -Owner $Owner

    if($Update){
        Update-FieldValueWithNumber -ProjectNumber $ProjectNumber -FieldName $fieldname -Owner $Owner -min 20 -max 500
    }


} Export-ModuleMember -Function Add-TimeTrackerFieldToProject

function Add-StoryPointsFieldToProject{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory,Position=0)] [string]$ProjectNumber,
        [Parameter()][string]$Owner,
        [Parameter()][switch]$Update
    )

    $owner = Get-EnvironmentOwner -Owner $Owner

    $fieldname = "UserStories"

    Add-FieldNumber -ProjectNumber $ProjectNumber -FieldName $fieldname -Owner $Owner

    if($Update){
        Update-FieldValueWithNumberFibonacci -ProjectNumber $ProjectNumber -FieldName $fieldname -Owner $Owner
    }

} Export-ModuleMember -Function Add-StoryPointsFieldToProject

function Add-WellknonFieldsToProject{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory,Position=0)] [string]$ProjectNumber,
        [Parameter()][switch]$Update,
        [Parameter()] [string]$Owner
    )

    $owner = Get-EnvironmentOwner -Owner $Owner

    Add-PriorityFieldToProject    -ProjectNumber $ProjectNumber -Owner $Owner -Update:$Update
    Add-SeverityFieldToProject    -ProjectNumber $ProjectNumber -Owner $Owner -Update:$Update
    Add-CommentFieldToProject     -ProjectNumber $ProjectNumber -Owner $Owner -Update:$Update
    Add-TimeTrackerFieldToProject -ProjectNumber $ProjectNumber -Owner $Owner -Update:$Update
    Add-StoryPointsFieldToProject -ProjectNumber $ProjectNumber -Owner $Owner -Update:$Update

} Export-ModuleMember -Function Add-WellknonFieldsToProject
