
function ProjectDemoTest_updateIssueTimeTracking {
    Assert-SkipTest
    
    $projectNumber = 164 ; $fieldName ="TimeTracker" ; $owner = "solidifydemo"

    $items = Get-ProjectItems -ProjectNumber $ProjectNumber -Owner $Owner

    $filtered = $items | Where-Object {$_.content.number -eq 1}

    $result = $filtered | Update-ProjectItemsTimeTracking -ProjectNumber $projectNumber -Owner $owner -FieldName $fieldName

    # $result = $items | Update-ProjectItemsTimeTracking -ProjectNumber $projectNumber -Owner $owner -FieldName $fieldName 

    Assert-IsNull $result

    Assert-NotImplemented
}