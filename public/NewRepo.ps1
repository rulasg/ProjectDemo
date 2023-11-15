function New-RepoDemo{
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName)][string]$Name,
        [Parameter(ValueFromPipelineByPropertyName)][string]$Owner,
        [Parameter(Mandatory)][string]$Repo
    )

    process {

        $env = Get-Environment -Name $Name -Owner $Owner
        $repoWithOwner = "{0}/{1}" -f $env.Owner,$Repo

        "Creating repo [$repoWithOwner] with topic [$RepoTopic]" | Write-Verbose

        $commad = 'gh repo create {repowithowner} --add-readme --public --description "Repo part of Project Demo"'
        $commad = $commad -replace "{repowithowner}",$repoWithOwner

        $commad | Write-Verbose

        $result = Invoke-Expression $commad

        $result

        Add-TopicToRepo -RepoWithOwner $repoWithOwner -Topic $env.FixedTopic
        Add-TopicToRepo -RepoWithOwner $repoWithOwner -Topic $env.RepoTopic

    }
} Export-ModuleMember -Function New-RepoDemo

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
function Add-IssuesToRepo{
    param(
        [Parameter(Mandatory)][string]$Repo,
        [Parameter()][string]$Owner,
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

            "[New-RepoDemo] gh issue create --title `"Issue $($randomId)`"  --body `"Series $_ of demo issues for the Front repo`" -R $repoFulName" | Write-Verbose
            $result = gh issue create --title "Issue $($randomId)"  --body "Series $_ of demo issues for the Front repo" -R $repoWithOwner
            $result | Write-MyVerbose
    }

    "End ading issues to repo [$repoWithOwner]" | Write-MyVerbose -NewLine

} Export-ModuleMember -Function Add-IssuesToRepo