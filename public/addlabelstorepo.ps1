
function Test-LabelToRepo{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)][string]$Repo,
        [Parameter(Mandatory)][string]$Name,
        [Parameter()][string]$Owner
    )

    process {

        $Owner = Get-EnvironmentOwner -Owner $Owner

        $command = 'gh label list -R rulasg/testpublicrepo  --json name | convertfrom-json '
        
        $command = 'gh label list -R {owner}/{repo} --json name -S "{name}"'
        $command = $command -replace "{owner}", $Owner
        $command = $command -replace "{repo}", $Repo
        $command = $command -replace "{name}", $Name
        
        $command | Write-Verbose
        
        $resultJson = Invoke-Expression $command

        $result = $resultJson | ConvertFrom-Json | select-object -ExpandProperty name

        return $result -eq $Name
    }
} Export-ModuleMember -Function Test-LabelToRepo

function Add-LabelToRepo{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)] [string]$Repo,
        [Parameter(Mandatory)] [string]$Name,
        [Parameter()] [string]$Owner,
        [Parameter()] [string]$Description,
        [Parameter()] [string]$Color,
        [Parameter()] [switch]$Force
    )

    process{

        if(-not$Force){
            $exists = Test-LabelToRepo -Owner $Owner -Repo $Repo -Name $Name
            if($exists){
                Write-MyVerbose "Label [$Name] already exists in repo [$Repo]"
                return
            }
        }

        $Owner = Get-EnvironmentOwner -Owner $Owner
        
        $command = 'gh label create "{name}" -R {owner}/{repo} --force'
        $command = $command -replace "{name}", $Name
        $command = $command -replace "{owner}", $Owner
        $command = $command -replace "{repo}", $Repo
        
        
        if(-not[string]::IsNullOrWhiteSpace($Description)){
            $command = $command + ' --description "{description}"'
            $command = $command -replace "{description}", $Description
        }
        
        if(-not[string]::IsNullOrWhiteSpace($Color)){
            $command = $command + ' --color "{color}"'
            $command = $command -replace "{color}", $Color
        }
        
        $command | Write-MyVerbose
        
        $result = Invoke-Expression $command
        
        return $result
    }
} Export-ModuleMember -Function Add-LabelToRepo

function Add-WellknownLabelsToRepos{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)][string]$Repo,
        [Parameter()][switch]$Update,
        [Parameter()][string]$Owner
    )

    process{

        $env = Get-EnvironmentOwner -Owner $Owner 
        
        $labels = @(
            @{name="epic";    description="Initiative big in size and impact";                       color="B60205"}
            @{name="feature"; description="Initiative part of an epic with relative entity";         color="D93F0B"}
            @{name="task";    description="small unit of work";                                      color="FBCA04"}
            @{name="➰ recursive"; description="task that will run several times";                   color="D4C5F9"}
            @{name="follow-up"; description="nothing to be done. Follow-up how evolves";             color="C2E0C6"}
            )
            
            $labels | ForEach-Object{
                
                Add-LabelToRepo -Owner $Owner -Repo $Repo -Name $_.name -Description $_.description -Color $_.color
            }
            "Ended adding wellknown labels to repo [$Repo]" | Write-MyVerbose -NewLine
    }

} Export-ModuleMember -Function Add-WellknownLabelsToRepos