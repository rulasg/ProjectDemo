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
    $repoUrl = New-RepoDemo -Repo $demoEnv.RepoFront -Name $demoEnv.Name -Owner $demoEnv.Owner
    $repoUrl

    $repoUrl = New-RepoDemo -Repo $demoEnv.RepoBack -Name $demoEnv.Name -Owner $demoEnv.Owner
    $repoUrl

    # Add issues to repos
    Add-IssuesToRepo -Owner $demoEnv.Owner -Repo $demoEnv.RepoFront -Amount $demoEnv.IssuesAmount
    Add-IssuesToRepo -Owner $demoEnv.Owner -Repo $demoEnv.RepoBack -Amount $demoEnv.IssuesAmount

    # Add milestones to repos

    Add-MilestonesToRepo -Repo $demoEnv.RepoFront -Owner $demoEnv.Owner
    Add-MilestonesToRepo -Repo $demoEnv.RepoBack -Owner $demoEnv.Owner
   

    Write-MyVerbose "Finish creating demo project" -NewLine

} Export-ModuleMember -Function New-ProjectDemo


function Add-MilestonesToRepo{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)][string]$Repo,
        [Parameter()][string]$Owner
    )

    $owner = Get-EnvironmentOwner -Owner $Owner

    "Ading Milestones to Repos" | Write-MyVerbose -NewLine

    $Q4FY2023 = Get-Date -Year 2023 -Month 12 -Day 31
    $Q1FY2024 = Get-Date -Year 2024 -Month 3 -Day 31
    $Q2FY2024 = Get-Date -Year 2024 -Month 6 -Day 30
    $Q3FY2024 = Get-Date -Year 2024 -Month 9 -Day 30
    $Q4FY2024 = Get-Date -Year 2024 -Month 12 -Day 31

    Add-MilestoneToRepo -Owner $Owner -Repo $Repo -Title "Q4 FY2023 $Repo" -Date $Q4FY2023 -Description "Q4FY2023 Milestone for $Repo" | Write-MyVerbose
    Add-MilestoneToRepo -Owner $Owner -Repo $Repo -Title "Q1 FY2024 $Repo" -Date $Q1FY2024 -Description "Q1FY2024 Milestone for $Repo" | Write-MyVerbose
    Add-MilestoneToRepo -Owner $Owner -Repo $Repo -Title "Q2 FY2024 $Repo" -Date $Q2FY2024 -Description "Q2FY2024 Milestone for $Repo" | Write-MyVerbose
    Add-MilestoneToRepo -Owner $Owner -Repo $Repo -Title "Q3 FY2024 $Repo" -Date $Q3FY2024 -Description "Q3FY2024 Milestone for $Repo" | Write-MyVerbose
    Add-MilestoneToRepo -Owner $Owner -Repo $Repo -Title "Q4 FY2024 $Repo" -Date $Q4FY2024 -Description "Q4FY2024 Milestone for $Repo" | Write-MyVerbose

    "End creating milestones on projects" | Write-MyVerbose -NewLine
} Export-ModuleMember -Function Add-MilestonesToRepo