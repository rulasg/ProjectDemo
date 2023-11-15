function Add-PriorityFieldToProject{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory,Position=0)] [string]$ProjectNumber,
        [Parameter()] [string]$Owner
    )

    $owner = Get-EnvironmentOwner -Owner $Owner

    $fieldName = "Priority"
    $options= "🔥Critical,🥵High,😊Normal,🥶Low"

    Add-FieldSingleSelectToProject -ProjectNumber $ProjectNumber -Owner $Owner -FieldName $fieldName -Options $options

} Export-ModuleMember -Function Add-PriorityFieldToProject

function Add-SeverityFieldToProject{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory,Position=0)] [string]$ProjectNumber,
        [Parameter()] [string]$Owner
    )

    $owner = Get-EnvironmentOwner -Owner $Owner

    $fieldName = "Severity"
    $options= "Critical⭐️⭐️⭐️⭐️,Important⭐️⭐️⭐️,Needed⭐️⭐️,Nice⭐️" 

    Add-FieldSingleSelectToProject -ProjectNumber $ProjectNumber -Owner $Owner -FieldName $fieldName -Options $options

} Export-ModuleMember -Function Add-SeverityFieldToProject

function Add-CommentFieldToProject{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory,Position=0)] [string]$ProjectNumber,
        [Parameter()] [string]$Owner
    )

    $owner = Get-EnvironmentOwner -Owner $Owner

    $fieldname = "Comment"

    Add-FieldText -ProjectNumber $ProjectNumber -FieldName $fieldname -Owner $Owner

} Export-ModuleMember -Function Add-CommentFieldToProject