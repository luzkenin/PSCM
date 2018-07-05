function Connect-PSCMServer {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        $SiteCode,
        [Parameter(Mandatory, ValueFromPipeline)] 
        $ProviderMachineName,
        [switch]$VerboseOpt
    )
    
    begin
    {
        if((Get-Module ConfigurationManager) -eq $null)
        {
            Import-Module (Join-Path $(Split-Path $env:SMS_ADMIN_UI_PATH) ConfigurationManager.psd1) -ErrorAction Stop -Verbose:$VerboseOpt -Force
        }
    }
    
    process
    {
        if((Get-PSDrive -Name $SiteCode -PSProvider CMSite -ErrorAction SilentlyContinue) -eq $null)
        {
            New-PSDrive -Name $SiteCode -PSProvider CMSite -Root $ProviderMachineName -ErrorAction Stop -Verbose:$VerboseOpt
        }

        Set-Location "$($SiteCode):\" -ErrorAction Stop -Verbose:$VerboseOpt
    }
    end
    {
    }
}