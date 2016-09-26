# Start the VM
Write-Host Starting BeLL App...
vagrant up
$str = vagrant global-status
$strArr = @($str.Split(" "))
if ($strArr.Item(($strArr.IndexOf("virtualbox")+1)) -eq "running") {
    Write-Host You can now click on the MyBeLL icon on your desktop to launch your BeLL App.
} else {
    Write-Host Your BeLL App virtual machine doesn`'t seem to be running properly. 
}

<# The following code is issuing the command "vagrant resume" if the VM is in a saved state,
 # or "vagrant up" if it is in a poweroff state. However, according to the Vagrant documentation,
 # "vagrant up" can be issued after the VM has been suspended, halted, or even destroyed 
 # (see https://www.vagrantup.com/docs/getting-started/teardown.html).
 # Thus, the following code should be unnecessary.
 #>

<#
 # $str = vagrant global-status
 # $strArr = @($str.Split(" "))
 # if ($strArr.Item(($strArr.IndexOf("virtualbox")+1)) -ne "saved") {
 #     Write-Host Starting BeLL App from powered down state...
 #     vagrant up
 # } else {
 #     Write-Host Starting BeLL App from saved state...
 #     vagrant resume
 # }
 # if ($? -eq 0) {
 #     Write-Host The BeLL App is unresponsive.
 # } else {
 #     Write-Host You can now click on the BeLL App icon on your desktop to launch your BeLL App.
 # }
 #>
