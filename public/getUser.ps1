function Get-User{
    [CmdletBinding()]
    param(
    )

    $command = 'gh api user'

    $resultjson = Invoke-Expression $command

    $result = $resultjson | ConvertFrom-Json 

    $user = $result.login

    return $user
}