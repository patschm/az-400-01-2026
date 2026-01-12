# First run setup-dsc.ps1
# Next run this script to create te mof file
# Then create a configuration package: Create-IIS-Packaged.ps1

Configuration SetupIIS
{
    #Import-DscResource -ModuleName PsDesiredStateConfiguration
    Import-Module -Name PSDesiredStateConfiguration
    Node 'localhost'
    {
        WindowsFeature WebServer
        {
            Ensure = 'Present'
            Name = 'Web-Server'
            IncludeAllSubFeature = $true
        }
    }
}

SetupIIS