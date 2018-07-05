function Set-PSCMCIMSession
{
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER 

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [string]$SiteCode,
        [Parameter(ValueFromPipeline)]
        [string]$Computername = "localhost"
    )
    
    begin {
    }
    
    process
    {
        $CIMSessionHash = @{
            #open a CIM sesison to the ConfigMgr Server
            cimsession = New-CimSession -ComputerName $Computername
            NameSpace = "Root\SMS\Site_$SiteCode" #point to the SMS Namespace
            ErrorAction = 'Stop'
        }
        [hashtable]$CIMSessionHash
    }
    
    end {
    }
}