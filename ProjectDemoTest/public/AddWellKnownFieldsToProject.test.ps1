function ProjectDemoTest_UsingJobs_Add{

    $seconds = 1
    $number = 5

    $measure = Measure-Command {
        $result = Add-UsingJobs -Seconds $seconds $number
    }

    Assert-Count -Expected $number -Presented $result
    Assert-AreEqual -Expected $seconds -Presented $measure.Seconds

}

function ProjectDemoTest_WellknownFieldsToProject_Add{

    Assert-SkipTest

    $pn = 154
    $result = Add-WellknownFieldsToProject -ProjectNumber $pn -Verbose -Update
    # $result = Add-WellknownFieldsToProject -ProjectNumber $pn -update

    Assert-NotImplemented
}