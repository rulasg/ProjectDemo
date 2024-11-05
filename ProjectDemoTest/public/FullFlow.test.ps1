function ProjectDemoTest_Full_flow{

    # Avoid test to run agianst GitHub
    # This test is used during development
    
    Assert-SkipTest

    $name = "testproject"
    $owner = "octodemo"

    # New Project
    $resultNewProjectDemo = New-ProjectDemo -Name $name  -Owner $owner

    $projectUrl = $resultNewProjectDemo | where-object {$_ -match "/projects/"}

    Assert-Contains -Presented $resultNewProjectDemo -Expected "https://github.com/OctoDemo/testproject-repo-front"
    Assert-Contains -Presented $resultNewProjectDemo -Expected "https://github.com/OctoDemo/testproject-repo-back"

    # Get project number
    $resultGetProjectNumber = Get-ProjectNumber -Name $name -Owner $owner

    $projectUrl = "https://github.com/orgs/OctoDemo/projects/" + $resultGetProjectNumber
    Assert-Contains -Presented $resultNewProjectDemo -Expected $projectUrl

    # Test Project
    $result = Test-projectDemo -name $name  -Owner $owner 
    Assert-IsTrue $result

    #Get environment
    $resultEnv = Get-Environment -name $name -Owner $owner

    Assert-AreEqual -Presented $resultEnv.Name               -Expected  "testproject"
    Assert-AreEqual -Presented $resultEnv.Owner              -Expected  "octodemo"
    Assert-AreEqual -Presented $resultEnv.DefaultOwner       -Expected  "OctoDemo"
    Assert-AreEqual -Presented $resultEnv.RepoTopic              -Expected  "projectdemo-testproject"
    Assert-AreEqual -Presented $resultEnv.RepoFront          -Expected  "testproject-repo-front"
    Assert-AreEqual -Presented $resultEnv.RepoBack           -Expected  "testproject-repo-back"
    Assert-AreEqual -Presented $resultEnv.RepoFrontWithOwner -Expected  "octodemo/testproject-repo-front"
    Assert-AreEqual -Presented $resultEnv.RepoBackWithOwner  -Expected  "octodemo/testproject-repo-back"
    Assert-AreEqual -Presented $resultEnv.IssuesAmount       -Expected  "5"

    # Find projectdemo
    $me = gh api user | ConvertFrom-Json | Select-Object -ExpandProperty login
    
    $result = Find-ProjectDemo -Owner $owner

    $project = $result | Where-Object { $_.Name -eq $name }
    Assert-AreEqual -Presented $project.Title -Expected $name
    Assert-AreEqual -Presented $project.Owner -Expected $owner
    Assert-AreEqual -Presented $project.Url -Expected $projectUrl
    Assert-AreEqual -Presented $project.User -Expected $me

    $result = Find-ProjectDemo -Owner $owner -User $me

    $me = gh api user | ConvertFrom-Json | Select-Object -ExpandProperty login
    $project = $result | Where-Object { $_.Name -eq $name }
    Assert-AreEqual -Presented $project.Title -Expected $name
    Assert-AreEqual -Presented $project.Owner -Expected $owner
    Assert-AreEqual -Presented $project.Url -Expected $projectUrl
    Assert-AreEqual -Presented $project.User -Expected $me

    # Remove project
    $result = Remove-ProjectDemo -name $name -Owner $owner

    # Test Project
    $result = Test-projectDemo -name $name -Owner $owner 
    Assert-IsFalse $result
}