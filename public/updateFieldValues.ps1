
function Update-FieldValueWithSingleSelect{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory,ValueFromPipeline)][string]$ProjectNumber,
        [Parameter(Mandatory)] [string]$FieldName,
        [Parameter()] [string]$Owner
    )

    $Owner = Get-EnvironmentOwner -Owner $Owner

    $projectId = Get-ProjectId $ProjectNumber            -Owner $Owner
    $fieldId = Get-FieldId     $ProjectNumber $FieldName -Owner $Owner 
    $field   = Get-Field       $ProjectNumber $FieldName -Owner $Owner 
    $fieldId = $field.id
    $options = $field.options
    $items = Get-ProjectItems  $ProjectNumber            -Owner $Owner

    "Found [{0}] items to edit" -f $items.Count | Write-Verbose

    foreach($item in $items){
        $id = Get-Random -Minimum 0 -Maximum $options.Count

        $optionId = $options[$id].id

        $result = Edit-ItemField $projectId $fieldId $item.Id -OptionId $optionId

        $result
    }

    # foreach($item in $items){
    #     $random = Get-Random -Minimum 0 -Maximum $($options.Count)

    #     $optionId = $options[$random].id

    #     $command = 'gh project item-edit --id {itemd} --field-id {fieldid} --project-id {projectid}  --single-select-option-id {optionid}'
    #     $command = $command -replace "{itemd}", $item.Id
    #     $command = $command -replace "{fieldid}", $fieldId
    #     $command = $command -replace "{projectid}", $projectId
    #     $command = $command -replace "{optionid}", $optionId
        
    #     "Updating item [{0}] with option [{1}]" -f $item.title, $options[$random].name | Write-MyVerbose

    #     if ($PSCmdlet.ShouldProcess($item.tittle, $command)) {
    #         $command | Write-Information
    #         $result = Invoke-Expression $command
    #     }
    # }

    "End shuffling field values" | Write-MyVerbose -NewLine

} Export-ModuleMember -Function Update-FieldValueWithSingleSelect

function Update-FieldValueWithNumber{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory,Position=0,ValueFromPipeline)][string]$ProjectNumber,
        [Parameter(Mandatory,Position=1)][string]$FieldName,
        [Parameter(Mandatory,Position=2)][int32]$min,
        [Parameter(Mandatory,Position=3)][int32]$max,
        [Parameter()][string]$Owner
    )

    $Owner = Get-EnvironmentOwner -Owner $Owner

    $projectId = Get-ProjectId $ProjectNumber            -Owner $Owner
    $fieldId = Get-FieldId     $ProjectNumber $FieldName -Owner $Owner 
    $items = Get-ProjectItems  $ProjectNumber            -Owner $Owner

    "Found [{0}] items to edit" -f $items.Count | Write-Verbose

    foreach($item in $items){
        $number = Get-Random -Minimum $min -Maximum $max

        $result = Edit-ItemField $projectId $fieldId $item.Id -Number $number

        $result
    }

    "End shuffling field values" | Write-MyVerbose -NewLine

} Export-ModuleMember -Function Update-FieldValueWithNumber

function Update-FieldValueWithNumberFibonacci{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory,Position=0)][string]$ProjectNumber,
        [Parameter(Mandatory,Position=1)][string]$FieldName,
        [Parameter()][string]$Owner
    )

    $Owner = Get-EnvironmentOwner -Owner $Owner

    $projectId = Get-ProjectId $ProjectNumber            -Owner $Owner
    $fieldId = Get-FieldId     $ProjectNumber $FieldName -Owner $Owner 
    $items = Get-ProjectItems  $ProjectNumber            -Owner $Owner

    "Found [{0}] items to edit" -f $items.Count | Write-Verbose

    $fibonacci = @(
        1,2,3,5,8,13,21,34,55
    )

    foreach($item in $items){
        $id = Get-Random -Minimum 0 -Maximum $fibonacci.Count
        $number = $fibonacci[$id]

        $result = Edit-ItemField $projectId $fieldId $item.Id -Number $number

        $result
    }

    "End shuffling field values" | Write-MyVerbose -NewLine

} Export-ModuleMember -Function Update-FieldValueWithNumberFibonacci

function Update-FieldValueWithText{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory,ValueFromPipeline)][string]$ProjectNumber,
        [Parameter(Mandatory)] [string]$FieldName,
        [Parameter()][string]$Owner,
        [Parameter()][string[]]$options
    )

    $Owner = Get-EnvironmentOwner -Owner $Owner

    $projectId = Get-ProjectId $ProjectNumber            -Owner $Owner
    $fieldId = Get-FieldId     $ProjectNumber $FieldName -Owner $Owner 
    $items = Get-ProjectItems  $ProjectNumber            -Owner $Owner

    "Found [{0}] items to edit" -f $items.Count | Write-Verbose

    foreach($item in $items){
        $id = Get-Random -Minimum 0 -Maximum $options.Count

        $text = $options[$id]

        $result = Edit-ItemField $projectId $fieldId $item.Id -Text $text

        $result
    }

    "End shuffling field values" | Write-MyVerbose -NewLine
} Export-ModuleMember -Function Update-FieldValueWithText

function Update-FieldValueWithDate{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory,Position=0,ValueFromPipeline)][string]$ProjectNumber,
        [Parameter(Mandatory,Position=1)][string]$FieldName,
        [Parameter()][string]$Owner
    )

    $Owner = Get-EnvironmentOwner -Owner $Owner

    $projectId = Get-ProjectId $ProjectNumber            -Owner $Owner
    $fieldId = Get-FieldId     $ProjectNumber $FieldName -Owner $Owner 
    $items = Get-ProjectItems  $ProjectNumber            -Owner $Owner

    "Found [{0}] items to edit" -f $items.Count | Write-Verbose

    $today = Get-Date

    foreach($item in $items){
        $offset = Get-Random -Minimum -10 -Maximum 30
        $date = $today.AddDays($offset)

        $datestr = $date.ToString("yyyy-MM-dd")

        $result = Edit-ItemField $projectId $fieldId $item.Id -Date $datestr

        $result
    }

    "End shuffling field values" | Write-MyVerbose -NewLine

} Export-ModuleMember -Function Update-FieldValueWithDate