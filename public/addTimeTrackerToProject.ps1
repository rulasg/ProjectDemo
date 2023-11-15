function Add-TimeTrackerToProject{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string]$ProjectNumber,
        [Parameter(Mandatory)] [string]$Owner,
        [Parameter()] [string]$FieldName
    )

    # Check if fieldName null or whitespace, set to default if so
    if([string]::IsNullOrWhiteSpace($FieldName)){
        $FieldName = "TimeTracker"
    }

    # Create a number field
    "Adding field [$fieldName] to project [$ProjectNumber]" | Write-MyVerbose
    "[Add-TimeTrackerToProject] gh project field-create $ProjectNumber --owner $Owner  --name $fieldName --data-type NUMBER" | Write-MyVerbose
    gh project field-create $ProjectNumber --owner $Owner  --name $fieldName --data-type NUMBER

    ## Figure out the project ID
    "Figure out the project ID" | Write-MyVerbose
    "[Add-TimeTrackerToProject] gh project view $ProjectNumber --owner $Owner --format json" | Write-MyVerbose
    $projectId = gh project view $ProjectNumber --owner $Owner --format json | convertfrom-json | Select-Object -ExpandProperty id

    ## Figure out the field ID
    "FigureOut the field ID" | Write-MyVerbose
    "[Add-TimeTrackerToProject] gh project field-list $ProjectNumber --owner $Owner --format json " | Write-MyVerbose
    $fieldId = gh project field-list $ProjectNumber --owner $Owner --format json | ConvertFrom-Json | Select-Object -ExpandProperty fields | Where-Object {$_.name -eq "TimeTracker"} | Select-Object -ExpandProperty id

    ## Add TimeTrack to the project items
    "Add TimeTrack to the project items" | Write-MyVerbose
    $items = gh project item-list $ProjectNumber --owner $Owner --format json | ConvertFrom-Json | Select-Object -ExpandProperty items
    foreach($item in $items){
        $minutes = Get-Random -Minimum 10 -Maximum 500

        "[Add-TimeTrackerToProject] gh project item-edit --id $item.Id --field-id $fieldId --project-id $projectId --number $minutes" | Write-MyVerbose

        $result = gh project item-edit --id $item.Id --field-id $fieldId --project-id $projectId --number $minutes 

        $result | Write-MyVerbose
    }

    "End adding time tracker to project [$ProjectNumber]" | Write-MyVerbose -NewLine

} Export-ModuleMember -Function Add-TimeTrackerToProject