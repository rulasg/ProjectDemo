function New-Repo{
    [CmdletBinding()]
    param(
        [Parameter(Position=0,ValueFromPipeline)][string]$RepoWithOwner,
        [Parameter(Position=1)][string]$Topic
    )

    process {
        "Creating repo [$RepoWithOwner] with topic [$Topic]" | Write-Verbose
        
        # create repo
        "[New-Repo] gh repo create $RepoWithOwner --add-readme --public --description `"Repo fart of Project Demo`"" | Write-Verbose
        gh repo create $RepoWithOwner --add-readme --public --description "Repo fart of Project Demo"
        
        # add topic for easy find
        "[New-Repo] gh repo edit $RepoWithOwner --add-topic $topic" | Write-Verbose
        gh repo edit $RepoWithOwner --add-topic $topic
    }
} Export-ModuleMember -Function New-Repo

function Add-IssueToRepo{
    param(
        [Parameter(Position=0,ValueFromPipeline)][string]$RepoWithOwner,
        [Parameter(Position=1)][int]$Amount
    )

    if(-not (Test-Repo -RepoWithOwner $RepoWithOwner)){
        Write-Error "Repo [$RepoWithOwner] does not exist. Can not add issues"
        return
    }

    # Add issues to repo
    1..$Amount | ForEach-Object{
        # 1..1 | ForEach-Object{
            $randomId = (New-Guid).Guid.Substring(0,8)
            "$_. Creating Issue $($randomId) for repo [$RepoWithOwner]" | Write-Host
            "[New-Repo] gh issue create --title `"Issue $($randomId)`"  --body `"Series $_ of demo issues for the Front repo`" -R $repoFulName" | Write-Verbose
            $result = gh issue create --title "Issue $($randomId)"  --body "Series $_ of demo issues for the Front repo" -R $RepoWithOwner
            $result | Write-Verbose
    }
} Export-ModuleMember -Function Add-IssueToRepo