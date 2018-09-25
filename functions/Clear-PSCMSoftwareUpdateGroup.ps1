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
		[Parameter(Mandatory,ValueFromPipeline)]
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
		$SoftwareUpdatesToModify = $SoftwareUpdateGroup | Get-CMSoftwareUpdate -Fast | Where-Object {$_.IsSuperseded -eq $true -or $_.IsExpired -eq $true}
		if($SoftwareUpdatesToModify.count -gt 0) {
			Write-PSFMessage -Message "Found $($SoftwareUpdatesToModify.count) superseded updates in $($SoftwareUpdateGroup.LocalizedDisplayName)" -Level Warning
			foreach($Update in $SoftwareUpdatesToModify) {
				try {
					if($Expired -and $PSCmdlet.ShouldProcess($Update.ArticleID,'Remove') -and $Update.IsExpired -eq $true) {
						Remove-CMSoftwareUpdateFromGroup -SoftwareUpdateId $Update.CI_ID -SoftwareUpdateGroupId $SoftwareUpdateGroup.CI_ID -Confirm:$false -Force
						Write-PSFMessage -Message "Removing KB$($Update.ArticleID) because it was expired" -Level Important
					}
					if($Superseded -and $PSCmdlet.ShouldProcess($Update.ArticleID,'Remove') -and $Update.IsSuperseded -eq $true) {
						if($Update | Where-Object issuperseded -eq $true) {
							Remove-CMSoftwareUpdateFromGroup -SoftwareUpdateId $Update.CI_ID -SoftwareUpdateGroupId $SoftwareUpdateGroup.CI_ID -Confirm:$false -Force
							Write-PSFMessage -Message "Removing KB$($Update.ArticleID) because it was superseded" -Level Important
						}
					}
				}
				catch {
					Stop-PSFFunction -Message "Could not remove KB$($Update.ArticleID)" -ErrorRecord $_ -Continue
				}
			}
		}
		else {
			Write-PSFMessage -Message "Found $($SoftwareUpdatesToModify.count) superseded or expired updates in $($SoftwareUpdateGroup.LocalizedDisplayName)" -Level Important
		}
	}
	
	end {
	}
}
