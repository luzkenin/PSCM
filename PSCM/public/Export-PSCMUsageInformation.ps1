function Export-PSCMUsageInformation {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory)]
        #[ValidateScript( {Test-Path -Path $_ -PathType Leaf})]
        [ValidatePattern('.csv$')]
        [string]
        $Path
    )

    begin {
    }

    process {
        $SCCMServer = ((Get-CMSite).ServerName).split(".")[0]
        if ((Get-PSCMServiceConnectionPointMode) -ne "Online") {

            $CDLatest = invoke-command -ComputerName $SCCMServer -ScriptBlock { Get-Item "$env:SMS_ADMIN_UI_PATH\..\..\..\cd.latest" -ErrorAction SilentlyContinue }
            if ($CDLatest) {

                $SCT = "$CDLatest\SMSSETUP\TOOLS\ServiceConnectionTool\ServiceConnectionTool.exe"

                Invoke-Command -ComputerName $SCCMServer -ScriptBlock { & $using:SCT -export -dest $using:Path }
            }
        }
        else {
            Write-Error "Site is not in offline mode."
        }
    }

    end {
    }
}