function Test-Repo{
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)][string]$RepoWithOwner
    )
    process{
        try{
            "Testing if repo [$RepoWithOwner] exists." | Write-Verbose
            "[Test-Repo] gh repo view $RepoWithOwner *>&1" | Write-Verbose

            gh repo view $RepoWithOwner *>&1 | Out-Null
            $ret =  $?

            $ret | Write-Verbose

            return $ret

        } catch {
            "Error testing repro [$RepoWithOwner]" | Write-Verbose
        }
    }
} Export-ModuleMember -Function Test-Repo