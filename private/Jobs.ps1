function Start-JobInternal{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        # ScriptBlock
        [Parameter(Mandatory,ValueFromPipeline,Position=0)][string]$Command,
        [parameter()][switch]$LoadModule
    )
    process {

        if ($LoadModule){
            $modulePath = $PSScriptRoot | Split-Path -Parent
            $importModule = "Import-Module -Name $modulePath"
            $Command = $importModule + "`n" + $Command
        }
        
        $ScriptBlock = [ScriptBlock]::Create($Command)
        
        
        $job = Start-Job -ScriptBlock $ScriptBlock
        
        return $job
    }

} Export-ModuleMember -Function Start-JobInternal

function Get-TestString{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,Position=0)][string]$TestString
    )

    return "[{0}]" -f $TestString

} Export-ModuleMember -Function Get-TestString

