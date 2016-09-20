<#
 # TODO: Add virtualization check
 # TODO: Handle possible installation errors
 # TODO: Testing:
 #          - Start Vagrant at Startup
 #          - Start the VM
 #>

<#
 ############## TODO: Add virtualization check ##############
 #>

# Install Chocolatey
(iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))) >$null 2>&1
# Add Chocolatey to the Path
RefreshEnv

# Install the other required programs
choco install bonjour, git, virtualbox, vagrant -y -allowEmptyChecksums
# Add programs to the Path
RefreshEnv

<#
 ############# TODO: Handle possible installation errors ###############
 #>

# Git clone OLE Vagrant Community
$gituser = Read-Host "Please, enter your GitHub username, or press Enter to continue:"
if ($gituser -eq "") {$gituser = "dogi"}
cd $HOME
git clone https://github.com/$gituser/ole--vagrant-community.git
cd .\ole--vagrant-community

<# 
 # Add OLE Vagrant Community to Startup Folder (this is actually unnecessary, since we're adding 
 # a scheduled job to run Vagrant at startup)
 #>

<# 
 # $StartUp="$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
 # New-Item -ItemType SymbolicLink -Path "$StartUp" -Name "BeLL_App.lnk" -Value "$HOME\ole--vagrant-community"
 #>

# Open ports on network
New-NetFirewallRule -DisplayName "Allow Outbound Port 5984 CouchDB/HTTP" -Direction Outbound –LocalPort 5984 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "Allow Inbound Port 5984 CouchDB/HTTP" -Direction Inbound –LocalPort 5984 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "Allow Outbound Port 6984 CouchDB/HTTPS" -Direction Outbound –LocalPort 6984 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "Allow Inbound Port 6984 CouchDB/HTTPS" -Direction Inbound –LocalPort 6984 -Protocol TCP -Action Allow

# Start Vagrant at Startup
$trigger = New-JobTrigger -AtStartup -RandomDelay 00:01:00
Register-ScheduledJob -Trigger $trigger -FilePath $HOME\ole--vagrant-community/windows/vagrantup.ps1 -Name VagrantUp -ExecutionPolicy Bypass

# Create a desktop icon
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut("$HOME\Desktop\MyBeLL.lnk")
$Shortcut.TargetPath = "http://127.0.0.1:5984/apps/_design/bell/MyApp/index.html"
$Shortcut.IconLocation = "$HOME/ole--vagrant-community/windows/Bell_logo.ico, 0"
$Shortcut.Description = "My BeLL App"
$Shortcut.Save()

# Start the VM
& ((Split-Path $MyInvocation.MyCommand.Path) + "vagrantup.ps1") -ExecutionPolicy Bypass
Write-Host The installation is complete.
