function Test-ProjectDemo{
    [CmdletBinding()]
    param(
        [Parameter()][PSCustomObject]$DemoEnv,
        [Parameter()] [string]$Name,
        [Parameter()] [string]$Owner
    )

    # check for valir $DemoEnv
    if(-not $DemoEnv){
       $DemoEnv = Get-Environment -Name $Name -Owner $Owner
    } else {
        $DemoEnv = Get-Environment -Name Name -Owner $Owner
    }

    "Testing Project Demo [{0}] for owner [{1}]" -f $demoEnv.name, $demoEnv.Owner | Write-MyVerbose

    # Test repos existance
    $r1 = $DemoEnv.RepoBackWithOwner | Test-Repo
    $r2 = $DemoEnv.RepoFrontWithOwner | Test-Repo
    $p1 = Test-Project -Owner $DemoEnv.Owner -Title $DemoEnv.Name

    if($r1){"Repo [ {0} ] exists" -f $DemoEnv.RepoBackWithOwner | Write-MyVerbose}
    if($r2){"Repo [ {0} ] exists" -f $DemoEnv.RepoFrontWithOwner | Write-MyVerbose}
    if($p1){"Project [{0}] exists" -f $DemoEnv.Name | Write-MyVerbose}

    $ret = $r1 -or $r2 -or $p1

    if($ret){
        "Found Project Demo componets. Return True on Test" | Write-MyVerbose -NewLine
    } else {
        "Project Demo componets not found. Return False on Test" | Write-MyVerbose -NewLine
    }

    return $ret
} Export-ModuleMember -Function Test-ProjectDemo