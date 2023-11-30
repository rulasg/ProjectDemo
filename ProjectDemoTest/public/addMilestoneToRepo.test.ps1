function ProjectDemoTest_MilestoneToRepo_Add{
    
    $result = Add-MilestoneToRepo -Repo testproject-repo-apendix -Title "ML1 title" -WhatIf @InfoParameters

    Assert-IsNull $result
    Assert-contains -Presented $infovar.MessageData -Expected 'gh api repos/SolidifyDemo/testproject-repo-apendix/milestones -X POST -f title="ML1 title"'
    
    $result = Add-MilestoneToRepo -Repo testproject-repo-apendix -Title "ML2 title" -WhatIf -Description "Description for ML 2" @InfoParameters

    Assert-IsNull $result
    Assert-Contains -Presented $infovar.MessageData -Expected 'gh api repos/SolidifyDemo/testproject-repo-apendix/milestones -X POST -f title="ML2 title" -f description="Description for ML 2"'


    $d = (Get-Date).AddDays(14).Date
    $datestring = Get-Date -Date $d | Convertto-json
    $result = Add-MilestoneToRepo -Repo testproject-repo-apendix -Title "ML3 title" -WhatIf -Date (Get-Date).AddDays(14) @InfoParameters

    $expectedString = 'gh api repos/SolidifyDemo/testproject-repo-apendix/milestones -X POST -f title="ML3 title" -f due_on="{date}"' -replace "{date}", $datestring

    Assert-IsNull $result
    Assert-contains -Presented $infovar.MessageData -Expected $expectedString
}