function Get-PSCMCIMSession
{
	<#
	.SYNOPSIS
	Generates hash for CIMSession
	.DESCRIPTION
	Generates hash for CIMSession.
	.PARAMETER SiteCode
	SCCM Site Code
	.PARAMETER Computername
	SCCM Server name
	.EXAMPLE
	$CIMSession = Get-PSCMCIMSession -SiteCode PRI -ComputerName SCCMServer
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory)]
		[string]$SiteCode,
		[string]$Computername = "localhost"
	)
	
	begin {
	}
	
	process
	{
		$CIMSessionHash = @{
			cimsession = New-CimSession -ComputerName $Computername
			NameSpace = "Root\SMS\Site_$SiteCode"
			ErrorAction = 'Stop'
		}
		[hashtable]$CIMSessionHash
	}
	
	end {
	}
}
