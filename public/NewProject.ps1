function New-Project{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string]$Title,
        [Parameter()] [string]$Owner,
        [Parameter(Mandatory)] [string]$Description
    )

    $command = 'gh project create --owner {owner} --title {title} --format json'
    $command = $command -replace '{owner}',$Owner
    $command = $command -replace '{title}',$Title

    $resultJson = Invoke-Expression $command

    $resultJson | Write-Verbose

    $result = $resultJson | ConvertFrom-Json

    if(-Not $($result.number)){
        Write-Error "Error creating project [$Title] in [$Owner]"
        return
    }

    $number = $result.number
    $url = $result.Url

    $command | Write-Verbose
    
    $comand = 'gh project edit {projectnumber} --owner {owner} --visibility PUBLIC --readme "{readme}" --description "{description}"'
    $comand = $comand -replace '{projectnumber}',$number
    $comand = $comand -replace '{owner}',$Owner
    $comand = $comand -replace '{readme}',"README Demostrate how to use projects"
    $comand = $comand -replace '{description}',$Description

    $result = Invoke-Expression $comand

    return $url

} Export-ModuleMember -Function New-Project

