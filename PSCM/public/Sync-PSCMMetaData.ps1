function Sync-PSCMMetaData {
    <#
    .SYNOPSIS
    Syncs metadata from the parent WSUS server and waits until its done.

    .DESCRIPTION
    Sync-CMSoftwareUpdate does not wait and gives no output so I made this to let you sync and wait until the sync is done before going on to something else.

    .PARAMETER FullSync
    Indicates whether to perform a complete synchronization of all updates or a delta synchronization.

    .EXAMPLE
    Sync-PSCMMetaData -FullSync

    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [bool]$FullSync = $false
    )

    begin {
        if ($null -eq $sitecode)
        {
            $sitecode = (Get-CMSite).SiteCode
        }
    }

    process {
        Write-PSFMessage -Message "Syncing metadata from parent WSUS" -Level Important
        Sync-CMSoftwareUpdate -FullSync $FullSync

        do {
            Start-Sleep -Seconds 5
            $SyncStatus = Get-CMComponentStatusMessage -ComponentName SMS_WSUS_SYNC_MANAGER -SiteCode $sitecode -ViewingPeriod ((Get-Date).AddMinutes( - [System.TimeZone]::CurrentTimeZone.GetUtcOffset([datetime]::Now).TotalMinutes - 1)) | sort time |select -Last 1
            $OldComponentStatus = $ComponentStatus
            switch ($SyncStatus.MessageID) {
                6701 { $ComponentStatus = 'WSUS Synchronization started.' }
                6702 { $ComponentStatus = 'WSUS Synchronization done.' }
                6704 { $ComponentStatus = 'WSUS Synchronization in progress. Current phase: Synchronizing WSUS Server.' }
                6705 { $ComponentStatus = 'Synchronization started on site server.' }
            }

            if ($ComponentStatus -ne $OldComponentStatus) {
                Write-PSFMessage -Message "$ComponentStatus" -Level Important
            }

        } while ($SyncStatus.MessageID -ne 6702)
    }

    end {
    }
}
