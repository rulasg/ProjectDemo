function Get-ProjectDemo{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string]$Name,
        [Parameter(Mandatory)] [string]$Owner
    )
    
    $demoEnv = Get-Environment -Name $Name -Owner $Owner
    
    $ret =@{

    }

    "Get Project Demo [{0}] for owner [{1}]" -f $demoEnv.name, $demoEnv.Owner | Write-Verbose

    $repoFrontVar = "[{0}]" -f $demoEnv.RepoFrontWithOwner
    $repoBackVar  = "[{0}]" -f $demoEnv.RepoBackWithOwner
    $projectVar   = "[{0}]" -f $demoEnv.Name

    # Test repos existance
    $ret.$repoFrontVar  = $DemoEnv.RepoBackWithOwner | Test-Repo
    $ret.$repoBackVar  = $DemoEnv.RepoFrontWithOwner | Test-Repo
    $ret.$projectVar = Test-Project -Owner $DemoEnv.Owner -Title $DemoEnv.Name

    return $ret
}

