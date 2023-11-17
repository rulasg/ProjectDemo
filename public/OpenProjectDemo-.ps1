function Open-ProjectDemo{
    [CmdletBinding()]
    param(
        [Parameter()] [string]$Name,
        [Parameter()] [string]$Owner
    )

    $env = Get-Environment -Name $Name -Owner $Owner

    Find-ProjectDemo -Owner $env.Owner | Where-Object {$_.name -eq $env.Name} | Open-Url

    Find-RepoDemo -Name $env.Name -Owner $env.Owner | Open-Url

} Export-ModuleMember -Function Open-ProjectDemo
