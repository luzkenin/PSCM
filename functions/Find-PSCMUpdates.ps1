function Find-PSCMUpdates {
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
            $JoinProduct = $FilterForProduct -join " -and "
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