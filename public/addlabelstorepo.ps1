function Add-LabelToRepo{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)] [string]$Repo,
        [Parameter(Mandatory)] [string]$Name,
        [Parameter()] [string]$Owner,
        [Parameter()] [string]$Description,
        [Parameter()] [string]$Color
    )

    $Owner = Get-EnvironmentOwner -Owner $Owner

    $command = 'gh label create {name} -R {owner}/{repo} --force'
    $command = $command -replace "{name}", $Name
    $command = $command -replace "{owner}", $Owner
    $command = $command -replace "{repo}", $Repo

    
    if(-not[string]::IsNullOrWhiteSpace($Description)){
        $command = $command + ' --description "{description}"'
        $command = $command -replace "{description}", $Description
    }

    if(-not[string]::IsNullOrWhiteSpace($Color)){
        $command = $command + ' --color "{color}"'
        $command = $command -replace "{color}", $Color
    }

    $command | Write-MyVerbose

    $result = Invoke-Expression $command

    return $result
} Export-ModuleMember -Function Add-LabelToRepo

function Add-WellknownLabelsToRepos{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)][string]$Repo,
        [Parameter()][switch]$Update,
        [Parameter()][string]$Owner
    )

    $env = Get-EnvironmentOwner -Owner $Owner 

    $labels = @(
        @{name="epic";    description="Initiative big in size and impact";                       color="B60205"}
        @{name="feature"; description="Initiative part of an epic with relative entity";         color="D93F0B"}
        @{name="task";    description="small unit of work";                                      color="FBCA04"}
    )

    $labels | ForEach-Object{

        Add-LabelToRepo -Owner $Owner -Repo $Repo -Name $_.name -Description $_.description -Color $_.color
    }
    

    Add-LabelToRepo -Owner $Owner -Repo $Repo -N

} Export-ModuleMember -Function Add-WellknownLabelsToRepos