function Sync-PSCMUsageData {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory)]
        [ValidatePattern('serviceconnectiontool.exe$')]
        [string]
        $ServiceConnectionToolPath,
        # Parameter help description
        [Parameter(Mandatory)]
        [ValidatePattern('.cab$')]
        [string]
        $UsageDataPath
    )

    begin {
    }

    process {
        Start-Process -FilePath $ServiceConnectionToolPath -ArgumentList $path

    }

    end {
    }
}