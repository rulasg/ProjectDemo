
function Find-ProjectDemo{
    [CmdletBinding()]
    param(
        [Parameter()] [string]$Owner,
        [Parameter()] [int]$Limit,
        [Parameter()] [string]$User
    )

    $environment = Get-Environment -Owner $Owner

    $owner = $environment.Owner
    $limit = $nvironment.Limit

    $command = 'gh project list --owner {owner} --limit {limit} --format json'
    $command = $command -replace '{owner}',$owner
    $command = $command -replace '{limit}',$limit

    $resultJson = Invoke-Expression $command

    $resultJson | Write-Verbose

    $result = $resultJson | ConvertFrom-Json | Select-Object -ExpandProperty projects

    "Found [$($result.count)] projects in [$Owner]" | Write-Verbose

    # Check that account is equal to limit
    if($result.count -eq $limit){
        "Reached search limit. Consider rising the limit with -Limit to avoid loosing projects" | Write-Warning
    }

    # find project that has on their shortDescription the string [ProjectDemo]
    # $regex = "Created with \[ProjectDemo\]"
    # $filtered = $result | Where-Object { $_.shortDescription.StartsWith($environment.ProjectDescription)}

    # Look for all projects creted with [ProjectDemo]
    $filtered = $result | Where-Object { 
        $pattern = $environment.ProjectDescription
        Test-String -Pattern $pattern -Str $_.shortDescription
    }

    "Found [$($filtered.count)] projects with [$($environment.ProjectDescription)] in shortDescription" | Write-Verbose

    # Look for all projects creted with [ProjectDemo] by a specific user
    if(-Not [string]::IsNullOrWhiteSpace($User)){
        $filtered = $result | Where-Object { 
            $pattern = $environment.ProjectDescriptionWithOwnerPattern -replace '{user}', $User
            Test-String -Pattern $pattern -Str $_.shortDescription
        }

        "Found [$($filtered.count)] projects with [$pattern] in shortDescription" | Write-Verbose
    }

    $ret = $filtered | ForEach-Object {
        
        $des = $_.shortDescription

        # Regular expresion extract handle from [@handle]
        $pattern = '(?<=\[@).+?(?=\])'
        if ($des -match $pattern) {
            $user = $matches[0]
        }

        [PSCustomObject]@{
            Name = $_.Title
            User = $user
            Title = $_.Title
            Owner = $_.Owner.login
            Url = $_.url
        }
    }

    return $ret

} Export-ModuleMember -Function Find-ProjectDemo


function Test-String([string]$Pattern,[string]$Str){
    $regEx =  $Pattern -replace '\[','\[' -replace '\]','\]'
    
    return $Str -match $regEx

}