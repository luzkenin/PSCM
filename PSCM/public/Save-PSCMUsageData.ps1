function Save-PSCMUsageData {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory)]
        [string]
        $Path,
        # Parameter help description
        [Parameter()]
        [switch]
        $Package
    )

    begin {
    }

    process {
        [string]$SCCMServer = ((Get-CMSite).ServerName).split(".")[0]
        if ((Get-PSCMServiceConnectionPointMode) -ne "Online") {
            $MyScriptBlock = {
                $ConfigMgrPath = "$env:SMS_ADMIN_UI_PATH\..\..\..\"
                $CDLatestPath = Get-Item "$ConfigMgrPath\cd.latest" -ErrorAction SilentlyContinue
                Write-Verbose -Message "Found CDLatest Folder at $($CDLatestPath.FullName)"

                if ($CDLatestPath) {
                    $SCT = "$CDLatestPath\SMSSETUP\TOOLS\ServiceConnectionTool\ServiceConnectionTool.exe"
                    if ((Test-Path "$env:temp\UsageData") -eq $false) {
                        Write-Verbose -Message "Creating folder"
                        New-Item -Path "$ENV:Temp" -Name "UsageData" -ItemType Directory -Force | Out-Null
                    }
                    else {
                        Write-Verbose -Message "$("$env:temp\UsageData") exists"
                    }

                    #when it tries to connect to the database it is encountering a double hop issue (i think)
                    #^^^nope needed to have "SQL Server and Windows Authentication mode" selected. maybe another way to do this but i don't know.
                    #need to see about querying this with wmi? or something else. don't want to have to load another module
                    try {
                        & $SCT -prepare -usagedatadest "$env:temp\UsageData\UsageData.cab"
                    }
                    catch {
                        #ERROR: can not connect to the database. Please refer to the log file for more information.
                        Write-Error "whoa!"
                    }
                    
                    <#if($Package) {
                        #need to zip some folders
                    }
                    else {
                        #if not saving on sccm server will need to pull over to workstation
                        Copy-Item -Path "$env:temp\UsageData.cab" -Destination $Path
                    }#>
                }
                else {
                    Write-Error -Exception "CDLatest folder was not found in $($ConfigMgrPath.FullName)"
                }
            }

            Invoke-Command -ComputerName $SCCMServer -ScriptBlock $MyScriptBlock
        }
        else {
            Write-Error "Site is not in offline mode."
        }
        <#
        $SCCMServer = ((Get-CMSite).ServerName).split(".")[0]
        if ((Get-PSCMServiceConnectionPointMode) -ne "Online") {

            $CDLatest = invoke-command -ComputerName $SCCMServer -ScriptBlock { Get-Item "$env:SMS_ADMIN_UI_PATH\..\..\..\cd.latest" -ErrorAction SilentlyContinue }
            if ($CDLatest) {

                $SCT = "$CDLatest\SMSSETUP\TOOLS\ServiceConnectionTool\ServiceConnectionTool.exe"

                Invoke-Command -ComputerName $SCCMServer -ScriptBlock { & $using:SCT -prepare -usagedatadest "$env:temp\UsageData\UsageData.cab" }
            }
        }
        else {
            Write-Error "Site is not in offline mode."
        }#>




        <#[PSCustomObject]@{
            Name = Value
        }#>
    }

    end {
    }
}
