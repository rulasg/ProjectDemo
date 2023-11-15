function Add-ItemsToProject{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter()] [string]$Name,
        [Parameter()] [string]$Owner
    )

    $e = Get-Environment -Name $Name -Owner $Owner

    $number = Get-ProjectNumber -name $e.Name -Owner $e.Owner

    # Get all issues
    Add-ItemsToProjectFromARepo -ProjectNumber $number -Owner $e.Owner -RepoNameWithOwner $e.RepoFrontWithOwner
    Add-ItemsToProjectFromARepo -ProjectNumber $number -Owner $e.Owner -RepoNameWithOwner $e.RepoBackWithOwner
} Export-ModuleMember -Function Add-ItemsToProject

function Add-ItemsToProjectFromARepo{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter()][string]$Owner,
        [Parameter(Mandatory)][string]$ProjectNumber,
        [Parameter(Mandatory)][string]$Repo
    )

    $verbose = $VerbosePreference -eq 'Continue'

    $owner = Get-EnvironmentOwner -Owner $Owner
    $repoNameWithOwner = "{0}/{1}" -f $owner,$Repo

    "Adding issues from [{0}] to project [{1}] with owner [{2}]" -f $repoNameWithOwner, $ProjectNumber, $Owner | Write-Verbose

    # Get all issues
    $command = 'gh issue list -R {repoWithOwner} --json url '
    $command = $command -replace "{repoWithOwner}", $repoNameWithOwner

    $command | Write-Information
    $result = Invoke-Expression $command 

    if(-not $result){
        Write-Error "Error getting issues from [$repoNameWithOwner]"
        return
    }

    $url = $result | ConvertFrom-Json | Select-Object -ExpandProperty url 

    "Found [{0} issues in repo]" -f $url.Count | Write-Verbose

    # Add all issues to the project
    $url | foreach-object {

        ## check if VerbosePreference is set to silence
        if($verbose){
            "Adding issue [{0}] to project [{1}] with owner [{2}]" -f $_, $ProjectNumber, $Owner | Write-Verbose
        } else {
            Write-Host '.' -NoNewline
        }

        $commmand = 'gh project item-add {number} --owner {owner} --url {url}'
        $commmand = $commmand -replace "{number}", $ProjectNumber
        $commmand = $commmand -replace "{owner}", $Owner
        $commmand = $commmand -replace "{url}", $_

        if ($PSCmdlet.ShouldProcess($RepoNameWithOwner, $command)) {
            $commmand | Write-Information
            $result = Invoke-Expression $commmand
            
        }

        return $result
    }

    if(!$verbose){
        Write-Host
    }

} Export-ModuleMember -Function Add-ItemsToProjectFromARepo