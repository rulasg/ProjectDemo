function ProjectDemoTest_UsingJobs_Add{

    $seconds = 1
    $number = 5

    $measure = Measure-Command {
        $result = Add-UsingJobs -Seconds $seconds -Number $number
    }
    
    "Used $measure.Seconds seconds to run 5 jobs of 1 second." | Write-Verbose

    Assert-Count -Expected $number -Presented $result

    Assert-IsTrue -Condition ($measure.Seconds -lt ($number * $seconds))

}

function ProjectDemoTest_WellknownFieldsToProject_Add{

    Assert-SkipTest

    $pn = 154
    $result = Add-WellknownFieldsToProject -ProjectNumber $pn -Verbose -Update
    # $result = Add-WellknownFieldsToProject -ProjectNumber $pn -update

    Assert-NotImplemented
}