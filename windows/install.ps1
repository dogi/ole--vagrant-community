write-host "This script will install BeLL-Apps on your computer"

#Taking admin privileges
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{   
	$arguments = "& '" + $myinvocation.mycommand.definition + "'"
	Start-Process powershell -Verb runAs -ArgumentList $arguments
	Break
}

#Checking for Virtualization
$a = (Get-CimInstance -ClassName win32_processor -Property Name, SecondLevelAddressTranslationExtensions, VirtualizationFirmwareEnabled, VMMonitorModeExtensions)
$a | Format-List Name, SecondLevelAddressTranslationExtensions, VirtualizationFirmwareEnabled, VMMonitorModeExtensions
$slat = $a.SecondLevelAddressTranslationExtensions
$virtual = $a.VirtualizationFirmwareEnabled
$vmextensions = $a.VMMonitorModeExtensions
If ($slat -eq $false)
{
	"BeLL-Apps is not compatible with your system. In order to install it, you need to upgrade your CPU first."
	exit
}
Else
{
	If ($virtual -eq $false)
	{
		"Virtualization is not enabled. In order to install BeLL-Apps, you must enable it. Helpful link: http://www.howtogeek.com/213795/how-to-enable-intel-vt-x-in-your-computers-bios-or-uefi-firmware/"
		exit
	}
}

#Installs bonjour,git,virtualbox and vagrant via choco
(iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))) >$null 2>&1
RefreshEnv
choco install bonjour, git, virtualbox, vagrant -y -allowEmptyChecksums
RefreshEnv

write-host "Installation Completed. Press any key to continue..."
[void][System.Console]::ReadKey($true)
