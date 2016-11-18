Function Get-ComputerInformation
{
    [CmdletBinding()]
    PARAM (
        [Parameter(ValueFromPipeline)]
        $ComputerName = $env:COMPUTERNAME
    )
    PROCESS
    {
        Write-Verbose -Message "$ComputerName"
        
        # Computer System
        $ComputerSystem = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $ComputerName
        # Operating System
        $OperatingSystem = Get-WmiObject -class win32_OperatingSystem -ComputerName $ComputerName
        # BIOS
        $Bios = Get-WmiObject -class win32_BIOS -ComputerName $ComputerName
        
        # Prepare Output
        Write-Verbose -Message "$ComputerName - Preparing output"
        $Properties = @{
            ComputerName = $ComputerName
            Manufacturer = $ComputerSystem.Manufacturer
            Model = $ComputerSystem.Model
            OperatingSystem = $OperatingSystem.Caption
            OperatingSystemVersion = $OperatingSystem.Version
            SerialNumber = $Bios.SerialNumber
        } #Properties
        
        # Output Information
        Write-Verbose -Message "$ComputerName - Output Information"
        New-Object -TypeName PSobject -Property $Properties
    } #PROCESS
} #Function

