function Find-PSCMUpdates {
    <#
	.SYNOPSIS 
    Filter for Microsoft Update products and categories
	.DESCRIPTION 
	Filter for Microsoft Update products and categories. You can specify multiple products and categories.
    .PARAMETER IncludeProducts
    How many days back you want to search
    .PARAMETER IncludeProducts
    Products you want to include in the search
    .PARAMETER ExcludedProducts
    Products you want to exclude in the search
    .PARAMETER IncludedUpdateCategories
    Categories you want to include in the search
    .PARAMETER ExcludedUpdateCategories
    Categories you want to exclude in the search
    .PARAMETER CIMSessionHash
    Hash for CIMSession. You can use Set-PSCMCIMSession to easily assign a variable the CIMSession hash.
    .EXAMPLE
    Find-PSCMUpdates -DatePostedMin 40 -IncludedProducts 'Windows Server' -IncludedCategories 'Security Update'
    .EXAMPLE
    Find-PSCMUpdates -DatePostedMin 40 -IncludedProducts "Office 2013","Windows 7" -IncludedUpdateCategories "Security Updates"
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        $DatePostedMin,
        [Parameter(ValueFromPipeline)]
        $IncludedProducts,
        [Parameter(ValueFromPipeline)]
        $ExcludedProducts,
        [Parameter(ValueFromPipeline)]
        [ValidateSet('Critical Updates','Security Updates','Definition Updates','Update Rollups','Service Packs','Tools','Feature Packs','Updates')]
        $IncludedUpdateCategories,
        [Parameter(ValueFromPipeline)]
        [ValidateSet('Critical Updates','Security Updates','Definition Updates','Update Rollups','Service Packs','Tools','Feature Packs','Updates')]
        $ExcludedUpdateCategories
    )
    
    begin {
    }
    
    process
    {
        
        $date = get-date
        
        $AllUpdateList = Get-CMSoftwareUpdate -DatePostedMin ($date.AddDays(-$DatePostedMin)) -fast -IsExpired $false -IsSuperseded $false
        if($IncludedProducts -or $ExcludedProducts -or $IncludedUpdateCategories -or $ExcludedUpdateCategories)
        {
            $FilterForProduct = @()
            $FilterForUpdateCategory = @()
            if($IncludedProducts)
            {
                foreach($Product in $IncludedProducts)
                {
                    $FilterForProduct += "`$_.localizeddisplayname -like ""*$product*"""
                }
            }
            if($ExcludedProducts)
            {
                foreach($Product in $ExcludedProducts)
                {
                    $FilterForProduct += "`$_.localizeddisplayname -notlike ""*$product*"""
                }
            }
            if($IncludedUpdateCategories)
            {
                foreach($Category in $IncludedUpdateCategories)
                {
                    $FilterForUpdateCategory += "`$_.LocalizedCategoryInstanceNames -like ""*$Category*"""
                }
            }
            if($ExcludedUpdateCategories)
            {
                foreach($Category in $ExcludedUpdateCategories)
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
