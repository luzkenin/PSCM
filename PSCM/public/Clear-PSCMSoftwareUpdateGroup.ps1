function Clear-PSCMSoftwareUpdateGroup {
    <#
    .SYNOPSIS
    Clear a software update group

    .DESCRIPTION
    Clear a software update group

    .PARAMETER SoftwareUpdateGroup
    Source SUG

    .PARAMETER Superseded
    Switch for superseded

    .PARAMETER Expired
    Switch for expired

    .EXAMPLE
    Clear-PSCMSoftwareUpdateGroup -SoftwareUpdateGroup $newsug -Superseded

    .NOTES
    This is still a work in progress

    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        #[ValidateScript({Get-CMSoftwareUpdateGroup -name $_.LocalizedDisplayName})]
        $SoftwareUpdateGroup,
        [Parameter()]
        [switch]$Superseded,
        [Parameter()]
        [switch]$Expired
    )

    begin {
    }

    process {
        $SoftwareUpdatesToModify = $SoftwareUpdateGroup | Get-CMSoftwareUpdate -Fast
        $SupersededUpdates = $SoftwareUpdatesToModify | Where-Object { $_.IsSuperseded -eq $true -and $_.IsExpired -eq $false }
        $ExpiredUpdates = $SoftwareUpdatesToModify | Where-Object { $_.IsExpired -eq $true }

        foreach ($Update in $SupersededUpdates) {
            if ($Superseded -and $PSCmdlet.ShouldProcess("KB$($Update.ArticleID)", 'Remove')) {
                try {
                    Remove-CMSoftwareUpdateFromGroup -SoftwareUpdateId $Update.CI_ID -SoftwareUpdateGroupId $SoftwareUpdateGroup.CI_ID -Confirm:$false -Force
                    Write-PSFMessage -Message "Removed KB$($Update.ArticleID) because it was superseded" -Level Important
                }
                catch {
                    Stop-PSFFunction -Message "Could not remove KB$($Update.ArticleID)" -ErrorRecord $_ -EnableException -Continue
                }
            }
        }
        foreach ($Update in $ExpiredUpdates) {
            if ($Expired -and $PSCmdlet.ShouldProcess("KB$($Update.ArticleID)", 'Remove')) {
                try {
                    Remove-CMSoftwareUpdateFromGroup -SoftwareUpdateId $Update.CI_ID -SoftwareUpdateGroupId $SoftwareUpdateGroup.CI_ID -Confirm:$false -Force
                    Write-PSFMessage -Message "Removed KB$($Update.ArticleID) because it was expired" -Level Important
                }
                catch {
                    Stop-PSFFunction -Message "Could not remove KB$($Update.ArticleID)" -ErrorRecord $_ -EnableException -Continue
                }
            }
        }
    }
    end {
    }
}
