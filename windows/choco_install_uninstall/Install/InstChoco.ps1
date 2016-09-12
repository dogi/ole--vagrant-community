<#
 # TODO: Handle possible errors
 # TODO: Add Bonjour and Putty (?)
 #>
(iex ((new-object net-webclient).DownloadString('https://chocolatey.org/install.ps1'))) >$null 2>&1
RefreshEnv
choco install git, virtualbox, vagrant -y -allowEmptyChecksums
RefreshEnv
