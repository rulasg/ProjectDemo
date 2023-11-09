function Remove-Project{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)] [string]$Name,
        [Parameter(Mandatory)] [string]$Owner
    )

    "Removing Project [$Name] in [$Owner]" | Write-Verbose

    $projectNumber = Get-ProjectNumber -Name $Name -Owner $Owner

    # error if $projectnumber count is more than 1
    if($projectNumber.Count -gt 1){
        Write-Error "More than one project found with name [$Name] in [$Owner]. [$projectNumber.Count] projects found [$projectNumber]"
        return
    }

    if($projectNumber -ne -1){
        
        if ($PSCmdlet.ShouldProcess("$Owner/$Name", "gh project delete $projectNumber --owner $owner --format json ")) {
            "[Remove-Project] gh project delete $projectNumber --owner $owner --format json" | Write-Verbose
            $ret = gh project delete $projectNumber --owner $owner --format json | ConvertFrom-Json
            "Removed project [$projectNumber] in [$Owner]" | Write-Host
        } else {
            $ret = [PSCustomObject]@{ url="https://github.com/orgs/fakeorg/projects/666"}
        }

        $ret | Format-List | Out-String | Write-Verbose

    } else {
        "No project found with name [$Name] in [$Owner]" | Write-Host
        $ret = $null
    }

    return $ret
} Export-ModuleMember -Function Remove-Project