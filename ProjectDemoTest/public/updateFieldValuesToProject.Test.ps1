
function ProjectDemoTest_FieldValueWithSingleSelect_Update{

    Assert-SkipTest

    $pn = Get-ProjectNumber 
    $fieldname =  "Priority"

    # Update-FieldValueWithSingleSelect -ProjectNumber 116 -FieldName "Status" 
    Update-FieldValueWithSingleSelect  $pn $fieldname -verbose -InformationAction Continue

    Assert-NotImplemented
}
function ProjectDemoTest_FieldValueWithNumberFibonacci_Update{

    Assert-SkipTest

    $pn = Get-ProjectNumber 
    $fieldname =  "TimeTracker"

    $result = Update-FieldValueWithNumberFibonacci $pn $fieldname

    Assert-NotImplemented
}

function ProjectDemoTest_FieldValueWithNumber_Update{

    Assert-SkipTest

    $pn = Get-ProjectNumber 
    $fieldname =  "TimeTracker"

    $result = Update-FieldValueWithNumber $pn $fieldname -min 10 -max 500

    Assert-NotImplemented
}
