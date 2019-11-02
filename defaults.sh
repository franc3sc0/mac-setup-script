#!/usr/bin/env bash

# Adapted from https://github.com/pathikrit/mac-setup-script/blob/master/defaults.sh

### MANUAL SETTINGS ###

# Hostname:
# System Preferences > Sharing > Computer Name

### SCRIPTED SETTINGS ###

set -x

if [[ -z "${CI}" ]]; then
  sudo -v # Ask for the administrator password upfront
  # Keep-alive: update existing `sudo` time stamp until script has finished
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
fi

# Close any open System Preferences panes, to prevent them from overriding settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Create users
sudo sysadminctl -addUser francesco -fullName "Francesco Vass" -picture "/Library/User Pictures/Animals/Penguin.tif"
sudo sysadminctl -addUser francesca -fullName "Francesca Vass" -picture "/Library/User Pictures/Fun/Smack.tif"
sudo sysadminctl -addUser matteo -fullName "Matteo Vass" -picture "/Library/User Pictures/Sports/Basketball.png"
sudo sysadminctl -addUser cecilia -fullName "Cecilia Vass" -picture "/Library/User Pictures/Nature/Cactus.tif"

# Disable the sound effects on boot
#sudo nvram SystemAudioVolume=" "

# Setting trackpad & mouse speed to a reasonable number
#defaults write -g com.apple.trackpad.scaling 2
defaults write -g com.apple.mouse.scaling 1

### GLOBAL SETTINGS ###

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Disable auto corrections
#defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false      # Disable automatic capitalization
#defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false    # Disable smart dashes
#defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false  # Disable automatic period substitution
#defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false   # Disable smart quotes
#defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false  # Disable auto-correct

# Enable full keyboard access for all controls e.g. enable Tab in modal dialogs
#defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

### USER-SPECIFIC SETTINGS ###

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Reveal IP address, hostname, OS version, etc. when clicking the clock in the login window
#sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName


# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
#defaults write com.apple.finder QuitMenuItem -bool true

# Set Desktop as the default location for new Finder windows
#defaults write com.apple.finder NewWindowTarget -string "PfDe"
#defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"

# Set Dropbox folders as the default location for new Finder windows
defaults write com.apple.finder NewWindowTargetPath -string "file:///Volumes/Data/Bck/Dropbox/"

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Set the icon size of Dock items
defaults write com.apple.dock tilesize -int 36

# Set Dock to auto-hide
defaults write com.apple.dock autohide -bool true

# Move Dock to left
defaults write com.apple.dock orientation -string "left"

# Removing the Dock's auto-hiding delay
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0

#defaults write com.apple.finder AppleShowAllFiles -bool true        # Finder: Show hidden files by default
#defaults write NSGlobalDomain AppleShowAllExtensions -bool true     # Finder: Show all filename extensions
#defaults write com.apple.finder ShowStatusBar -bool true            # Finder: Show status bar
#defaults write com.apple.finder ShowPathbar -bool true              # Finder: Show path bar
#defaults write com.apple.finder _FXShowPosixPathInTitle -bool true  # Finder: Display full POSIX path as window title
#defaults write com.apple.finder _FXSortFoldersFirst -bool true      # Finder: Keep folders on top when sorting by name
chflags nohidden ~/Library     # Show the ~/Library folder
#sudo chflags nohidden /Volumes # Show the /Volumes folder

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Automatically open a new Finder window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# Use list view in all Finder windows by default (codes for the other view modes: `icnv`, `clmv`, `Flwv`)
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
	General -bool true \
	OpenWith -bool true \
	Privileges -bool true

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Visualize CPU usage in the Activity Monitor Dock icon
defaults write com.apple.ActivityMonitor IconType -int 5

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0
