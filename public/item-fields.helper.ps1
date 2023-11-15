function Get-ProjectId {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,Position=0)][string]$ProjectNumber,
        [Parameter()][string]$Owner
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

    return $projectId
} Export-ModuleMember -Function Get-ProjectId

function Get-Field{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,Position=0)][string]$ProjectNumber,
        [Parameter(Mandatory,Position=1)][string]$FieldName,
        [Parameter()][string]$Owner
    )

    $Owner = Get-EnvironmentOwner -Owner $Owner

    ## Figure out the field ID
    "FigureOut the field ID" | Write-Verbose
    $comand = 'gh project field-list  {projectnumber} --format json --owner {owner}'
    $comand = $comand -replace "{projectnumber}", $ProjectNumber
    $comand = $comand -replace "{owner}", $Owner
    $resultJson = Invoke-Expression $comand
    $result = $resultJson | ConvertFrom-Json
    $fields = $result | Select-Object -ExpandProperty fields
    $field = $fields | Where-Object {$_.name -eq $fieldname}

    return $field
} Export-ModuleMember -Function Get-Field

function Get-FieldId{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,Position=0)][string]$ProjectNumber,
        [Parameter(Mandatory,Position=1)][string]$FieldName,
        [Parameter()][string]$Owner
    )

    $Owner = Get-EnvironmentOwner -Owner $Owner

    $field = Get-Field -Owner $Owner -ProjectNumber $ProjectNumber -FieldName $FieldName

    return $field.Id
} Export-ModuleMember -Function Get-FieldId