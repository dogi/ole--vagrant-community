<#
 # TODO: Handle possible errors
 #>
(iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))) >$null 2>&1
RefreshEnv
choco install bonjour, putty, git, virtualbox, vagrant -y -allowEmptyChecksums
RefreshEnv
