function Set-ProjectDemo{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter()] [string]$Name,
        [Parameter()] [string]$Owner
    )

    $env = Get-Environment -Name $Name -Owner $Owner
    $name = $env.Name
    $owner = $env.Owner
    
    New-ProjectDemo     -name $name  -Owner $owner
    
    Add-ItemsToProject  -name $name  -Owner $owner

    $projectNumber = Get-ProjectNumber -Name $name -Owner $owner
    
    Update-FieldValueWithSingleSelect    -ProjectNumber $projectNumber -owner $owner -FieldName "Status"

    Add-WellknownFieldsToProject            -ProjectNumber $projectNumber -owner $owner

} Export-ModuleMember -Function Set-ProjectDemo