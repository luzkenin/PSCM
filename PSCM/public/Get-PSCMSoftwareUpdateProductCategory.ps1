function Get-PSCMSoftwareUpdateProductCategory
{
    <#
    .SYNOPSIS
    Get product category
    .DESCRIPTION
    Get a software update product category instance. Takes multiple product inputs.

    .PARAMETER IncludeProduct
    Products you want to include in the search

    .PARAMETER ExcludeProduct
    Products you want to include in the search

    .PARAMETER CIMSessionHash
    Use New-PSCMCIMSession to set a variable to CIMSessionHash

    .EXAMPLE
    Get-PSCMSoftwareUpdateProductCategory -IncludeProduct "Office 2013","Windows 7","Windows Server 2008 R2", "Windows Server 2012 R2", "Windows Server 2016" -CIMSessionHash $CIMSessionHash
#>
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        $IncludeProduct,
        [Parameter(ValueFromPipeline)]
        $ExcludeProduct,
        [Parameter(ValueFromPipeline)]
        [hashtable]$CIMSessionHash = $PSCMCIMSessionHash
    )

    begin
    {
    }

    process
    {
        $productcategories = Get-CimInstance -ClassName SMS_UpdateCategoryInstance -Filter 'CategoryTypeName="Product"' @CIMSessionHash
        $FilterForProductCategory = @()
        if ($IncludeProduct)
        {
            foreach ($Product in $IncludeProduct)
            {
                $FilterForProductCategory += "`$_.LocalizedCategoryInstanceName -eq ""$product"""
            }
        }
        if ($ExcludeProduct)
        {
            foreach ($Product in $ExcludeProduct)
            {
                $FilterForProductCategory += "`$_.LocalizedCategoryInstanceName -ne ""$product"""
            }
        }

        $Join = $FilterForProductCategory -join " -or "
        $ScriptBlock = [scriptblock]::Create( $Join )

        #$productcategories | Where-Object -FilterScript $ScriptBlock
        $productcategories.where($ScriptBlock)
        
        if ($null -eq $IncludeProduct -and $null -eq $ExcludeProduct)
        {
            $productcategories
        }
    }
    end
    {
    }
}
