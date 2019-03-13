function Save-PSCMUsageData {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory)]
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

                Invoke-Command -ComputerName $SCCMServer -ScriptBlock { & $using:SCT -prepare -usagedatadest "$env:temp\UsageData.cab" }
                #need to zip some folders
            }
        }
        else {
            Write-Error "Site is not in offline mode."
        }
    }

    end {
    }
}