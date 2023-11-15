function New-Repo{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,Position=0,ValueFromPipeline)][string]$RepoWithOwner,
        [Parameter(Mandatory,Position=1)][string]$RepoTopic,
        [Parameter(Mandatory,Position=1)][string]$FixedTopic
    )

    process {
        "Creating repo [$RepoWithOwner] with topic [$RepoTopic]" | Write-Verbose

        $commad = 'gh repo create {repowithowner} --add-readme --public --description "Repo part of Project Demo"'
        $commad = $commad -replace "{repowithowner}",$RepoWithOwner

        $commad | Write-Verbose

        $result = Invoke-Expression $commad

        $result

        Add-TopicToRepo -RepoWithOwner $RepoWithOwner -Topic $RepoTopic
        Add-TopicToRepo -RepoWithOwner $RepoWithOwner -Topic $FixedTopic

    }
} Export-ModuleMember -Function New-Repo

function Add-TopicToRepo{
    [CmdletBinding()]
    param(
        [Parameter(Position=0,ValueFromPipeline)][string]$RepoWithOwner,
        [Parameter(Position=1)][string]$Topic
    )

    "Adding topic [$Topic] to repo [$RepoWithOwner]" | Write-Verbose

    # add topic for easy find
    $command = 'gh repo edit {repowithowner} --add-topic "{topic}"'
    $command = $command -replace "{repowithowner}",$RepoWithOwner
    $command = $command -replace "{topic}",$Topic
    $command | Write-Verbose

    $result = Invoke-Expression $command

    $result
}
function Add-IssueToRepo{
    param(
        [Parameter(Mandatory)][string]$Repo,
        [Parameter(Mandatory)][string]$Owner,
        [Parameter(Position=0,ValueFromPipeline)][string]$RepoWithOwner,
        [Parameter(Position=1)][int]$Amount
    )

    $owner = Get-EnvironmentOwner -Owner $Owner
    $repoWithOwner = "{0}/{1}" -f $owner,$Repo

    if(-not (Test-Repo -RepoWithOwner $repoWithOwner)){
        Write-Error "Repo [$repoWithOwner] does not exist. Can not add issues"
        return
    }

    # Add issues to repo
    1..$Amount | ForEach-Object{
        # 1..1 | ForEach-Object{
            $randomId = (New-Guid).Guid.Substring(0,8)
            
            "$_. Creating Issue $($randomId) for repo [$repoWithOwner]" | Write-MyVerbose

            "[New-Repo] gh issue create --title `"Issue $($randomId)`"  --body `"Series $_ of demo issues for the Front repo`" -R $repoFulName" | Write-Verbose
            $result = gh issue create --title "Issue $($randomId)"  --body "Series $_ of demo issues for the Front repo" -R $repoWithOwner
            $result | Write-Verbose
    }

} Export-ModuleMember -Function Add-IssueToRepo