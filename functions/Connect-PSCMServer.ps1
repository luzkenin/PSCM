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
	Also the ConfigurationManager module is a bit finnicky. This function doesn't seem to load it unless it is made discoverable.
	Even when specifying the path it doesn't seem to load and doesn't stop on error(I guess no error.) You can make the module discoverable by the link in links
	.LINK
	https://gallery.technet.microsoft.com/Make-Configuration-Manager-04474a87
	#>
	[CmdletBinding()]
	param (
		$SiteCode, 
		$ProviderMachineName = "localhost",
		[switch]$VerboseOpt
	)
	
	begin
	{
	}
	
	process
	{
		if(-not(Get-Module ConfigurationManager))
		{
			Write-PSFMessage "ConfigurationManager Module was not loaded, loading now" -Level Warning
			Import-Module ConfigurationManager -ErrorAction Stop #Works when the module is made discoverable
			#Import-Module (Join-Path $(Split-Path $env:SMS_ADMIN_UI_PATH) ConfigurationManager.psd1) -ErrorAction Stop -Verbose:$VerboseOpt -Force #this doesn't seem to work
		}
		if($null -eq (Get-PSDrive -Name $SiteCode -PSProvider CMSite -ErrorAction SilentlyContinue))
		{
			New-PSDrive -Name $SiteCode -PSProvider CMSite -Root $ProviderMachineName -ErrorAction Stop -Verbose:$VerboseOpt
		}

		Set-Location "$($SiteCode):\" -ErrorAction Stop -Verbose:$VerboseOpt
	}
	end
	{
	}
}
