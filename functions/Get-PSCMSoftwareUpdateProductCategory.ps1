function Get-PSCMSoftwareUpdateProductCategory
{
     <#
	.SYNOPSIS 
    Get product category

	.DESCRIPTION 
	Obtain a uniqueID for a software update product category instance. Takes multiple product inputs.

	.PARAMETER IncludeProducts
	
    .PARAMETER CIMSessionHash
    
	.EXAMPLE 
#>
    [CmdletBinding()]
        param (
        [Parameter(Mandatory, ValueFromPipeline)]
        $IncludeProducts,
        [Parameter(Mandatory, ValueFromPipeline)]
        [hashtable]$CIMSessionHash
    )
    
    begin {
    }
    
    process
    {
        $productcategories = Get-CimInstance -ClassName SMS_UpdateCategoryInstance -Filter 'CategoryTypeName="Product"' @CIMSessionHash
        $FilterForProductCategory = @()
        foreach($Product in $IncludeProducts)
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