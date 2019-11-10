#!/usr/bin/env bash

# Adapted from
# https://github.com/pathikrit/mac-setup-script/blob/master/install.sh
# https://gist.github.com/bradp/bea76b16d3325f5c47d4

### TO DO ###

# [ ] Apply $PATH changes (see below) to all users

### APPLICATIONS ###

# Applications to be installed as casks
casks=(
  1password
  a-better-finder-attributes
  adobe-acrobat-reader
  adobe-digital-editions
  alfred
  android-studio
  arduino
  arq
  atom
  calibre
  dropbox
  epichrome
  evernote
  flowsync
  geotag
  github
  google-chrome
  java
  kindle
  microsoft-word
  microsoft-excel
  microsoft-powerpoint
  notion
  onedrive
  postman
  remember-the-milk
  slack
  slic3r
  station
  wireshark
)

# Applications to be installed as brews
brews=(
  cocoapods
  # mackup
  mas # Command-line interface for the Mac App Store
  node@10
  python
  watchman
)

# Node packages
npms=(
  react-native-cli
)

#Applications to be installed from Mac App Store
mac_apps=(
#  '918858936'   # Airmail 3
#  '1091189122'  # Bear
  '497799835'   # Xcode
)

### FUNCTIONS ###

set +e
set -x

function prompt {
  if [[ -z "${CI}" ]]; then
    read -p "Hit Enter to $1 ..."
  fi
}

function install {
  cmd=$1
  shift
  for pkg in "$@";
  do
    exec="$cmd $pkg"
    #prompt "Execute: $exec"
    if ${exec} ; then
      echo "Installed $pkg"
    else
      echo "Failed to execute: $exec"
      if [[ ! -z "${CI}" ]]; then
        exit 1
      fi
    fi
  done
}

function brew_install_or_upgrade {
  if brew ls --versions "$1" >/dev/null; then
    if (brew outdated | grep "$1" > /dev/null); then
      echo "Upgrading already installed package $1 ..."
      brew upgrade "$1"
    else
      echo "Latest $1 is already installed"
    fi
  else
    brew install "$1"
  fi
}

### EXECUTABLE ###

if [[ -z "${CI}" ]]; then
  sudo -v # Ask for the administrator password upfront
  # Keep-alive: update existing `sudo` time stamp until script has finished
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
fi

if test ! "$(command -v brew)"; then
  prompt "Install Homebrew"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  if [[ -z "${CI}" ]]; then
    prompt "Update Homebrew"
    brew update
    brew upgrade
    brew doctor
  fi
fi
export HOMEBREW_NO_AUTO_UPDATE=1

prompt "Install brews"
install 'brew_install_or_upgrade' "${brews[@]}"

prompt "Install casks"
install 'brew cask install --appdir=/Applications' "${casks[@]}"

# node@10 is keg-only, which means it is not symlinked into /usr/local,
# because this is an alternate version of another formula.
# To add node@10 to $PATH of current user:
echo 'export PATH="/usr/local/opt/node@10/bin:$PATH"' >> ~/.bash_profile
# To add node@10 to $PATH of all users:
#echo 'export PATH="/usr/local/opt/node@10/bin:$PATH"' >> /etc/profile

# For compilers to find node@10 you may need to set:
export LDFLAGS="-L/usr/local/opt/node@10/lib"
export CPPFLAGS="-I/usr/local/opt/node@10/include"

prompt "Install npms"
install 'npm install --global' "${npms[@]}"

prompt "Install apps from Mac App Store"
# Sign in to App Store
# The signin command has been temporarily disabled on macOS 10.13+
# See https://github.com/mas-cli/mas/issues/164
#mas signin --dialog vass.apple.store.ch@gmail.com
install 'mas install' "${mac_apps[@]}"

prompt "Cleanup"
brew cleanup

echo "Run [mackup restore] after Dropbox is done syncing ..."
echo "Done!"
