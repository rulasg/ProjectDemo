function Edit-ItemField{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory,Position=0)][string]$ProjectId,
        [Parameter(Mandatory,Position=1)][string]$FieldId,
        [Parameter(Mandatory,Position=2)][string]$ItemId,
        [Parameter()][Int32]$Number,
        [Parameter()][string]$Text,
        [Parameter()][string]$OptionId
    )

    $command = 'gh project item-edit --id {itemid} --field-id {fieldid} --project-id {projectid}'
    
    if($Number){
        $command = $command + " --number $number "
    }

    if($Text){
        $command = $command + " --text $text "
    }

    if($OptionId){
        $command = $command + " --single-select-option-id $OptionId "
    }

    $command = $command -replace "{itemid}", $itemId
    $command = $command -replace "{fieldid}", $fieldId
    $command = $command -replace "{projectid}", $projectId
    $command = $command -replace "{value}", $Value
    
    "Updating item [{0}]" -f $item.title | Write-MyVerbose

    if ($PSCmdlet.ShouldProcess($item.tittle, $command)) {
        $command | Write-MyVerbose
        $result = Invoke-Expression $command
    }

    return $result

} Export-ModuleMember -Function Edit-ItemField