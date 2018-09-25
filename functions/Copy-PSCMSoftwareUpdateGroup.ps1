function Copy-PSCMSoftwareUpdateGroup
{
	<#
	.SYNOPSIS
	Copy software update group
	.DESCRIPTION
	Copy software update group to new group. Currently does not copy deployments of source SUG.
	.PARAMETER Source
	Source name of software update group
	.PARAMETER Target
	Target name of software update group
	.EXAMPLE
	Copy-PSCMSoftwareUpdateGroup -Source 7-2018 -Target copy
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory)]
		[ValidateScript({Get-CMSoftwareUpdateGroup -name $_})]
		[String]$Source,
		[Parameter(Mandatory)]
		[ValidateScript({$null -eq (Get-CMSoftwareUpdateGroup -name $_ -erroraction silentlycontinue)})]
		[String]$Target
	)

	begin {
	}

	process
	{
		$UpdatesInSource = Get-CMSoftwareUpdateGroup -Name $Source | Get-CMSoftwareUpdate -fast

		Write-PSFMessage "Creating new software update group named $Target" -Level Important
		if($null -eq (Get-CMSoftwareUpdateGroup -name $Target -erroraction silentlycontinue))
		{
			try
			{
				$CreateSUG = New-CMSoftwareUpdateGroup -Name $Target
			}
			catch
			{
				Stop-PSFFunction -Message "Failure" -ErrorRecord $_
				return
			}
		}
		Write-PSFMessage "Copying $($UpdatesInSource.count) updates from $Source to $Target" -Level Important
		$UpdatesInSource | Add-CMSoftwareUpdateToGroup -SoftwareUpdateGroupName $Target
	}

	end {
	}
}

