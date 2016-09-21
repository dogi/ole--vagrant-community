<# 
 # Uninstalls Bonjour and Vagrant.
 # Uninstalls VirtualBox and Git, only if the user agrees.
 # If the user doesn't want to uninstall VirtualBox, then OLE VM is removed.
 # Removes desktop icon.
 #
 # TODO: Testing:
 #          - Delete ole--vagrant-bells and chocolatey
 #>

# Uninstall Bonjour
choco uninstall bonjour -y


# If the user doesn't want to remove VirtualBox, then remove OLE VM
$vb = Read-Host 'Are you sure you want to remove Virtualbox? (Y)es, (N)o'

if ($vb.ToUpper() -eq 'Y') {
    choco uninstall virtualbox -y
} else {
    vagrant box remove ole -f
}

# Only uninstall Git if the user agrees
$git = Read-Host 'Are you sure you want to remove Git? (Y)es, (N)o'

if ($git.ToUpper() -eq 'Y') {
    choco uninstall git, git.install -y
}

# Uninstall vagrant
choco uninstall vagrant -y

# Uninstall chocolatey
choco uninstall chocolatey -y

# Delete ole vagrant bells and chocolatey
"$HOME\ole--vagrant-bells", "$env:ALLUSERSPROFILE\chocolatey" | % {
    Get-ChildItem -Path $_ -Recurse | Remove-Item -Force -Recurse
    Remove-Item $_ -Force 
    }

# Remove desktop icon
Remove-Item C:\Users\*\Desktop\MyBeLL.url –Force
