function ProjectDemoTest_Full_flow{

    # Avoid test to run agianst GitHub
    # This test is used during development
    
    Assert-SkipTest 

    # New Project
    $resultNewProjectDemo = New-ProjectDemo -name testproject  -Owner solidifydemo

    Assert-Contains -Presented $resultNewProjectDemo -Expected "https://github.com/SolidifyDemo/testproject-repo-front"
    Assert-Contains -Presented $resultNewProjectDemo -Expected "https://github.com/SolidifyDemo/testproject-repo-back"

    # Get project number
    $resultGetProjectNumber = Get-ProjectNumber -Name testproject -Owner Solidifydemo

    $projectUrl = "https://github.com/orgs/SolidifyDemo/projects/" + $resultGetProjectNumber
    Assert-Contains -Presented $resultNewProjectDemo -Expected $projectUrl

    # Test Project
    $result = Test-projectDemo -name testproject  -Owner solidifydemo 
    Assert-IsTrue $result

    #Get environment
    $resultEnv = Get-Environment -name testproject -Owner solidifydemo

    Assert-AreEqual -Presented $resultEnv.Name               -Expected  "testproject"
    Assert-AreEqual -Presented $resultEnv.Owner              -Expected  "solidifydemo"
    Assert-AreEqual -Presented $resultEnv.DefaultOwner       -Expected  "SolidifyDemo"
    Assert-AreEqual -Presented $resultEnv.Topic              -Expected  "projectdemo-testproject"
    Assert-AreEqual -Presented $resultEnv.RepoFront          -Expected  "testproject-repo-front"
    Assert-AreEqual -Presented $resultEnv.RepoBack           -Expected  "testproject-repo-back"
    Assert-AreEqual -Presented $resultEnv.RepoFrontWithOwner -Expected  "solidifydemo/testproject-repo-front"
    Assert-AreEqual -Presented $resultEnv.RepoBackWithOwner  -Expected  "solidifydemo/testproject-repo-back"
    Assert-AreEqual -Presented $resultEnv.IssuesAmount       -Expected  "5"

    # Remove project
    $result = Remove-ProjectDemo -name testproject -Owner solidifydemo

    # Test Project
    $result = Test-projectDemo -name testproject  -Owner solidifydemo 
    Assert-IsFalse $result
}