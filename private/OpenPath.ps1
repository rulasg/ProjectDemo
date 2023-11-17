function Open-Url{
    param(
        [Parameter( ValueFromPipeline, ValueFromPipelineByPropertyName,Position=1)]
        [string[]] $Url
    )

    process{

        if ($IsWindows) {
            
            Start-Process $Url
        } else{

            open $Url
        }
        
    }
}