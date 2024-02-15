


function Update-ProjectItemsTimeTracking{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,Position=0)][string]$ProjectNumber,
        [Parameter()][string]$Owner,
        [Parameter(Mandatory,ValueFromPipeline)][Object]$item,
        [Parameter()][string]$FieldName
    )

    begin{
        Import-RepoHelper

        
        $Owner = Get-EnvironmentOwner -Owner $Owner
        
        # $ProjectId = Get-ProjectId -ProjectNumber $ProjectNumber -Owner $Owner
        $projectId ="PVT_kwDOBCrGTM4ActQa"
        
        # $field = Get-Field -ProjectNumber $ProjectNumber -FieldName $FieldName -Owner $Owner
        $fieldId = "PVTF_lADOBCrGTM4ActQazgSkglc"
    }

    process{

        foreach($i in $item){
            ($issueOwner,$issueRepo,$IssueNumber) = Get-RepoOwnerFromUrl  $i.content.url
            
            # Get the time tracking for the issue
            $time = Get-RepoIssueTimeTracking -Repo $issueRepo -Owner $issueOwner -Number $IssueNumber
            
            $targetValue = $time.TotalMinutes
            $itemId = $i.id
            $itemValue = $i.$FieldName

            # Check if we need to skip
            # Value not set and time tracking is 0
            if(($null -eq $itemValue )-and ($targetValue -eq 0)){ 
                Write-MyVerbose "$owner/$repo/$number Skipping .. $FieldName not set" ; continue }
            # Value set and time tracking is the same
            if($time.TotalMinutes -eq $itemValue){ 
                Write-MyVerbose "$owner/$repo/$number Skipping .. $FieldName not changed [$itemValue]"
                continue
            }

            Write-MyVerbose "$owner/$repo/$number Updating with $FieldName [$itemValue] -> [$targetValue] "
            $result = Edit-ItemField $projectId $fieldId $itemId -Number $targetValue


            if($null -ne $result){
                Write-Verbose "Updated item [$itemId] with time tracking [$time.TotalMinutes] Result in [$result]"
            }
        }
    }
} Export-ModuleMember -Function Update-ProjectItemsTimeTracking

function Import-RepoHelper{
    [CmdletBinding()]
    param()
    
    $local = $PSScriptRoot
    $root = $local | Split-Path -Parent | Split-Path -Parent
    $module = $root | Join-Path -ChildPath RepoHelper
    
    Import-Module -Name $module -Force
}

function Get-RepoOwnerFromUrl{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,Position=0)][string]$Url
    )

    $segments = $url -split "/"
    
    $owner = $segments[3]
    $repo = $segments[4]
    $number = $segments[6]

    return ($owner,$repo,$number)
}