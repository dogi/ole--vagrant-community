# Windows scripts

## Installation

- Vagrant and VirtualBox
  - Filename: `TentativePythonFile.py`  
  - What it does: Downloads and installs *Vagrant* and *VirtualBox*.

- Vagrant autostart
  - Filename: `start_vagrant_on_boot.bat`  
  - What it does: Adds *Vagrant* to Windows Startup folder.

- Bonjour and PuTTY
  - Filename: `bonjour_putty_installation.bat`  
  - What it does: Downloads *Bonjour* and *PuTTY* and installs *Bonjour*.
  
- Network Ports
  - Filename: `open_ports_on_network.bat`  
  - What it does: Opens 5984 and 6984 TCP ports.
  
- Desktop Icon
  - Filename: `create_desktop_icon.bat`  
  - What it does: Creates a desktop shortcut of the BeLL-App and puts `Bell_logo.ico` as the file icon. 

## Uninstallation
  
- VirtualBox and Vagrant
  - Filename: `git_uninstaller.bat`   
  - What it does: Removes *VirtualBox* and *Vagrant* and also calls `vm_destroyer.bat` and `git_uninstaller.bat`.

* Virtual machine *community*
  - Filename: `vm_destroyer.bat`  
  - What it does: Destroys *community* VM.

* Git
  - Filename: `git_uninstaller.bat`  
  - What it does: Uninstalls *Git*.


