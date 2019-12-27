function Get-PSCMLicenseKey {
    <#
    .SYNOPSIS
    Gets license key from registry for SCCM

    .DESCRIPTION
    Say you work at a place with no documentation and no one else knows what the license key might be...

    .PARAMETER ComputerName
    Name of sccm server

    .EXAMPLE
    Get-PSCMLicenseKey -ComputerName seraph

    .NOTES
    General notes

    .LINK
    http://eddiejackson.net/wp/?p=22166
    #>

    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory)]
        [string]
        $ComputerName
    )

    begin {
        $map = "BCDFGHJKMPQRTVWXY2346789"
        $productkey = ""
    }

    process {
        if ($ComputerName -eq $env:COMPUTERNAME) {
            #need to test for these paths first
            $Value = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\System Center Configuration Manager\2012\Registration").digitalproductid[0x34..0x42]
            $Version = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\SMS\Setup")."Full Version"
        }
        elseif ($ComputerName -ne $env:COMPUTERNAME) {
            if (Test-Connection -ComputerName $ComputerName -Count 1 -Quiet -ErrorAction Stop) {
                $Value = Invoke-Command -ComputerName $ComputerName -ScriptBlock { (get-itemproperty  "HKLM:\SOFTWARE\Microsoft\System Center Configuration Manager\2012\Registration").digitalproductid[0x34..0x42] }
                $Version = Invoke-Command -ComputerName $ComputerName -ScriptBlock { (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\SMS\Setup")."Full Version" }
            }
            else {
                Write-Error -Exception "Could not connect"
            }
        }

        if ($Null -ne $Value) {
            for ($i = 24; $i -ge 0; $i--) {
                $r = 0
                for ($j = 14; $j -ge 0; $j--) {
                    $r = ($r * 256) -bxor $value[$j]
                    $value[$j] = [math]::Floor([double]($r/24))
                    $r = $r % 24
                }
                $ProductKey = $map[$r] + $productkey
                if (($i % 5) -eq 0 -and $i -ne 0) {
                    $productkey = "-" + $productkey
                }
            }
        }
        else {
            Write-Error -Message "Could not determine key"
        }

        [PSCustomObject]@{
            SCCMServer = $ComputerName
            Version    = $Version
            ProductKey = $ProductKey
        }
    }

    end {

    }
}