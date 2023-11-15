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
    Add-IssueToRepo -Owner $demoEnv.Owner -Repo $demoEnv.RepoFront -Amount $demoEnv.IssuesAmount
    Add-IssueToRepo -Owner $demoEnv.Owner -Repo $demoEnv.RepoBack -Amount $demoEnv.IssuesAmount

    # Add milestones to repos
    "Ading Milestones to Repos" | Write-MyVerbose -NewLine

    $Q4FY2023 = Get-Date -Year 2023 -Month 12 -Day 31
    $Q1FY2024 = Get-Date -Year 2024 -Month 3 -Day 31
    $Q2FY2024 = Get-Date -Year 2024 -Month 6 -Day 30
    $Q3FY2024 = Get-Date -Year 2024 -Month 9 -Day 30
    $Q4FY2024 = Get-Date -Year 2024 -Month 12 -Day 31

    Add-MilestoneToRepo -Owner $demoEnv.Owner -Repo $demoEnv.RepoFront -Title "Q4 FY2023 Front" -Date $Q4FY2023 -Description "Q4FY2023 Front Milestone" | Write-MyVerbose
    Add-MilestoneToRepo -Owner $demoEnv.Owner -Repo $demoEnv.RepoFront -Title "Q1 FY2024 Front" -Date $Q1FY2024 -Description "Q1FY2024 Front Milestone" | Write-MyVerbose
    Add-MilestoneToRepo -Owner $demoEnv.Owner -Repo $demoEnv.RepoFront -Title "Q2 FY2024 Front" -Date $Q2FY2024 -Description "Q2FY2024 Front Milestone" | Write-MyVerbose
    Add-MilestoneToRepo -Owner $demoEnv.Owner -Repo $demoEnv.RepoFront -Title "Q3 FY2024 Front" -Date $Q3FY2024 -Description "Q3FY2024 Front Milestone" | Write-MyVerbose
    Add-MilestoneToRepo -Owner $demoEnv.Owner -Repo $demoEnv.RepoFront -Title "Q4 FY2024 Front" -Date $Q4FY2024 -Description "Q4FY2024 Front Milestone" | Write-MyVerbose
    Add-MilestoneToRepo -Owner $demoEnv.Owner -Repo $demoEnv.RepoBack -Title "Q4 FY2023 Back" -Date $Q4FY2023 -Description "Q4FY2023 Back Milestone" | Write-MyVerbose
    Add-MilestoneToRepo -Owner $demoEnv.Owner -Repo $demoEnv.RepoBack -Title "Q1 FY2024 Back" -Date $Q1FY2024 -Description "Q1FY2024 Back Milestone" | Write-MyVerbose
    Add-MilestoneToRepo -Owner $demoEnv.Owner -Repo $demoEnv.RepoBack -Title "Q2 FY2024 Back" -Date $Q2FY2024 -Description "Q2FY2024 Back Milestone" | Write-MyVerbose
    Add-MilestoneToRepo -Owner $demoEnv.Owner -Repo $demoEnv.RepoBack -Title "Q3 FY2024 Back" -Date $Q3FY2024 -Description "Q3FY2024 Back Milestone" | Write-MyVerbose
    Add-MilestoneToRepo -Owner $demoEnv.Owner -Repo $demoEnv.RepoBack -Title "Q4 FY2024 Back" -Date $Q4FY2024 -Description "Q4FY2024 Back Milestone" | Write-MyVerbose

    Write-MyVerbose "Finish creating demo project" -NewLine

} Export-ModuleMember -Function New-ProjectDemo
