# Install the machine configuration DSC resource module from PowerShell Gallery
Install-Module -Name GuestConfiguration

# Get a list of commands for the imported GuestConfiguration module
Get-Command -Module GuestConfiguration

# Install PSDesiredStateConfiguration version 2.0.7 (the stable release)
Install-Module -Name PSDesiredStateConfiguration -RequiredVersion 2.0.7
Import-Module -Name PSDesiredStateConfiguration

# Get a list of commands for the imported PSDesiredStateConfiguration module
Get-Command -Module PSDesiredStateConfiguration