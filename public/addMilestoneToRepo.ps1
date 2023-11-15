function Add-MilestoneToRepo{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)] [string]$Repo,
        [Parameter(Mandatory)] [string]$Title,
        [Parameter()] [string]$Owner,
        [Parameter()] [string]$Description,
        [Parameter()] [string]$Date
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
        
        $date | Write-Verbose
        $datedate = Get-Date -Date $Date -ErrorAction SilentlyContinue
        $datedate | Write-Verbose

        if ($datedate) {
            # Format date
            $justDate = $datedate.Date
            $dateString = Get-Date -Date $justDate -UFormat "%Y-%m-%dT%H:%M:%SZ"
            $command = $command + ' -f due_on="{date}"'
            $command = $command -replace "{date}", $dateString
        } else {
            Write-Error "Invalid date format. Please provide a valid date string."
        }
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
