function Open-ProjectDemo{
    [CmdletBinding()]
    param(
        [Parameter()] [string]$Name,
        [Parameter()] [string]$Owner,
        [Parameter()] [switch]$Repos
    )

    $env = Get-Environment -Name $Name -Owner $Owner

    Find-ProjectDemo -Owner $env.Owner | Where-Object {$_.name -eq $env.Name} | Open-Url

    if ($Repos) {
        Find-RepoDemo -Name $env.Name -Owner $env.Owner | Open-Url
    }

} Export-ModuleMember -Function Open-ProjectDemo
