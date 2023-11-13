function Add-FieldSingleSelectToProject{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter()][string]$Owner,
        [Parameter(Mandatory)][string]$ProjectNumber,
        [Parameter(Mandatory)][string]$FieldName,
        [Parameter(Mandatory)][string]$Options
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