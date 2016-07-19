import urllib
import os
import sys


def reporthook(blocknum, blocksize, totalsize):
    readsofar = blocknum * blocksize
    if totalsize > 0:
        percent = readsofar * 1e2 / totalsize
        s = "\r%5.1f%% %*d / %d" % (
            percent, len(str(totalsize)), readsofar, totalsize)
        sys.stderr.write(s)
        if readsofar >= totalsize: # near the end
            sys.stderr.write("\n")
    else: # total size is unknown
        sys.stderr.write("read %d\n" % (readsofar,))
        
vagrantPath = "C:\Users\user\Documents\Downloads\vagrant_185.msi"
virtualBoxPath = "C:/Users/user/Documents/Downloads/VirtualBox.exe"
urlVagrant = 'https://releases.hashicorp.com/vagrant/1.8.5/vagrant_1.8.5.msi'
urlVirtualBox = 'http://download.virtualbox.org/virtualbox/5.1.0/VirtualBox-5.1.0-108711-Win.exe'
urllib.urlretrieve(urlVagrant, vagrantPath, reporthook)
urllib.urlretrieve(urlVirtualBox, virtualBoxPath, reporthook)
os.system("C:/Users/user/Documents/Downloads/vagrant_185.msi", )
print("Opening Vagrant Installer")
os.system("C:/Users/user/Documents/Downloads/VirtualBox.exe")
print("Opening Virtual Box Installer")


try:
    from pywinauto import application
except ImportError:
    pywinauto_path = os.path.abspath(__file__)
    pywinauto_path = os.path.split(os.path.split(pywinauto_path)[0])[0]
    sys.path.append(pywinauto_path)
    from pywinauto import application

commands=r'msiexec.exe /i ' + vagrantPath
vagrantApp= application.Application().Start(commands)
while True:
    try:
        vagrantApp['Vagrant Setup']['Next'].Click()
    except:
        continue
    break
vagrantApp['Vagrant Setup']['I accept the terms in the License Agreement'].CheckByClick()
vagrantApp['Vagrant Setup']['Next'].Click()
vagrantApp['Vagrant Setup']['Next'].Click()
vagrantApp['Vagrant Setup']['Install'].Click()
virtualBoxApp = application.Application().start(virtualBoxPath)
virtualBoxApp['Oracle VM VirtualBox 5.1.0 Setup']['&Next >'].Click()
virtualBoxApp['Oracle VM VirtualBox 5.1.0 Setup']['&Next >'].Click()
virtualBoxApp['Oracle VM VirtualBox 5.1.0 Setup']['&Next >'].Click()
virtualBoxApp['Oracle VM VirtualBox 5.1.0 Setup']['Yes'].Click()
virtualBoxApp['Oracle VM VirtualBox 5.1.0 Setup']['Install'].Click()
