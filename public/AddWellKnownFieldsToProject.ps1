function Add-PriorityFieldToProject{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory,Position=0)] [string]$ProjectNumber,
        [Parameter()] [string]$Owner,
        [Parameter()][switch]$Update
    )

    $owner = Get-EnvironmentOwner -Owner $Owner

    $fieldName = "Priority"
    $options= "🔥Critical,🥵High,😊Normal,🥶Low"

    Add-FieldSingleSelectToProject -ProjectNumber $ProjectNumber -Owner $Owner -FieldName $fieldName -Options $options

    if($Update){
        Update-FieldValueWithSingleSelect -ProjectNumber $ProjectNumber -FieldName $fieldName -Owner $Owner
    }

} Export-ModuleMember -Function Add-PriorityFieldToProject

function Add-SeverityFieldToProject{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory,Position=0)] [string]$ProjectNumber,
        [Parameter()][switch]$Update,
        [Parameter()] [string]$Owner
    )

    $owner = Get-EnvironmentOwner -Owner $Owner

    $fieldName = "Severity"
    $options= "Critical⭐️⭐️⭐️⭐️,Important⭐️⭐️⭐️,Needed⭐️⭐️,Nice⭐️" 

    Add-FieldSingleSelectToProject -ProjectNumber $ProjectNumber -Owner $Owner -FieldName $fieldName -Options $options

    if($Update){
        Update-FieldValueWithSingleSelect -ProjectNumber $ProjectNumber -FieldName $fieldName -Owner $Owner
    }

} Export-ModuleMember -Function Add-SeverityFieldToProject

function Add-CommentFieldToProject{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory,Position=0)] [string]$ProjectNumber,
        [Parameter()][switch]$Update,
        [Parameter()] [string]$Owner
    )

    $owner = Get-EnvironmentOwner -Owner $Owner

    $fieldname = "Comment"

    Add-FieldText -ProjectNumber $ProjectNumber -FieldName $fieldname -Owner $Owner

    if($Update){
        Update-FieldValueWithText -ProjectNumber $ProjectNumber -FieldName $fieldname -Owner $Owner -options @("This is a comment", "This is another comment", "This is a third comment")
    }

} Export-ModuleMember -Function Add-CommentFieldToProject

function Add-TimeTrackerFieldToProject{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory,Position=0)] [string]$ProjectNumber,
        [Parameter()][switch]$Update,
        [Parameter()] [string]$Owner
    )

    $owner = Get-EnvironmentOwner -Owner $Owner

    $fieldname = "TimeTraker"

    Add-FieldNumber -ProjectNumber $ProjectNumber -FieldName $fieldname -Owner $Owner

    if($Update){
        Update-FieldValueWithNumber -ProjectNumber $ProjectNumber -FieldName $fieldname -Owner $Owner -min 20 -max 500
    }


} Export-ModuleMember -Function Add-TimeTrackerFieldToProject

function Add-StoryPointsFieldToProject{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory,Position=0)] [string]$ProjectNumber,
        [Parameter()][string]$Owner,
        [Parameter()][switch]$Update
    )

    $owner = Get-EnvironmentOwner -Owner $Owner

    $fieldname = "UserStories"

    Add-FieldNumber -ProjectNumber $ProjectNumber -FieldName $fieldname -Owner $Owner

    if($Update){
        Update-FieldValueWithNumberFibonacci -ProjectNumber $ProjectNumber -FieldName $fieldname -Owner $Owner
    }

} Export-ModuleMember -Function Add-StoryPointsFieldToProject

function Add-StatusFieldToProject{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory,Position=0)] [string]$ProjectNumber,
        [Parameter()][switch]$Update,
        [Parameter()][string]$Owner
    )

    $owner = Get-EnvironmentOwner -Owner $Owner

    "Skipping the creation of Status to project $ProjectNumber" | Write-Host

    if($Update){
        Update-FieldValueWithSingleSelect -ProjectNumber $ProjectNumber -FieldName "Status" -Owner $Owner
    }

} Export-ModuleMember -Function Add-StatusFieldToProject

function Add-WellknownFieldsToProject{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory,Position=0)] [string]$ProjectNumber,
        [Parameter()][switch]$Update,
        [Parameter()][string]$Owner
    )

    $owner = Get-EnvironmentOwner -Owner $Owner

    if($Update){
        $updateParam = " -Update"
    }

    $jobs = @()

      $jobs += Start-JobInternal -Command $("Add-StatusFieldToProject      -ProjectNumber $ProjectNumber -Owner $owner" + $updateParam) -LoadModule
      $jobs += Start-JobInternal -Command $("Add-SizeFieldToProject        -ProjectNumber $ProjectNumber -Owner $owner" + $updateParam) -LoadModule
      $jobs += Start-JobInternal -Command $("Add-PriorityFieldToProject    -ProjectNumber $ProjectNumber -Owner $owner" + $updateParam) -LoadModule
      $jobs += Start-JobInternal -Command $("Add-SeverityFieldToProject    -ProjectNumber $ProjectNumber -Owner $owner" + $updateParam) -LoadModule
      $jobs += Start-JobInternal -Command $("Add-CommentFieldToProject     -ProjectNumber $ProjectNumber -Owner $owner" + $updateParam) -LoadModule
      $jobs += Start-JobInternal -Command $("Add-TimeTrackerFieldToProject -ProjectNumber $ProjectNumber -Owner $owner" + $updateParam) -LoadModule
      $jobs += Start-JobInternal -Command $("Add-StoryPointsFieldToProject -ProjectNumber $ProjectNumber -Owner $owner" + $updateParam) -LoadModule


    $waitings = Wait-Job -Job $jobs

    $waitings | Receive-Job | Write-Output
    
    # $waitings | ForEach-Object {
    #     $result = Receive-Job -Job $_
    #     $result | Write-MyVerbose

    #     Write-Output -InputObject $result
    # }

    Write-MyVerbose "All jobs are done" -NewLine

} Export-ModuleMember -Function Add-WellknownFieldsToProject

function Add-UsingJobs{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,Position=0)] [int]$Seconds,
        [Parameter(Mandatory,Position=1)] [string]$number
    )

    $jobs = @()

    1..$number | ForEach-Object{
        $jobs += Start-Job -ScriptBlock {
            $id = $args[0]
            $seconds = $args[1]
            Start-Sleep -Seconds $seconds; "Job $id slept $seconds seconds" | Write-Output
        } -ArgumentList $_,$Seconds
    }

    $waitings = Wait-Job -Job $jobs
    $waitings | ForEach-Object {
        Receive-Job -Job $_
    }

} Export-ModuleMember -Function Add-UsingJobs

