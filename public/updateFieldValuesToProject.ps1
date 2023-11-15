
function Update-FieldValueSingleSelectToProject{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory,ValueFromPipeline)][string]$ProjectNumber,
        [Parameter(Mandatory)] [string]$FieldName,
        [Parameter()] [string]$Owner
    )

    $Owner = Get-EnvironmentOwner -Owner $Owner

    ## Figure out the project ID
    "Figure out the project ID" | Write-Verbose
    $command = 'gh project view {projectnumber} --owner {owner} --format json'
    $command = $command -replace "{projectnumber}", $ProjectNumber
    $command = $command -replace "{owner}", $Owner
    $command | Write-Verbose

    $resultJson = Invoke-Expression $command
    $result = $resultJson | ConvertFrom-Json
    $projectId = $result | Select-Object -ExpandProperty id

    ## Figure out the field ID
    "FigureOut the field ID" | Write-Verbose
    $comand = 'gh project field-list  {projectnumber} --format json --owner {owner}'
    $comand = $comand -replace "{projectnumber}", $ProjectNumber
    $comand = $comand -replace "{owner}", $Owner
    $resultJson = Invoke-Expression $comand
    $result = $resultJson | ConvertFrom-Json
    $fields = $result | Select-Object -ExpandProperty fields
    $field = $fields | Where-Object {$_.name -eq $fieldname}
    $options = $field.options 

    $fieldId = $field | Select-Object -ExpandProperty id

    ## populate field to the project items
    "Populate field to the project items" | Write-Verbose
    $command = 'gh project item-list {projectnumber} --owner {owner} --format json'
    $command = $command -replace "{projectnumber}", $ProjectNumber
    $command = $command -replace "{owner}", $Owner
    $command | Write-Verbose
    $resultJson = Invoke-Expression $command
    $result = $resultJson | ConvertFrom-Json 
    $items = $result | Select-Object -ExpandProperty items

    "Found [{0}] items to edit" -f $items.Count | Write-Verbose

    foreach($item in $items){
        $random = Get-Random -Minimum 0 -Maximum $($options.Count)

        $optionId = $options[$random].id

        $command = 'gh project item-edit --id {itemd} --field-id {fieldid} --project-id {projectid}  --single-select-option-id {optionid}'
        $command = $command -replace "{itemd}", $item.Id
        $command = $command -replace "{fieldid}", $fieldId
        $command = $command -replace "{projectid}", $projectId
        $command = $command -replace "{optionid}", $optionId
        
        "Updating item [{0}] with option [{1}]" -f $item.title, $options[$random].name | Write-MyVerbose

        if ($PSCmdlet.ShouldProcess($item.tittle, $command)) {
            $command | Write-Information
            $result = Invoke-Expression $command
        }
    }

    "End shuffling field values" | Write-MyVerbose -NewLine

} Export-ModuleMember -Function Update-FieldValueSingleSelectToProject