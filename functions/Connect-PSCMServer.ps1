function Connect-PSCMServer {
	<#
	.SYNOPSIS 
	Imports ConfigurationManager module and creates a PSDrive for the SiteServer
	.DESCRIPTION 
	Imports ConfigurationManager module and creates a PSDrive for the SiteServer then sets location to that drive
	.PARAMETER SiteCode
	SiteCode of SCCM site
	.PARAMETER ProviderMachineName
	SCCM server to connect to
	.EXAMPLE
	Connect-PSCMServer -sitecode PRI -ProviderMachineName SCCMServer
	.NOTES
	Doesn't actually connect anything really. Just loads the module and creates a PSDrive

	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory)]
		$SiteCode,
		$ProviderMachineName = "localhost"
	)
	
	begin
	{
	}
	
	process
	{
		if($null -eq (Get-Module ConfigurationManager))
		{
			Write-PSFMessage "ConfigurationManager Module was not loaded, loading now" -Level Warning
			Import-Module (Join-Path $(Split-Path $env:SMS_ADMIN_UI_PATH) ConfigurationManager.psd1) -ErrorAction Stop -Force -Scope Global
		}
		if($null -eq (Get-PSDrive -Name $SiteCode -PSProvider CMSite -ErrorAction SilentlyContinue))
		{
			New-PSDrive -Name $SiteCode -PSProvider CMSite -Root $ProviderMachineName -ErrorAction Stop
		}

		Set-Location "$($SiteCode):\" -ErrorAction Stop
		#build globals
		$Global:SiteCode = $SiteCode
		$Global:PSCMCIMSessionHash = New-PSCMCIMSession -SiteCode $sitecode -Computername (Get-CMSite).ServerName
	}
	end
	{
	}
}
