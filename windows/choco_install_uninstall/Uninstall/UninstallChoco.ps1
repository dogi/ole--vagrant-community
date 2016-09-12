<# 
 # TODO: Handle possible errors
 # TODO: Remove directory C:\ProgramData\chocolatey
 # TODO: Remove the following environment variables from the Path:
 #        - ChocolateyInstall
 #        - ChocolateyBinRoot
 #        - ChocolateyToolsLocation
 #        - PATH (will need updated to remove)
 #       The script provided at https://chocolatey.org/docs/uninstallation 
 #       doesn't seem safe, so check if there is any other solution.
 # TODO: remove Bonjour and Putty (if we will add them)
 #>
choco uninstall git, git.install, virtualbox, vagrant -y
choco uninstall chocolatey -y
