Write-Host This script will install your BeLL App community.
Write-Host Asking for admin privileges. Please`, accept any prompt that may pop up. -ForegroundColor Yellow

# Take admin privileges
if (! ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
          [Security.Principal.WindowsBuiltInRole] "Administrator")) {   
	$arguments = "& '" + $myinvocation.mycommand.definition + "'"
	Start-Process powershell -Verb runAs -ArgumentList $arguments
	Break
}

Write-Host Please`, wait while we check if your computer is compatible with BeLL App... -ForegroundColor Yellow

# Set ExecutionPolicy to Bypass
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine -Force

#Check for Virtualization
$a = (Get-CimInstance -ClassName win32_processor -Property Name, 
                      SecondLevelAddressTranslationExtensions, VirtualizationFirmwareEnabled, VMMonitorModeExtensions)
$a | Format-List Name, SecondLevelAddressTranslationExtensions, VirtualizationFirmwareEnabled, VMMonitorModeExtensions
$slat = $a.SecondLevelAddressTranslationExtensions
$virtual = $a.VirtualizationFirmwareEnabled
$vmextensions = $a.VMMonitorModeExtensions
if ($slat -eq $false) {
    Write-Host BeLL-Apps is not compatible with your system. In order to install it, you need to upgrade your CPU first. -ForegroundColor Yellow
    pause
    exit
} else {
	if ($virtual -eq $false) {
        Write-Host Virtualization is not enabled. In order to install BeLL-Apps, you must enable it. `
        Helpful link: http://www.howtogeek.com/213795/how-to-enable-intel-vt-x-in-your-computers-bios-or-uefi-firmware/ -ForegroundColor Yellow
        pause
        exit
	}
}

Write-Host Your computer is compatible! -ForegroundColor Magenta
Write-Host Please`, wait while BeLL App is being installed... -ForegroundColor Yellow

# Install Chocolatey
(iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))) >$null 2>&1
# Add Chocolatey to the Path
RefreshEnv

# Install the other required programs
choco install bonjour, git, virtualbox, vagrant, firefox -y -allowEmptyChecksums
# Add programs to the Path
RefreshEnv

#### Paranoid Check ####
# Check if bonjour, git, virtualbox, vagrant, firefox have actually been installed
$progs = New-Object System.Collections.ArrayList
$prog = ""
if (! (Test-Path "C:\Program File*\*\firefox.exe")) {
    $progs.Add("Firefox")
}
if (! (Test-Path "C:\HashiCorp\*\*\vagrant.exe")) {
    $progs.Add("Vagrant")
}
if (! (Test-Path "C:\Program File*\*\*\virtualbox.exe")) {
    $progs.Add("Virtualbox")
}
if (! (Test-Path "C:\Program File*\*\*\git.exe")) {
    $progs.Add("Git")
}
if (! (Test-Path "C:\Program File*\*\mDNSResponder.exe")) {
    $progs.Add("Bonjour")
}

# Add word separator for printing
$progs | % {$prog += ($(if($prog){" and "}) + $_)}
if ($progs.Count -eq 1) {$verb, $pron = "is", "it"}
else {$verb, $pron = "are", "them"}

# If any of the programs was not installed, ask the user to install them manually before continuing
if ($progs.Count -gt 0) {
    Write-Host "                ================================================================================================`
               | Unfortunately`, $prog could not be installed.`
               | Please`, BEFORE pressing Enter to continue, 
               | make sure that $prog $verb installed (install $pron manually, if necessary). 
                ================================================================================================" -ForegroundColor Yellow
    pause
}
#### End Paranoid Check ####

# Git clone OLE Vagrant Community
$gituser = Read-Host "Please, enter your GitHub username, or press Enter to continue:"
if ($gituser -eq "") {$gituser = "dogi"}
cd $HOME
& 'C:\Program Files\Git\bin\git.exe' clone https://github.com/$gituser/ole--vagrant-community.git
cd .\ole--vagrant-community

# Open ports on network
New-NetFirewallRule -DisplayName "Allow Outbound Port 5984 CouchDB/HTTP" -Direction Outbound –LocalPort 5984 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "Allow Inbound Port 5984 CouchDB/HTTP" -Direction Inbound –LocalPort 5984 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "Allow Outbound Port 6984 CouchDB/HTTPS" -Direction Outbound –LocalPort 6984 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "Allow Inbound Port 6984 CouchDB/HTTPS" -Direction Inbound –LocalPort 6984 -Protocol TCP -Action Allow

# Start Vagrant at Startup
$trigger = New-JobTrigger -AtStartup -RandomDelay 00:00:30
Register-ScheduledJob -Trigger $trigger -FilePath $HOME\ole--vagrant-community\windows\vagrantup.ps1 -Name VagrantUp

# Create a desktop icon
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut("$HOME\Desktop\MyBeLL.lnk")
if (Test-Path 'C:\Program Files (x86)\Mozilla Firefox') {
    $Shortcut.TargetPath = "C:\Program Files (x86)\Mozilla Firefox\firefox.exe"
} else {
    $Shortcut.TargetPath = "C:\Program Files\Mozilla Firefox\firefox.exe"
}
$Shortcut.IconLocation = "$HOME\ole--vagrant-community\windows\Bell_logo.ico, 0"
$Shortcut.Arguments = "http://127.0.0.1:5984/apps/_design/bell/MyApp/index.html"
$Shortcut.Description = "My BeLL App"
$Shortcut.Save()

# Start the VM
& ((Split-Path $MyInvocation.MyCommand.Path) + "\vagrantup.ps1")
