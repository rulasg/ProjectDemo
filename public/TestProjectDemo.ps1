function Test-ProjectDemo{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][PSCustomObject]$DemoEnv
    )

    "Testing Project Demo [{0}] for owner [{1}]" -f $demoEnv.name, $demoEnv.Owner | Write-Verbose

    # Test repos existance
    $r1 = $DemoEnv.RepoBackWithOwner | Test-Repo
    $r2 = $DemoEnv.RepoFrontWithOwner | Test-Repo
    $p1 = Test-Project -Owner $DemoEnv.Owner -Title $DemoEnv.Name

    if($r1){"Repo [ {0} ] exists" -f $DemoEnv.RepoBackWithOwner | Write-Verbose}
    if($r2){"Repo [ {0} ] exists" -f $DemoEnv.RepoFrontWithOwner | Write-Verbose}
    if($p1){"Project [{0}] exists" -f $DemoEnv.Name | Write-Verbose}

    $ret = $r1 -or $r2 -or $p1

    if($ret){"Found Project Demo componets. Return True on Test" | Write-Verbose}

    return $ret
} Export-ModuleMember -Function Test-ProjectDemo