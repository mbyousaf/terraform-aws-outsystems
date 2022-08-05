[CmdletBinding()]
param(
    [Parameter()]
    [string]$OSPlatformVersion = "${PlatformVersion}",
    [string]$OSServiceStudioVersion = "${DevelopmentVersion}",
    [string]$OSInstallDir = 'C:\OutSystems'
)

#Create Log directory for Shell Script
New-Item -Path "c:\" -Name "InstallLogging" -ItemType "directory"
Start-Transcript -Path "C:\InstallLogging\"
New-Item "C:\InstallLogging\output.txt"

# -- Stop on any error
$ErrorActionPreference = 'Stop'

# -- Import module from Powershell Gallery
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force  | Out-File -FilePath "C:\InstallLogging\output.txt" -Append

#Set OS repo to trusted so no popups appear
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted | Out-File -FilePath "C:\InstallLogging\output.txt" -Append

Install-Module -Name Outsystems.SetupTools -Force | Out-File -FilePath "C:\InstallLogging\output.txt" -Append
Import-Module -Name Outsystems.SetupTools -ArgumentList $true, 'AzureRM' | Out-Null

# -- Check HW and OS for compability
Test-OSServerHardwareReqs -MajorVersion 11 | Out-File -FilePath "C:\InstallLogging\output.txt" -Append
Test-OSServerSoftwareReqs -MajorVersion 11 | Out-File -FilePath "C:\InstallLogging\output.txt" -Append

# -- Install PreReqs
Install-OSServerPreReqs -MajorVersion 11 | Out-File -FilePath "C:\InstallLogging\output.txt" -Append
Install-OSServer -Verbose -Version $(Get-OSRepoAvailableVersions -MajorVersion 11 -Latest -Application 'PlatformServer') | Out-File -FilePath "C:\InstallLogging\output.txt" -Append
Install-OSServiceStudio -Version $OSServiceStudioVersion | Out-File -FilePath "C:\InstallLogging\output.txt" -Append

# Start configuration tool
#Write-Output "Launching the configuration tool... "
#& "$OSInstallDir\Platform Server\ConfigurationTool.exe"
#[void](Read-Host 'Configure the platform and press Enter to continue the OutSystems setup...')

#Configure Windows Firewall to allow traffic
Set-OSServerWindowsFirewall -IncludeRabbitMQ | Out-File -FilePath "C:\InstallLogging\output.txt" -Append 

# -- Install service center and publish system components
#Install-OSPlatformServiceCenter -Verbose -ErrorAction Stop | Out-File -FilePath "C:\InstallLogging\output.txt" -Append 


#Publish-OSPlatformSystemComponents -Verbose -ErrorAction Stop | Out-File -FilePath "C:\InstallLogging\output.txt" -Append 

# -- Apply system tunning and security settings
#Set-OSServerPerformanceTunning -Verbose -ErrorAction Stop | Out-File -FilePath "C:\InstallLogging\output.txt" -Append
#Set-OSServerSecuritySettings -Verbose -ErrorAction Stop | Out-File -FilePath "C:\InstallLogging\output.txt" -Append