function Get-ProjectDemo{
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName)] [string]$Name,
        [Parameter(ValueFromPipelineByPropertyName)] [string]$Owner
    )

    process {

        $demoEnv = Get-Environment -Name $Name -Owner $Owner
        
        $ret =@{}
        
        "Get Project Demo [{0}] for owner [{1}]" -f $demoEnv.name, $demoEnv.Owner | Write-Verbose

        $repo1 = [PSCustomObject]@{
            ProjectDemo = $demoEnv.Name
            Item = "Repo1"
            Name = $demoEnv.RepoFrontWithOwner
            Test = $DemoEnv.RepoFrontWithOwner | Test-Repo
        }

        $repo1

        $repo2 = [PSCustomObject]@{
            ProjectDemo = $demoEnv.Name
            Item = "Repo2"
            Name = $demoEnv.RepoBackWithOwner
            Test = $DemoEnv.RepoBackWithOwner | Test-Repo
        }

        $repo2

        $project = [PSCustomObject]@{
            ProjectDemo = $demoEnv.Name
            Item = "Project"
            Name = $demoEnv.Name
            Test = Test-Project -Owner $DemoEnv.Owner -Title $DemoEnv.Name
        }

        $project
    }

} Export-ModuleMember -Function Get-ProjectDemo

