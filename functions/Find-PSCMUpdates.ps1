function Find-PSCMUpdates {
    <#
	.SYNOPSIS 
    Filter for Microsoft Update products and categories
	.DESCRIPTION 
	Filter for Microsoft Update products and categories. You can specify multiple products and categories.
    .PARAMETER DatePostedMin
    How many days back you want to search
    .PARAMETER IncludeProduct
    Products you want to include in the search
    .PARAMETER ExcludedProduct
    Products you want to exclude in the search
    .PARAMETER IncludedUpdateCategory
    Categories you want to include in the search
    .PARAMETER ExcludedUpdateCategory
    Categories you want to exclude in the search
    .EXAMPLE
    Find-PSCMUpdates -DatePostedMin 40 -IncludedProduct 'Windows Server' -IncludedCategory 'Security Update'
    .EXAMPLE
    Find-PSCMUpdates -DatePostedMin 40 -IncludedProduct "Office 2013","Windows 7" -IncludedUpdateCategory "Security Updates"
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        $DatePostedMin,
        [Parameter(ValueFromPipeline)]
        $IncludedProduct,
        [Parameter(ValueFromPipeline)]
        $ExcludedProduct,
        [Parameter(ValueFromPipeline)]
        [ValidateSet('Critical Updates','Security Updates','Definition Updates','Update Rollups','Service Packs','Tools','Feature Packs','Updates')]
        $IncludedUpdateCategory,
        [Parameter(ValueFromPipeline)]
        [ValidateSet('Critical Updates','Security Updates','Definition Updates','Update Rollups','Service Packs','Tools','Feature Packs','Updates')]
        $ExcludedUpdateCategory
    )
    
    begin {
    }
    
    process
    {
        
        $date = get-date
        
        $AllUpdateList = Get-CMSoftwareUpdate -DatePostedMin ($date.AddDays(-$DatePostedMin)) -fast -IsExpired $false -IsSuperseded $false
        if($IncludedProduct -or $ExcludedProduct -or $IncludedUpdateCategory -or $ExcludedUpdateCategory)
        {
            $FilterForProduct = @()
            $FilterForUpdateCategory = @()
            if($IncludedProduct)
            {
                foreach($Product in $IncludedProduct)
                {
                    $FilterForProduct += "`$_.localizeddisplayname -like ""*$product*"""
                }
            }
            if($ExcludedProduct)
            {
                foreach($Product in $ExcludedProduct)
                {
                    $FilterForProduct += "`$_.localizeddisplayname -notlike ""*$product*"""
                }
            }
            if($IncludedUpdateCategory)
            {
                foreach($Category in $IncludedUpdateCategory)
                {
                    $FilterForUpdateCategory += "`$_.LocalizedCategoryInstanceNames -like ""*$Category*"""
                }
            }
            if($ExcludedUpdateCategory)
            {
                foreach($Category in $ExcludedUpdateCategory)
                {
                    $FilterForUpdateCategory += "`$_.LocalizedCategoryInstanceNames -notlike ""*$Category*"""
                }
            }
            $JoinProduct = $FilterForProduct -join " -or "
            $JoinCategory = $FilterForUpdateCategory -join " -or "
            $JoinFilter = $JoinProduct, $JoinCategory -join " -and "
            $ScriptBlock = [scriptblock]::Create( $JoinFilter )
        
            $AllUpdateList | Where-Object -FilterScript $ScriptBlock
        }
        else
        {
            $AllUpdateList
        }
    }
    end {
    }
}
