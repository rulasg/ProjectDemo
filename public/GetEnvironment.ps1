function Get-Environment{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string]$Name,
        [Parameter()] [string]$Owner
    )

    $DefaultOwner = "SolidifyDemo"

    $repoFront = "$Name-repo-front"
    $repoBack = "$Name-repo-back"

    # Default owner 
    if([string]::IsNullOrWhiteSpace($Owner)){
        $Owner = $DefaultOwner
    }

    $env = [PSCustomObject]@{
        Name = $Name
        Owner = $Owner
        DefaultOwner = $DefaultOwner
        Topic = "projectdemo-" + $Name
        DefaultTopic = "projectdemo"
        RepoFront = $repoFront
        RepoBack = $repoBack
        RepoFrontWithOwner = '{0}/{1}' -f $Owner, $repoFront
        RepoBackWithOwner = '{0}/{1}' -f $Owner, $repoBack
        IssuesAmount = 5
    }
    return $env
} Export-ModuleMember -Function Get-Environment