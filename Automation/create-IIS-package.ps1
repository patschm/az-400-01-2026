# Create a package that will audit the configuration at 180 minute intervals
$params = @{
    Name          = 'SetupIIS'
    Configuration = './SetupIIS/localhost.mof'
    #Type          = 'AuditAndSet'
    Type          = 'Audit'
    Force         = $true
    FrequencyMinutes = 180
}
New-GuestConfigurationPackage @params