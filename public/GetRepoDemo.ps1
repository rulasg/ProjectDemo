function Get-RepoDemo{
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName)] [string]$Name,
        [Parameter(ValueFromPipelineByPropertyName)] [string]$Owner
    )

    process {

        $demoEnv = Get-Environment -Name $Name -Owner $Owner

        "Get Repo Demo [{0}] for owner [{1}]" -f $demoEnv.name, $demoEnv.Owner | Write-Verbose

        Get-RepoByTopic -Owner $demoEnv.Owner -Topic $demoEnv.RepoTopic

    }

} Export-ModuleMember -Function Get-RepoDemo

function Get-RepoDemoAll{
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName)] [string]$Owner
    )

    process {

        $demoEnv = Get-Environment -Name $Name -Owner $Owner

        "Get Repo Demo [{0}] for owner [{1}]" -f $demoEnv.name, $demoEnv.Owner | Write-Verbose

        Get-RepoByTopic -Owner $demoEnv.Owner -Topic $demoEnv.FixedTopic

    }

} Export-ModuleMember -Function Get-RepoDemoAll

function Get-RepoByTopic{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string]$Owner,
        [Parameter(Mandatory)] [string]$Topic
    )

    process {

        "Get Repo with topic [{0}] for owner [{1}]" -f $Topic, $Owner | Write-Verbose

        $command = 'gh repo list  {owner} --topic {topic} --json nameWithOwner'
        $command = $command -replace '{owner}', $Owner
        $command = $command -replace '{topic}', $Topic

        $resultjson = Invoke-Expression $command

        $result = $resultjson | ConvertFrom-Json | Select-Object -ExpandProperty nameWithOwner

        return $result

    }

} 