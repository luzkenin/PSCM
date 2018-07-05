function Get-PSCMSoftwareUpdateProductCategory
{
	 <#
	.SYNOPSIS
	Get product category
	.DESCRIPTION
	Get a software update product category instance. Takes multiple product inputs.
	.PARAMETER IncludeProduct
	Products you want to include in the search
	.PARAMETER CIMSessionHash
	Use Set-PSCMCIMSession to set a variable to CIMSessionHash
	.EXAMPLE
	Get-PSCMSoftwareUpdateProductCategory -IncludeProducts "Office 2013","Windows 7","Windows Server 2008 R2", "Windows Server 2012 R2", "Windows Server 2016" -CIMSessionHash $CIMSessionHash
#>
	[CmdletBinding()]
		param (
		[Parameter(Mandatory, ValueFromPipeline)]
		$IncludeProduct,
		[Parameter(Mandatory, ValueFromPipeline)]
		[hashtable]$CIMSessionHash
	)

	begin {
	}

	process
	{
		$productcategories = Get-CimInstance -ClassName SMS_UpdateCategoryInstance -Filter 'CategoryTypeName="Product"' @CIMSessionHash
		$FilterForProductCategory = @()
		foreach($Product in $IncludeProduct)
		{
			$FilterForProductCategory += "`$_.LocalizedCategoryInstanceName -eq ""$product"""
		}
		$Join = $FilterForProductCategory -join " -or "
		$ScriptBlock = [scriptblock]::Create( $Join )

		$productcategories | Where-Object -FilterScript $ScriptBlock
	}
	end
	{
	}
}
