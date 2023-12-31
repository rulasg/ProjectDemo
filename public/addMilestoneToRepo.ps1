function Add-MilestoneToRepo{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)] [string]$Repo,
        [Parameter(Mandatory)] [string]$Title,
        [Parameter()] [string]$Owner,
        [Parameter()] [string]$Description,
        [Parameter()] [DateTime]$Date
    )

    $owner = Get-EnvironmentOwner -Owner $Owner

    # check if dates is valid

    $command =  'gh api repos/{owner}/{repo}/milestones -X POST -f title="{title}"' 
    $command = $command -replace "{owner}", $Owner
    $command = $command -replace "{repo}", $Repo
    $command = $command -replace "{title}", $Title

    if($Description){
        $command = $command + ' -f description="{description}"'
        $command = $command -replace "{description}", $Description
    }

    if ($Date) {

        # Format date
        $dateString = $Date.Date | ConvertTo-Json
        $command = $command + ' -f due_on="{date}"'
        $command = $command -replace "{date}", $dateString
    }

    $command | Write-Verbose

    if ($PSCmdlet.ShouldProcess("GitHub",$command)) {
        $resultJson = Invoke-Expression $command
        $result = $resultJson | ConvertFrom-Json
    } else {
        $command | Write-Information
    }

    return $result.html_url

} Export-ModuleMember -Function Add-MilestoneToRepo
