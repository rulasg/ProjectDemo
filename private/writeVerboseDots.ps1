function Write-MyVerbose{
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)] [string]$Message
    )

    process {

        if ($VerbosePreference -eq 'SilentlyContinue') {

            if ([string]::IsNullOrWhiteSpace($Message)) {
                Write-Host ""
            } else {
                Write-Host '.' -NoNewline
            }
        }

        Write-Verbose $Message
    }
} Export-ModuleMember -Function Write-MyVerbose