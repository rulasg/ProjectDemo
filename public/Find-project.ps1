function Find-Project{
    [cmdletbinding()]
    param(
        [string]$Name,
        [string]$Owner
    )

    $list = ProjectHelper\Find-Project -Name $Name -Owner $Owner

    return $list
}