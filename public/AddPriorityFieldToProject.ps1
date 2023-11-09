function Add-PriorityFieldToProject{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)] [string]$ProjectNumber,
        [Parameter(Mandatory)] [string]$Owner
    )

    $fieldName = "Priority"
    
    # Create a SingleSeect field
    "Adding field [$fieldName] to project [$ProjectNumber]" | Write-Verbose
    $command = 'gh project field-create {projectnumber} --owner {owner} --name {fieldname} --data-type "SINGLE_SELECT" --single-select-options {options}'
    $command = $command -replace "{projectnumber}", $ProjectNumber
    $command = $command -replace "{owner}", $Owner
    $command = $command -replace "{fieldname}", $fieldName
    $command = $command -replace "{options}", "Critical,High,Normal,Low"

    "Add $fieldName ot project $ProjectNumber" | Write-Host
    $command | Write-Information
    $result = Invoke-Expression $command

    ## Figure out the project ID
    "Figure out the project ID" | Write-Verbose
    "[Add-PriorityFieldToProject] gh project view $ProjectNumber --owner $Owner --format json" | Write-Verbose
    $projectId = gh project view $ProjectNumber --owner $Owner --format json | convertfrom-json | Select-Object -ExpandProperty id

    ## Figure out the field ID
    "FigureOut the field ID" | Write-Verbose
    # "[Add-PriorityFieldToProject] gh project field-list $ProjectNumber --owner $Owner --format json " | Write-Verbose
    # $fieldId = gh project field-list $ProjectNumber --owner $Owner --format json | ConvertFrom-Json | Select-Object -ExpandProperty fields | Where-Object {$_.name -eq "TimeTracker"} | Select-Object -ExpandProperty id

    #Figure out Field Options ID
    $comand = 'gh project field-list  {projectnumber} --format json --owner {owner}'
    $comand = $comand -replace "{projectnumber}", $ProjectNumber
    $comand = $comand -replace "{owner}", $Owner
    $result = Invoke-Expression $comand
    $fields = $result | ConvertFrom-Json | Select-Object -ExpandProperty fields
    $field = $fields | Where-Object {$_.name -eq $fieldname}
    $options = $field.options 

    $fieldId = $field | Select-Object -ExpandProperty id

    ## populate field to the project items
    "Populate field to the project items" | Write-Verbose
    $items = gh project item-list $ProjectNumber --owner $Owner --format json | ConvertFrom-Json | Select-Object -ExpandProperty items

    "Found [{0}] items to edit" -f $items.Count | Write-Verbose

    foreach($item in $items){
        $random = Get-Random -Minimum 0 -Maximum $($options.Count)

        $optionId = $options[$random].id

        $command = 'gh project item-edit --id {itemd} --field-id {fieldid} --project-id {projectid}  --single-select-option-id {optionid}'
        $command = $command -replace "{itemd}", $item.Id
        $command = $command -replace "{fieldid}", $fieldId
        $command = $command -replace "{projectid}", $projectId
        $command = $command -replace "{optionid}", $optionId
        
        "Updating item [{0}] with option [{1}]" -f $item.title, $options[$random].name | Write-Host

        if ($PSCmdlet.ShouldProcess($item.tittle, $command)) {
            $command | Write-Information
            $result = Invoke-Expression $command

        }
    }
} Export-ModuleMember -Function Add-PriorityFieldToProject