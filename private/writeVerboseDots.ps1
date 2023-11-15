<#
.SYNOPSIS
    My Owne Verbose output to control when not on verbose mode

.DESCRIPTION
    We will write '.' for each verbose write if not on Verbose mode.
    This will allow the user to see a clean line of dots as progress

.PARAMETER NewLine
    Allosw to force a new line after writing the progress dot if needed.
    Allows control the new line before leavig the command to avoid terminal prompt not in a new line.
#>
function Write-MyVerbose{
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)] [string]$Message,
        [Parameter()] [switch]$NewLine
    )

    process {

        $noNewLine = -not $NewLine

        if ($VerbosePreference -eq 'SilentlyContinue') {
            Write-Host '.' -NoNewline:$noNewLine
        }

        Write-Verbose $Message
    }
} Export-ModuleMember -Function Write-MyVerbose