# Install

To install a BeLL-Apps community on your system (x86 or amd64 architecture) just follow the instruction of your Operating System:

## Windows

```
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/dogi/ole--vagrant-community/master/windows/install.bat', 'install.bat')" && start install.bat
```
Paste that at a [Command prompt](http://www.howtogeek.com/235101/10-ways-to-open-the-command-prompt-in-windows-10/).

## MacOSX

```
/usr/bin/bash -e "$(curl -fsSL https://raw.githubusercontent.com/dogi/ole--vagrant-community/master/macosx/install.sh)"
```

## Ubuntu

```
/usr/bin/bash -e "$(curl -fsSL https://raw.githubusercontent.com/dogi/ole--vagrant-community/master/ubuntu/install.sh)"
```
