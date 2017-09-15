#!/bin/bash

#check if `brew` is installed
MAN_BREW=`man brew`
if [ "$MAN_BREW" = "" ]; then
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
#if not install it
CHECK_GIT=`brew list | grep git`
if [ "$CHECK_GIT" = "" ]; then
	brew install git
fi

CHECK_VARGANT=`brew cask list | grep vagrant`
if [ "$CHECK_VARGANT" = "" ]; then	
	brew cask install vagrant
fi
CHECK_VIRTUALBOX=`brew cask list | grep virtualbox`
if [ "$CHECK_VIRTUALBOX" = "" ]; then
	brew cask install virtualbox
fi

cd ~
git clone https://github.com/hikaruit15/ole--vagrant-community.git
cd ole--vagrant-community
vagrant up

# create LaunchAgents if it doesn't exist
mkdir -p /Users/${USER}/Library/LaunchAgents

# start machine when user logins 
cp ~/ole--vagrant-community/macosx/com.ole.virtualboxboot.plist /Users/${USER}/Library/LaunchAgents/

#place Icon into Dock
CHECK_BELL_APP='defaults read com.apple.dock persistent-apps | grep BellCommunity.app'
if [ "$CHECK_BELL_APP" = "" ]; then
	cp ~/ole--vagrant-community/macosx/BellCommunity.app /Applications/
	defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/BellCommunity.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
fi

# Reset Dock
killall Dock

