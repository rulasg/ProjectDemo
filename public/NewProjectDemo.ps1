function New-ProjectDemo{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter()] [string]$Name,
        [Parameter()] [string]$Owner
    )

    $user = Get-User

    $demoEnv = Get-Environment -Name $Name -Owner $Owner -User $user

    "Creating Demo Project with configuration: " | Write-Verbose
    $demoEnv | Format-List | Out-String | Write-Verbose

    if(Test-ProjectDemo -DemoEnv $demoEnv){
        Write-Host "Demo [ $Name ] already exists or any of it's components."
        Write-Host "Use Get-ProjectDemo to get more information about the project demo."
        Write-Host "User Remove-ProjectDemo to remove previouse demo and try again."
        Write-Host "Run New-ProjectDemo with -Verbose switch for more information"
        return
    }

    # Create Project
    $url = New-Project -Title $demoEnv.Name -Owner $demoEnv.Owner -Description $demoEnv.ProjectDescriptionWithOwner
    $url

    # Create repos
    $repoUrl = New-Repo -RepoWithOwner $demoEnv.RepoFrontWithOwner -RepoTopic $demoEnv.RepoTopic -FixedTopic $demoEnv.FixedTopic
    $repoUrl

    $repoUrl = New-Repo -RepoWithOwner $demoEnv.RepoBackWithOwner -RepoTopic $demoEnv.RepoTopic -FixedTopic $demoEnv.FixedTopic
    $repoUrl

    # Add issues to repos
    Add-IssueToRepo -RepoWithOwner $demoEnv.RepoFrontWithOwner -Amount $demoEnv.IssuesAmount
    Add-IssueToRepo -RepoWithOwner $demoEnv.RepoBackWithOwner -Amount $demoEnv.IssuesAmount

} Export-ModuleMember -Function New-ProjectDemo
