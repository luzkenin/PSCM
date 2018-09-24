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
		$SoftwareUpdatesToModify = $SoftwareUpdateGroup | Get-CMSoftwareUpdate -Fast | Where-Object {$_.issuperseded -eq $true -or $_.isexpired -eq $true}
		if($SoftwareUpdatesToModify.count -gt 0) {
			Write-PSFMessage -Message "Found $($SoftwareUpdatesToModify.count) superseded updates in $($SoftwareUpdateGroup.LocalizedDisplayName)" -Level Warning
			foreach($Update in $SoftwareUpdatesToModify) {
				$reason = if($Update.issuperseded){"superseded"}elseif($Update.isexpired){"expired"}
				try {
					if($Expired -and $PSCmdlet.ShouldProcess($Update.ArticleID,'Remove')) {
						Remove-CMSoftwareUpdateFromGroup -SoftwareUpdateId $($Update | Where-Object isexpired -eq $true).CI_ID -SoftwareUpdateGroupId $SoftwareUpdateGroup.CI_ID -Confirm:$false -Force
						Write-PSFMessage -Message "Removing KB$($Update.ArticleID) because it was $Reason" -Level Important
					}
					if($Superseded -and $PSCmdlet.ShouldProcess($Update.ArticleID,'Remove')) {
						if($Update | Where-Object issuperseded -eq $true) {
							Remove-CMSoftwareUpdateFromGroup -SoftwareUpdateId $($Update | Where-Object issuperseded -eq $true).CI_ID -SoftwareUpdateGroupId $SoftwareUpdateGroup.CI_ID -Confirm:$false -Force
							Write-PSFMessage -Message "Removing KB$($Update.ArticleID) because it was $Reason" -Level Important
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
