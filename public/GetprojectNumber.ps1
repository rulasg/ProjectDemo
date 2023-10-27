function Get-ProjectNumber{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string]$Name,
        [Parameter(Mandatory)] [string]$Owner
    )
    "[Get-ProjectNumber] Getting project number for project [$Name] in [$Owner]" | Write-Verbose

    "[Get-ProjectNumber] gh project list --owner $Owner --format json -L 1000" | Write-Verbose
    $projectList = gh project list --owner $Owner --format json -L 1000 | ConvertFrom-Json | Select-Object -ExpandProperty projects
    
    if($projectList.Count -eq 0){
        "[Get-ProjectNumber] No project found in [$Owner]" | Write-Verbose
        return -1
    } else {
        "[Get-ProjectNumber] Found {0} projects" -f $projectList.Count | Write-Verbose
    }

    "[Get-ProjectNumber] Filtering projectList by name [$Name]" | Write-Verbose
    $project = $projectList | Where-Object{$_.title -eq $Name}

    if($project){
        "[Get-ProjectNumber] Found project [$($project.title)] with number [$($project.number)]" | Write-Verbose
        $ret = $project.number
    } else {
        "[Get-ProjectNumber] No project found with name [$Name] in [$Owner]" | Write-Verbose
        $ret = -1
    }

    return $ret
} Export-ModuleMember -Function Get-ProjectNumber