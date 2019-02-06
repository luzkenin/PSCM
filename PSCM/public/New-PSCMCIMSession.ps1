function New-PSCMCIMSession
{
    <#
    .SYNOPSIS
    Generates hash for CIMSession
    .DESCRIPTION
    Generates hash for CIMSession.
    .PARAMETER SiteCode
    SCCM Site Code
    .PARAMETER Computername
    SCCM Server name
    .EXAMPLE
    $CIMSession = New-PSCMCIMSession -SiteCode PRI -ComputerName SCCMServer
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Hashtable])]
    param (
        [Parameter(Mandatory)]
        [string]$SiteCode,
        [Parameter()]
        [string]$Computername = (get-cmsite).servername
    )

    begin
    {
    }

    process
    {
        if ($PSCmdlet.ShouldProcess("Creating CIM session hash"))
        {
            $CIMSessionHash = @{
                cimsession  = New-CimSession -ComputerName $Computername
                NameSpace   = "Root\SMS\Site_$SiteCode"
                ErrorAction = 'Stop'
            }
            [hashtable]$CIMSessionHash
        }
    }

    end
    {
    }
}
