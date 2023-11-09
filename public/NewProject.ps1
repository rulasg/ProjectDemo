function New-Project{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string]$Name,
        [Parameter()] [string]$Owner
    )

    # create project
    "Creating project [$Name] in [$Owner]" | Write-Verbose
    "[New-Project] gh project create --owner $Owner --title $Name --format json" | Write-Verbose
    $resultJson = gh project create --owner $Owner --title $Name --format json
    $resultJson | Write-Verbose

    $result = $resultJson | ConvertFrom-Json

    if(-Not $($result.number)){
        Write-Error "Error creating project [$Name] in [$Owner]"
        return
    }

    $number = $result.number

    # Edit project about
    "[New-Project] gh project edit $number --owner $Owner --visibility PUBLIC --readme `"README Demostrate how to use projects`" --description `"Demostrate how to use projects`"" | Write-Verbose
    $result = gh project edit $number --owner $Owner --visibility PUBLIC --readme "README Demostrate how to use projects" --description "Demostrate how to use projects"
    $result | Write-Verbose

    return $number
} Export-ModuleMember -Function New-Project

