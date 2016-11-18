Function Get-ComputerInformation
{
    
    [CmdletBinding(DefaultParameterSetName='Default', 
                   SupportsShouldProcess=$true, 
                   PositionalBinding=$false,
                   HelpUri = 'https://github.com/MSAdministrator/Hands_On_Hacking_Demo_2016',
                   ConfirmImpact='Medium')]
     [Alias()]
     [OutputType([System.Collections.Hashtable])]
    PARAM (
        [Parameter(ValueFromPipeline=$true,
                    Mandatory=$true,
                    Position=0,
                    ParameterSetName='Default',
                    HelpMessage = 'Please provide a computer name')]
        [Alias('Host', 'MachineName', 'Name')]
        [ValidateScript({Test-Connection -ComputerName $_ -Quiet -Count 1})]
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
        if ($pscmdlet.ShouldProcess($ComputerName))
         {
         
            foreach ($item in $ComputerName)
            {
                Write-Verbose -Message "Gathering information about $item"
        
                try 
                {
                    # Computer System
                    $ComputerSystem = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $item
                }
                catch [System.Exception] 
                {
                    write-Error -Message "Error trying to gather ComputerSystem information about $item"
                    continue
                }


                try 
                {
                    # Operating System
                    $OperatingSystem = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $item
                }
                catch [System.Exception] 
                {
                    write-Error -Message "Error trying to gather OperatingSystem information about $item"
                    continue
                }


                try
                {
                    # BIOS
                    $Bios = Get-WmiObject -class win32_BIOS -ComputerName $item
                }
                catch [System.Exception] 
                {
                    write-Error -Message "Error trying to gather BIOS information about $item"
                    continue
                }

                # Prepare Output
                Write-Verbose -Message "$item - Preparing output"

                $Properties = [ordered]@{
                    ComputerName = $item
                    Manufacturer = $ComputerSystem.Manufacturer
                    Model = $ComputerSystem.Model
                    OperatingSystem = $OperatingSystem.Caption
                    OperatingSystemVersion = $OperatingSystem.Version
                    SerialNumber = $Bios.SerialNumber
                } #Properties
        
                # Output Information
                Write-Verbose -Message "$item - Output Information"

                $TempObject = New-Object -TypeName PSCustomObject -Property $Properties
                $ReturnObject += $TempObject
            }
        }
    } #PROCESS
    END
    {
        return $ReturnObject
    }
} #Function

