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
        if($null -eq (Get-Module ConfigurationManager))
        {
            Import-Module (Join-Path $(Split-Path $env:SMS_ADMIN_UI_PATH) ConfigurationManager.psd1) -ErrorAction Stop -Verbose:$VerboseOpt -Force
        }
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
