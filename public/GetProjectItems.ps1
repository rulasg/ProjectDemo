function Get-ProjectItems{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,Position=0)][string]$ProjectNumber,
        [Parameter()][string]$Owner
    )

    $Owner = Get-EnvironmentOwner -Owner $Owner

    ## populate field to the project items
    $command = 'gh project item-list {projectnumber} --owner {owner} --format json -L 1000'
    $command = $command -replace "{projectnumber}", $ProjectNumber
    $command = $command -replace "{owner}", $Owner
    $command | Write-Verbose
    $resultJson = Invoke-Expression $command
    $result = $resultJson | ConvertFrom-Json 
    $items = $result | Select-Object -ExpandProperty items

    return $items
} Export-ModuleMember -Function Get-ProjectItems

