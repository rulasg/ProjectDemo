function Remove-ProjectDemo{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(ValueFromPipelineByPropertyName)] [string]$Name,
        [Parameter(ValueFromPipelineByPropertyName)] [string]$Owner
    )
    process {

        $Name = Get-EnvironmentName -Name $Name
        $Owner = Get-EnvironmentOwner -Owner $Owner
        
        "Removing Demo Project [$Name] in [$Owner]" | Write-Verbose
        
        # Remove project
        $result = Remove-Project -Name $Name -Owner $Owner
        if($result){
            "Remove 1 project" | Write-Verbose
            $result | Write-Verbose
        } else {
            "[Remove-ProjectDemo] No project found with name [$Name] in [$Owner]" | Write-Verbose
        }
        
        # Remove Repos
        $topic = "projectdemo-"+ $Name
        $result = Remove-ReposByTopic -Topic $topic -Owner $Owner
        "Removed {0} repos" -f $result.Count | Write-Verbose
    }
} Export-ModuleMember -Function Remove-ProjectDemo

