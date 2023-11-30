function ProjectDemoTest_JobInternal_Start{

    $job = Start-JobInternal -Command "echo 'Hello World'"

    $w = Wait-Job -Job $job

    $result = Receive-Job -Job $job

    Assert-AreEqual -Expected $job.State -Presented "Completed"

    Assert-AreEqual -Expected "Hello World" -Presented $result

}

function ProjectDemoTest_JobInternal_Start_WithModule{

    $job = Start-JobInternal -Command "Get-TestString 'Hello World'" -LoadModule

    $waited = Wait-Job -Job $job

    $result = Receive-Job -Job $waited

    Assert-AreEqual -Expected $waited.State -Presented "Completed"

    Assert-AreEqual -Expected "[Hello World]" -Presented $result
}