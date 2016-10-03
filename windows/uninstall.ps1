Write-Host This script will uninstall BeLL App from your computer. -ForegroundColor Magenta

Write-Host Asking for admin privileges. Please`, accept any prompt that may pop up. -ForegroundColor Magenta

# Run as Admin
if (! ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
       [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Break
}

Write-Host Uninstalling Bonjour... -ForegroundColor Magenta

# Uninstall Bonjour
choco uninstall bonjour -y


# Remove VirtualBox, OLE community VM, and OLE community box,
# only if the user agrees
Write-Host 'Are you sure you want to remove Virtualbox? (Y)es, (N)o' -ForegroundColor Magenta
$vb = Read-Host

if ($vb.ToUpper() -eq 'Y') {
    Write-Host Uninstalling Virtualbox... -ForegroundColor Magenta
    choco uninstall virtualbox -y
}
  
Write-Host 'Do you want to remove the virtual machine? (Y)es, (N)o' -ForegroundColor Magenta
$vm = Read-Host

if ($vm.ToUpper() -eq 'Y') {
    Write-Host Removing the virtual machine... -ForegroundColor Magenta
    C:\HashiCorp\Vagrant\bin\vagrant.exe destroy community -f
}

Write-Host 'Do you want to remove also all the files? (Y)es, (N)o' -ForegroundColor Magenta
$box = Read-Host

if ($box.ToUpper() -eq 'Y') {
    Write-Host Removing all the files... -ForegroundColor Magenta
    C:\HashiCorp\Vagrant\bin\vagrant.exe box remove ole/jessie64 -f
}

# Only uninstall Git if the user agrees
Write-Host 'Are you sure you want to remove Git? (Y)es, (N)o' -ForegroundColor Magenta
$git = Read-Host

if ($git.ToUpper() -eq 'Y') {
    Write-Host Unintalling Git... -ForegroundColor Magenta
    choco uninstall git, git.install -y
}

# Uninstall vagrant
Write-Host Uninstalling Vagrant... -ForegroundColor Magenta
choco uninstall vagrant -y

# Only uninstall Firefox if the user agrees
Write-Host 'Are you sure you want to remove Firefox? (Y)es, (N)o' -ForegroundColor Magenta
$ff = Read-Host

if ($ff.ToUpper() -eq 'Y') {
    Write-Host Uninstalling Firefox... -ForegroundColor Magenta
    choco uninstall firefox -y
}

# Uninstall chocolatey
Write-Host Uninstalling Chocolatey... -ForegroundColor Magenta
choco uninstall chocolatey -y

# Remove ole--vagrant-community and chocolatey folder and subfolders
Write-Host Removing BeLL App... -ForegroundColor Magenta
"$HOME\ole--vagrant-community", "$env:ALLUSERSPROFILE\chocolatey" | % {
    Get-ChildItem -Path $_ -Recurse | Remove-Item -Force -Recurse
    Remove-Item $_ -Force -Recurse
    }

# Close ports on network
Write-Host 'Are you sure you want your firewall to block port 5984? (Y)es, (N)o' -ForegroundColor Magenta
$fw5984 = Read-Host

if ($fw5984.ToUpper() -eq 'Y') {
    New-NetFirewallRule -DisplayName "Block Outbound Port 5984 CouchDB/HTTP" -Direction Outbound -LocalPort 5984 -Protocol TCP -Action Block
    New-NetFirewallRule -DisplayName "Block Inbound Port 5984 CouchDB/HTTP" -Direction Inbound -LocalPort 5984 -Protocol TCP -Action Block
    Write-Host Port `5984 blocked. -ForegroundColor Magenta
}

Write-Host 'Are you sure you want your firewall to block port 6984? (Y)es, (N)o' -ForegroundColor Magenta
$fw6984 = Read-Host

if ($fw6984.ToUpper() -eq 'Y') {
    New-NetFirewallRule -DisplayName "Block Outbound Port 6984 CouchDB/HTTPS" -Direction Outbound -LocalPort 6984 -Protocol TCP -Action Block
    New-NetFirewallRule -DisplayName "Block Inbound Port 6984 CouchDB/HTTPS" -Direction Inbound -LocalPort 6984 -Protocol TCP -Action Block
    Write-Host Port `6984 blocked. -ForegroundColor Magenta
}

# Remove vagrant job from Startup
Unregister-ScheduledJob VagrantUp -Force

# Remove desktop icon
Remove-Item C:\Users\*\Desktop\MyBeLL.lnk -Force

Write-Host All done! Your BeLL App has been removed. -ForegroundColor Magenta
Write-Host You can now close this window. -ForegroundColor Magenta
