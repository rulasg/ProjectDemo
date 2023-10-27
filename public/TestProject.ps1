function Test-Project{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline)][string]$Title,
        [Parameter(Mandatory)][string]$Owner
    )
    process{

        try {

            "Testing if project [$Title] exists for owner [$Owner]" | Write-Verbose
            "[Test-Project] gh project list --owner $Owner -L $QUERY_LIMIT --format json" | Write-Verbose

            $projectsList = gh project list --owner $Owner -L $QUERY_LIMIT --format json | ConvertFrom-Json

            $ret = $projectsList.projects.title.Contains($Title)

            $ret | Write-Verbose

            return $ret
        }
        catch {
            "Error testing on Project Title [$ProjectTitle] for owner [$Owner]" | Write-Verbose
        }
    }
}
