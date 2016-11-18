Function Get-ComputerInformation
{
    [CmdletBinding()]
    PARAM (
        [Parameter(ValueFromPipeline=$true,
                    Mandatory=$true,
                    Position=0,
                    ParameterSetName='Default',
                    HelpMessage = 'Please provide a computer name')]
        [Alias('Host', 'MachineName', 'Name')]
        $ComputerName = $env:COMPUTERNAME
        
        #Other Parameter Conditions that can be used
          #ValueFromPipelineByPropertyName
          #ValueFromRemainingArguments
        #Parameter and Variable Validation Attributes
          #[AllowNull()]
          #[AllowEmptyString()]
          #[AllowEmptyCollection()]
          #[ValidateCount=(1,5)]
          #[ValidateLength=(1,10)]
          #[ValidatePattern("[0-9][0-9][0-9][0-9]")]
          #[ValidateRange(0,10)]
          #[ValidateScript({$_ -ge (get-date)})]
          #[ValidateSet("Low", "Average", "High")]
          #[ValidateNotNull()]
          #[ValidateNotNullOrEmpty()]
          
    )
    BEGIN
    {
        Write-Verbose -Message "Attempting to Get-ComputerInformation"
        $ReturnObject = @()
    }
    PROCESS
    {
        foreach ($item in $ComputerName)
        {
            Write-Verbose -Message "Gathering information about $ComputerName"
        
            try 
            {
                # Computer System
                $ComputerSystem = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $ComputerName
            }
            catch [System.Exception] 
            {
                write-Error -Message "Error trying to gather ComputerSystem information about $ComputerName"
                continue
            }


            try 
            {
                # Operating System
                $OperatingSystem = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $ComputerName
            }
            catch [System.Exception] 
            {
                write-Error -Message "Error trying to gather OperatingSystem information about $ComputerName"
                continue
            }


            try
            {
                # BIOS
                $Bios = Get-WmiObject -class win32_BIOS -ComputerName $ComputerName
            }
            catch [System.Exception] 
            {
                write-Error -Message "Error trying to gather BIOS information about $ComputerName"
                continue
            }

            # Prepare Output
            Write-Verbose -Message "$ComputerName - Preparing output"

            $Properties = [ordered]@{
                ComputerName = $ComputerName
                Manufacturer = $ComputerSystem.Manufacturer
                Model = $ComputerSystem.Model
                OperatingSystem = $OperatingSystem.Caption
                OperatingSystemVersion = $OperatingSystem.Version
                SerialNumber = $Bios.SerialNumber
            } #Properties
        
            # Output Information
            Write-Verbose -Message "$ComputerName - Output Information"

            $TempObject = New-Object -TypeName PSCustomObject -Property $Properties
            $ReturnObject += $TempObject

        }
    } #PROCESS
    END
    {
        return $ReturnObject
    }
} #Function

