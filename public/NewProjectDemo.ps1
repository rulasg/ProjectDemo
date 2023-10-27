function New-ProjectDemo{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)] [string]$Name,
        [Parameter()] [string]$Owner
    )

    $demoEnv = Get-Environment -Name $Name -Owner $Owner

    "Creating Demo Project with configuration: " | Write-Verbose
    $demoEnv | Format-List | Out-String | Write-Verbose

    if(Test-ProjectDemo -DemoEnv $demoEnv){
        Write-Host "Demo [ $Name ] already exists or any of it´s components."
        Write-Host "User Remove-ProjectDemo to remove previouse demo and try again."
        Write-Host "Run New-ProjectDemo with -Verbose switch for more information"
        return
    }

    # Create repos
    New-Repo -RepoWithOwner $demoEnv.RepoFrontWithOwner -Topic $demoEnv.Topic
    New-Repo -RepoWithOwner $demoEnv.RepoBackWithOwner -Topic $demoEnv.Topic

    # Add issues to repos
    Add-IssueToRepo -RepoWithOwner $demoEnv.RepoFrontWithOwner -Amount $demoEnv.IssuesAmount
    Add-IssueToRepo -RepoWithOwner $demoEnv.RepoBackWithOwner -Amount $demoEnv.IssuesAmount

    # Create Project
    $projectNumber = New-Project -Name $demoEnv.Name -Owner $demoEnv.Owner
    Write-Host "Project [$($demoEnv.Name)] created on Owner [$owner] with number [$projectNumber]"

    # Get URL to return it
    "[New-ProjectDemo] gh project view $projectNumber --owner $($demoEnv.owner) --format json" | Write-Verbose
    $Url = gh project view $projectNumber --owner $($demoEnv.owner) --format json | convertfrom-json | Select-Object -ExpandProperty  url

    return $Url
} Export-ModuleMember -Function New-ProjectDemo
