function Add-FieldSingleSelectToProject{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)][string]$ProjectNumber,
        [Parameter(Mandatory)][string]$FieldName,
        [Parameter(Mandatory)][string]$Options,
        [Parameter()][string]$Owner
    )

    $Owner = Get-EnvironmentOwner -Owner $Owner

    # Create a SingleSelect field
    "Adding field [$fieldName] to project [$ProjectNumber]" | Write-Verbose
    $command = 'gh project field-create {projectnumber} --owner {owner} --name {fieldname} --data-type "SINGLE_SELECT" --single-select-options {options}'
    $command = $command -replace "{projectnumber}", $ProjectNumber
    $command = $command -replace "{owner}", $Owner
    $command = $command -replace "{fieldname}", $fieldName
    $command = $command -replace "{options}", $Options

    "Add $fieldName to project $ProjectNumber" | Write-Host
    $command | Write-Information
    $result = Invoke-Expression $command

    $result

} Export-ModuleMember -Function Add-FieldSingleSelectToProject

function Add-FieldNumber{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, Position=0)][string]$ProjectNumber,
        [Parameter(Mandatory, Position=1)][string]$FieldName,
        [Parameter()][string]$Owner
    )

    $Owner = Get-EnvironmentOwner -Owner $Owner

    # Create a SingleSelect field
    "Adding field [$fieldName] to project [$ProjectNumber]" | Write-Verbose
    $command = 'gh project field-create {projectnumber} --owner {owner} --name {fieldname} --data-type NUMBER'
    $command = $command -replace "{projectnumber}", $ProjectNumber
    $command = $command -replace "{owner}", $Owner
    $command = $command -replace "{fieldname}", $fieldName

    "Add $fieldName to project $ProjectNumber" | Write-Host
    $command | Write-Information
    $result = Invoke-Expression $command

    $result

} Export-ModuleMember -Function Add-FieldNumber

function Add-FieldText{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, Position=0)][string]$ProjectNumber,
        [Parameter(Mandatory, Position=1)][string]$FieldName,
        [Parameter()][string]$Owner
    )

    $Owner = Get-EnvironmentOwner -Owner $Owner

    # Create a SingleSelect field
    "Adding field [$fieldName] to project [$ProjectNumber]" | Write-Verbose
    $command = 'gh project field-create {projectnumber} --owner {owner} --name {fieldname} --data-type TEXT'
    $command = $command -replace "{projectnumber}", $ProjectNumber
    $command = $command -replace "{owner}", $Owner
    $command = $command -replace "{fieldname}", $fieldName

    "Add $fieldName to project $ProjectNumber" | Write-Host
    $command | Write-Information
    $result = Invoke-Expression $command

    $result

} Export-ModuleMember -Function Add-FieldText

function Add-FieldDate{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, Position=0)][string]$ProjectNumber,
        [Parameter(Mandatory, Position=1)][string]$FieldName,
        [Parameter()][string]$Owner
    )

    $Owner = Get-EnvironmentOwner -Owner $Owner

    # Create a SingleSelect field
    "Adding field [$fieldName] to project [$ProjectNumber]" | Write-Verbose
    $command = 'gh project field-create {projectnumber} --owner {owner} --name {fieldname} --data-type DATE'
    $command = $command -replace "{projectnumber}", $ProjectNumber
    $command = $command -replace "{owner}", $Owner
    $command = $command -replace "{fieldname}", $fieldName

    "Add $fieldName to project $ProjectNumber" | Write-Host
    $command | Write-Information
    $result = Invoke-Expression $command

    $result

} Export-ModuleMember -Function Add-FieldDate