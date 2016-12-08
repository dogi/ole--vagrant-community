#!/bin/bash

#check if `brew` is installed
MAN_BREW=`man brew`
if [ "$MAN_BREW" = "" ]; then
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
#if not install it

brew install git
brew cask install vagrant
brew cask install virtualbox

cd ~
git clone https://github.com/dogi/ole--vagrant-community.git
cd ole--vagrant-community
vagrant up

#sudo bash macosx/installvagrantboot.sh

#place Icon into Dock
mv ~/BellCommunity.app /Applications/
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/BellCommunity.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
# Reset Dock
killall Dock

