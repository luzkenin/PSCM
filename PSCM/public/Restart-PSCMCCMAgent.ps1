function Restart-PSCMCCMAgent {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        # Parameter help description
        [Parameter()]
        [string[]]
        $ComputerName = $env:COMPUTERNAME
    )

    begin {

    }

    process {
        foreach ($Computer in $ComputerName) {
            if ($PSCmdlet.ShouldProcess("CCM Agent on $Computer", "Restarting")) {
                $Service = Get-Service -ComputerName $Computer -name "CCMExec" -ErrorAction SilentlyContinue
                if ($Service.Status -ne "Stopped") {
                    Write-Verbose -Message "Restarting $($Service.DisplayName) Service on $computername"
                    $Service.Stop()
                    $Service.WaitForStatus('Stopped', '00:00:20')
                    if ($Service.Status -eq "Stopped") {
                        Write-Verbose -Message "$($Service.DisplayName) is now $($Service.Status), starting"
                        Start-Sleep -Milliseconds 500
                        $Service.Start()
                        $Service.WaitForStatus('Running', '00:00:20')
                        if ($Service.Status -eq "Running") {
                            Write-Verbose -Message "$($Service.DisplayName) is now $($Service.Status)"
                        }
                        else {
                            Write-Error -Message "Could not start CCMExec on $Computer"
                        }
                    }
                    else {
                        Write-Error -Message "Could not restart $($Service.DisplayName)"
                        #$Result = "Could not stop $($Service.DisplayName)"
                    }
                }
                elseif ($Service.Status -eq "Stopped") {
                    Write-Verbose -Message "$($Service.DisplayName) is now $($Service.Status), starting"
                    Start-Sleep -Milliseconds 500
                    $Service.Start()
                    $Service.WaitForStatus('Running', '00:00:20')
                    if ($Service.Status -eq "Running") {
                        Write-Verbose -Message "$($Service.DisplayName) is now $($Service.Status)"
                    }
                    else {
                        Write-Error -Message "Could not start CCMExec on $Computer"
                    }
                }
            }
        }
    }

    end {

    }
}