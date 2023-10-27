function Remove-ReposByTopic{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)] [string]$Topic,
        [Parameter(Mandatory)] [string]$Owner
    )

    # Delete repo
    "Findings demo repos with Topic [$topic] in [$Owner]" | Write-Verbose

    $repolist = gh repo list $Owner --topic $topic --json nameWithOwner | ConvertFrom-Json | Select-Object -ExpandProperty nameWithOwner

    "Found {0} repos with Topic [$topic]" -f $repolist.Count | Write-Verbose
    $ret = @()
    $repolist | ForEach-Object{
        $ret += $_
        if ($PSCmdlet.ShouldProcess("Remo Repo", "gh repo delete $_ --yes")) {
            "[Remove-ReposByTopic] gh repo delete $_ --yes" | Write-Verbose
            gh repo delete $_ --yes
            "Deleted repo [$_]" | Write-Host
        }
    }

    if($ret.Count -eq 0){
        "No repo found with topics [$topic]" | Write-Host
    }

    return $ret
} Export-ModuleMember -Function Remove-ReposByTopic