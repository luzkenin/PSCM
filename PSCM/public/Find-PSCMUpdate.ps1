function Find-PSCMUpdate
{
    <#
    .SYNOPSIS
    Filter for Microsoft Update products and categories

    .DESCRIPTION
    Filter for Microsoft Update products and categories. You can specify multiple products and categories.

    .PARAMETER DatePostedMin
    How many days back you want to search

    .PARAMETER Year
    Specify year I.E. (get-date -Year 2017)

    .PARAMETER Month
    Specify datetime with month and year. I.E. (get-date -Month 6). This will pass a specific month in the current year.

    .PARAMETER IncludedProduct
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
        [Parameter(ParameterSetName = 'DateRange', ValueFromPipeline)]
        [int]$DatePostedMin,
        [Parameter(ParameterSetName = 'YearRange', ValueFromPipeline)]
        #need to validate this date
        [datetime]$Year,
        [Parameter(ParameterSetName = 'MonthRange', ValueFromPipeline)]
        #need to validate this date
        [datetime]$Month,
        [Parameter(ValueFromPipeline)]
        $IncludedProduct,
        [Parameter(ValueFromPipeline)]
        $ExcludedProduct,
        [Parameter(ValueFromPipeline)]
        [ValidateSet('Critical Updates', 'Security Updates', 'Definition Updates', 'Update Rollups', 'Service Packs', 'Tools', 'Feature Packs', 'Updates')]
        $IncludedUpdateCategory,
        [Parameter(ValueFromPipeline)]
        [ValidateSet('Critical Updates', 'Security Updates', 'Definition Updates', 'Update Rollups', 'Service Packs', 'Tools', 'Feature Packs', 'Updates')]
        $ExcludedUpdateCategory
    )

    begin
    {
    }

    process
    {
        $now = get-date
        if ($DatePostedMin)
        {
            $AllUpdateList = Get-CMSoftwareUpdate -DatePostedMin ($now.AddDays(-$DatePostedMin)) -fast -IsExpired $false -IsSuperseded $false
        }
        elseif ($Year)
        {
            $StartOfYear = Get-Date -Year $Year.Year -Month 1 -Day 1 -Hour 0 -Minute 0 -Second 0 -Millisecond 0
            $EndOfYear = ($StartOfYear).AddMonths(12).addticks(-1)
            $AllUpdateList = Get-CMSoftwareUpdate -DatePostedMin $StartOfYear -DatePostedMax $EndOfYear -fast -IsExpired $false -IsSuperseded $false
        }
        elseif ($Month)
        {
            $StartOfMonth = Get-Date -Year $Month.Year -Month $Month.Month -Day 1 -Hour 0 -Minute 0 -Second 0 -Millisecond 0
            $EndOfMonth = ($StartOfMonth).AddMonths(1).addticks(-1)
            $AllUpdateList = Get-CMSoftwareUpdate -DatePostedMin $StartOfMonth -DatePostedMax $EndOfMonth -fast -IsExpired $false -IsSuperseded $false
        }

        if ($IncludedProduct -or $ExcludedProduct -or $IncludedUpdateCategory -or $ExcludedUpdateCategory)
        {
            $FilterForProduct = @()
            $FilterForUpdateCategory = @()
            if ($IncludedProduct)
            {
                foreach ($Product in $IncludedProduct)
                {
                    $FilterForProduct += "`$PSItem.LocalizedDisplayName -like ""*$product*"""
                }
            }
            if ($ExcludedProduct)
            {
                foreach ($Product in $ExcludedProduct)
                {
                    $FilterForProduct += "`$PSItem.LocalizedDisplayName -notlike ""*$product*"""
                }
            }
            if ($IncludedUpdateCategory)
            {
                foreach ($Category in $IncludedUpdateCategory)
                {
                    $FilterForUpdateCategory += "`$PSItem.LocalizedCategoryInstanceNames -eq ""$Category"""
                }
            }
            if ($ExcludedUpdateCategory)
            {
                foreach ($Category in $ExcludedUpdateCategory)
                {
                    $FilterForUpdateCategory += "`$PSItem.LocalizedCategoryInstanceNames -ne ""$Category"""
                }
            }

            $JoinProduct = $FilterForProduct -join " -and "
            $JoinCategory = $FilterForUpdateCategory -join " -and "
            if ($FilterForProduct -and $FilterForUpdateCategory)
            {
                $JoinFilter = $JoinProduct, $JoinCategory -join " -and "
            }
            elseif ($FilterForProduct)
            {
                $JoinFilter = $JoinProduct
            }
            elseif ($FilterForUpdateCategory)
            {
                $JoinFilter = $JoinCategory
            }
            $ScriptBlock = [scriptblock]::Create( $JoinFilter )

            $AllUpdateList.Where($ScriptBlock)
        }
        else
        {
            $AllUpdateList
        }
    }
    end
    {
    }
}
