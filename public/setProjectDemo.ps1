function Set-ProjectDemo{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter()] [string]$Name,
        [Parameter()] [string]$Owner
    )

    $env = Get-Environment -Name $Name -Owner $Owner
    $name = $env.Name
    $owner = $env.Owner
    
    New-ProjectDemo     -name $name  -Owner $owner
    
    Add-ItemsToProject  -name $name  -Owner $owner

    $projectNumber = Get-ProjectNumber -Name $name -Owner $owner
    
    Update-FieldValueWithSingleSelect      -ProjectNumber $projectNumber -owner $owner -FieldName "Status"
    
    Add-FieldSingleSelectToProject              -ProjectNumber $projectNumber -owner $owner -FieldName "Priority" -Options "🔥Critical,🥵High,😊Normal,🥶Low"
    Update-FieldValueWithSingleSelect      -ProjectNumber $projectNumber -owner $owner -FieldName "Priority"
    
    Add-FieldSingleSelectToProject              -ProjectNumber $projectNumber -owner $owner -FieldName "Severity" -Options "Critical⭐️⭐️⭐️⭐️,Important⭐️⭐️⭐️,Needed⭐️⭐️,Nice⭐️" 
    Update-FieldValueWithSingleSelect      -ProjectNumber $projectNumber -owner $owner -FieldName "Severity"

    Add-TimeTrackerToProject                    -ProjectNumber $projectNumber -owner $owner 

} Export-ModuleMember -Function Set-ProjectDemo