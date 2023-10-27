function New-Project{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string]$Name,
        [Parameter()] [string]$Owner
    )

    # create project
    "Creating project [$Name] in [$Owner]" | Write-Verbose
    "[New-Project] gh project create --owner $Owner --title $Name --format json" | Write-Verbose
    $resultJson = gh project create --owner $Owner --title $Name --format json
    $resultJson | Write-Verbose

    $result = $resultJson | ConvertFrom-Json

    if(-Not $($result.number)){
        Write-Error "Error creating project [$Name] in [$Owner]"
        return
    }

    $number = $result.number

    # Edit project about
    "[New-Project] gh project edit $number --owner $Owner --visibility PUBLIC --readme `"README Demostrate how to use projects`" --description `"Demostrate how to use projects`"" | Write-Verbose
    $result = gh project edit $number --owner $Owner --visibility PUBLIC --readme "README Demostrate how to use projects" --description "Demostrate how to use projects"
    $result | Write-Verbose

    return $number
} Export-ModuleMember -Function New-Project

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
    "Adding field [$fieldName] to project [$ProjectNumber]" | Write-Verbose
    "[Add-TimeTrackerToProject] gh project field-create $ProjectNumber --owner $Owner  --name $fieldName --data-type NUMBER" | Write-Verbose
    gh project field-create $ProjectNumber --owner $Owner  --name $fieldName --data-type NUMBER

    ## Figure out the project ID
    "Figure out the project ID" | Write-Verbose
    "[Add-TimeTrackerToProject] gh project view $ProjectNumber --owner $Owner --format json" | Write-Verbose
    $projectId = gh project view $ProjectNumber --owner $Owner --format json | convertfrom-json | Select-Object -ExpandProperty id

    ## Figure out the field ID
    "FigureOut the field ID" | Write-Verbose
    "[Add-TimeTrackerToProject] gh project field-list $ProjectNumber --owner $Owner --format json " | Write-Verbose
    $fieldId = gh project field-list $ProjectNumber --owner $Owner --format json | ConvertFrom-Json | Select-Object -ExpandProperty fields | Where-Object {$_.name -eq "TimeTracker"} | Select-Object -ExpandProperty id

    ## Add TimeTrack to the project items
    "Add TimeTrack to the project items" | Write-Verbose
    $items = gh project item-list $ProjectNumber --owner $Owner --format json | ConvertFrom-Json | Select-Object -ExpandProperty items
    foreach($item in $items){
        $minutes = Get-Random -Minimum 10 -Maximum 500
        "[Add-TimeTrackerToProject] gh project item-edit --id $item.Id --field-id $fieldId --project-id $projectId --number $minutes" | Write-Verbose
        gh project item-edit --id $item.Id --field-id $fieldId --project-id $projectId --number $minutes 
    }
} Export-ModuleMember -Function Add-TimeTrackerToProject