
$DEFAULT_NAME = "ProjectDemoTest"
$DEFAULT_OWNER = "SolidifyDemo"
$DEFAULT_LIMIT = 1000
$DEFAULT_ISSUES_AMOUNT = 5
$DEFAULT_USER = "anonymouse"
$FIXED_REPO_TOPIC = "projectdemo"
$REPO_ONE_NAME_PATTERN = "{name}-repo-front"
$REPO_TWO_NAME_PATTERN = "{name}-repo-back"
$REPO_TOPIC_PATTERN = "projectdemo-{name}"
$PROJECT_DESCRIPTION = "Created with [ProjectDemo]"
$PROJECT_DESCRIPTION_WITH_OWNER_PATTERN = $PROJECT_DESCRIPTION + " by [@{user}]"

function Get-Environment{
    [CmdletBinding()]
    param(
        [Parameter()] [string]$Name,
        [Parameter()] [string]$Owner,
        [Parameter()] [string]$User,
        [Parameter()] [int]$Limit, 
        [Parameter()] [int]$IssuesAmmount
    )

    $Name = Get-EnvironmentName -Name $Name
    $Owner = Get-EnvironmentOwner -Owner $Owner
    $user = Get-EnvironmentUser -User $User
    $limit = Get-EnvironmentLimit -Limit $Limit
    $IssuesAmmount = Get-EnvironmentIssuesAmmount -IssuesAmmount $IssuesAmmount

    $repo1 = $REPO_ONE_NAME_PATTERN -replace '{name}',$Name
    $repo2 = $REPO_TWO_NAME_PATTERN -replace '{name}',$Name

    $env = [PSCustomObject]@{
        DefaultName = $DEFAULT_NAME
        DefaultOwner = $DEFAULT_OWNER
        DefaultLimit = $DEFAULT_LIMIT
        DefaultIssueAmount = $DEFAULT_ISSUES_AMOUNT
        DefaultUser = $DEFAULT_USER
        ProjectDescription = $PROJECT_DESCRIPTION
        ProjectDescriptionWithOwnerPattern = $PROJECT_DESCRIPTION_WITH_OWNER_PATTERN
        FixedTopic = $FIXED_REPO_TOPIC

        Name = $Name
        Owner = $Owner
        User = $user
        Limit = $limit
        IssuesAmount = $IssuesAmmount
        RepoFront = $repo1
        RepoBack = $repo2
        RepoTopic = ($REPO_TOPIC_PATTERN -replace '{name}',$Name).ToLower()
        RepoFrontWithOwner = '{0}/{1}' -f $Owner, $repo1
        RepoBackWithOwner = '{0}/{1}' -f $Owner, $repo2
        ProjectDescriptionWithOwner = $PROJECT_DESCRIPTION_WITH_OWNER_PATTERN -replace '{user}',$user
    }

    return $env

} Export-ModuleMember -Function Get-Environment

function Get-EnvironmentName{
    [CmdletBinding()]
    param(
        [Parameter()] [string]$Name
    )

    #check if name is null or whitespace
    if([string]::IsNullOrWhiteSpace($Name)){
        $Name = $DEFAULT_NAME
    }

    return $Name
} 

function Get-EnvironmentOwner{
    [CmdletBinding()]
    param(
        [Parameter()] [string]$Owner
    )

    # Default owner 
    if([string]::IsNullOrWhiteSpace($Owner)){
        $Owner = $DEFAULT_OWNER
    }

    return $Owner
} 

function Get-EnvironmentLimit{
    [CmdletBinding()]
    param(
        [Parameter()] [int]$Limit
    )
    #check if limit is 0
    if($Limit -lt 1){
        $Limit = $DEFAULT_LIMIT
    }

    return $Limit

} 

function Get-EnvironmentIssuesAmmount{
    [CmdletBinding()]
    param(
        [Parameter()] [int]$IssuesAmmount
    )

    #check if limit is 0
    if($Limit -lt 1){
        $Limit = $DEFAULT_LIMIT
    }

    return $DEFAULT_ISSUES_AMOUNT
}

function Get-EnvironmentUser{
    [CmdletBinding()]
    param(
        [Parameter()] [string]$User
    )

    #check if user is null or whitespace
    if([string]::IsNullOrWhiteSpace($User)){
        $User = $DEFAULT_USER
    }

    return $User
} 