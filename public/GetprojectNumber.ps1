function Get-ProjectNumber{
    [CmdletBinding()]
    param(
        [Parameter()] [string]$Name,
        [Parameter()] [string]$Owner
    )

    $Name = Get-EnvironmentName -Name $Name
    $Owner = Get-EnvironmentOwner -Owner $Owner

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

    if(-Not $project){
        "[Get-ProjectNumber] No project found with name [$Name] in [$Owner]" | Write-Verbose
        return -1
    } 
    
    if($project.Count -gt 1){
        "[Get-ProjectNumber] Found more than one project with name [$Name] in [$Owner]" | Write-Warning
    } else {
        "[Get-ProjectNumber] Found project [$($project.title)] with number [$($project.number)]" | Write-Verbose
    }

    $ret = $project.number[0]

    return $ret
} Export-ModuleMember -Function Get-ProjectNumber