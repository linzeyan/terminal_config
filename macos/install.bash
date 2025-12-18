#!/usr/bin/env bash

set -ex

GREEN='\033[0;32m'
RESET='\033[0m'
repoUri='https://github.com/linzeyan/terminal_config.git'
dirName="$HOME/git/terminal_config/macos"

msg() {
  echo "${GREEN}${1}${RESET}"
}

installHomeBrew() {
  msg "Check homebrew is installed or not."
  if ! which brew &> /dev/null; then
    msg "Install homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    brewPrefix="/usr/local"
    if [[ "$(uname -m)" == "arm64" ]]; then
      brewPrefix="/opt/homebrew"
    fi
    brewShellEnv='eval "$('"$brewPrefix"'/bin/brew shellenv)"'
    zProfile="$HOME/.zprofile"
    # Ensure zprofile exists
    if [[ ! -f "$zProfile" ]]; then
      touch "$zProfile"
    fi
    # Add brew shellenv only once
    if ! grep -Fxq "$brewShellEnv" "$zProfile"; then
      echo >> "$zProfile"
      echo "$brewShellEnv" >> "$zProfile"
    fi
    # Load brew into current shell if available
    if [[ -x "$brewPrefix/bin/brew" ]]; then
      eval "$("$brewPrefix/bin/brew" shellenv)"
    else
      echo "❌ brew not found at $brewPrefix/bin/brew"
      exit 1
    fi
    return 0
  fi

  msg "Update homebrew..."
  brew update
}

installPackages() {
  installHomeBrew

  mkdir -p $HOME/git
  if [[ ! -d "$HOME/git/terminal_config" ]]; then
    msg "Clone Config Repo"
    cd $HOME/git && git clone ${repoUri}
  fi

  msg "Restore brew"
  brew bundle --file="${dirName}/Brewfile"

  msg "Install Fira-code"
  brew install font-fira-code-nerd-font

  # msg "GPG"
  # brew install pinentry-mac
  # mkdir -p ~/.gnupg
  # echo 'no-tty' >~/.gnupg/gpg.conf
  # echo 'pinentry-program /usr/local/bin/pinentry-mac' > ~/.gnupg/gpg-agent.conf
}

zshOMZ() {
  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    msg "Clone Oh-My-Zsh"
    git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
  fi
  if [[ ! -d "${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]]; then
    msg "Install zsh plugins == > zsh-autosuggestions"
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  fi
  if [[ ! -d "${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]]; then
    msg "Install zsh plugins == > zsh-syntax-highlighting"
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  fi
  if [[ ! -d "$HOME/.git-radar" ]]; then
    msg "Clone git-radar"
    git clone --depth=1 https://github.com/linzeyan/git-radar.git ~/.git-radar
  fi
}

otherConfigs() {
  msg "Configure git global config"
  ln -s ${dirName}/.gitconfig ~/.gitconfig
  msg "Generate .zshrc"
  ln -s ${dirName}/.zshrc ~/.zshrc
  msg "Generate .vimrc"
  ln -s ${dirName}/.vimrc ~/.vimrc
  git clone --depth=1 https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  # git clone --depth=1 https://github.com/chr4/nginx.vim ~/.vim/bundle/nginx.vim
  msg "Install Vim Plugin"
  vim -c 'BundleInstall' -c 'q' -c 'q'
  msg "Copy configs"
  ln -s ${dirName}/.tmux.conf ~/.tmux.conf
  ln -s ${dirName}/.ssh ~/.ssh
  ln -s ${dirName}/curltime ~/curltime
  ln -s ${dirName}/.snipaste ~/.snipaste
  msg "Copy lrzsz scripts"
  chmod +x ${dirName}/iterm2-zmodem/iterm2-*
  sudo ln -s ${dirName}/iterm2-zmodem/iterm2-* /usr/local/bin/
  sudo xcodebuild -license accept
}

zshZim() {
  if [[ ! -d "$HOME/.zim/zimfw.zsh" ]]; then
    msg "Install zim"
    curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
  fi

  ln -s ${dirName}/.zimrc ~/.zimrc

  if [[ ! -d "$HOME/.zim/modules/powerlevel10k" ]]; then
    msg "Clone PowerLevel10k"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.zim/modules/powerlevel10k
  fi
  msg "Install PowerLevel10k"
  . $HOME/.zim/zimfw.zsh install
  ln -s ${dirName}/.p10k.zsh ~/.p10k.zsh
}

environmentSetting() {
  # 自動隱藏 Dock
  defaults write com.apple.dock autohide -bool true
  # Tap to click
  defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
  defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  # 三指拖曳
  defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
  # 關閉在 Dock 中顯示最近使用過的應用程式
  defaults write com.apple.dock show-recents -bool false
  # 關閉最近的文件
  defaults write com.apple.recentitems RecentDocuments -int 0
  # 關閉四個角落的熱點
  defaults write com.apple.dock wvous-tl-corner -int 0
  defaults write com.apple.dock wvous-tr-corner -int 0
  defaults write com.apple.dock wvous-bl-corner -int 0
  defaults write com.apple.dock wvous-br-corner -int 0
  # 桌面背景圖片改為黑色
  osascript -e 'tell application "System Events" to set picture of desktop 1 to "/System/Library/Desktop Pictures/Solid Colors/Black.png"'
  # 24 小時制
  defaults write NSGlobalDomain AppleICUForce24HourTime -bool true
  # 自動切換至文件的輸入方式
  defaults write com.apple.HIToolbox AppleInputSourceHistory -bool true
  # 預設網頁瀏覽器改為 Google Chrome
  defaults write ~/Library/Preferences/com.apple.LaunchServices/com.apple.launchservices.secure.plist LSHandlers -array-add \
    '{ LSHandlerContentType = "public.html"; LSHandlerRoleAll = "com.google.Chrome"; }'

  defaults write ~/Library/Preferences/com.apple.LaunchServices/com.apple.launchservices.secure.plist LSHandlers -array-add \
    '{ LSHandlerContentType = "public.url"; LSHandlerRoleAll = "com.google.Chrome"; }'

  defaults write ~/Library/Preferences/com.apple.LaunchServices/com.apple.launchservices.secure.plist LSHandlers -array-add \
    '{ LSHandlerURLScheme = "http"; LSHandlerRoleAll = "com.google.Chrome"; }'

  defaults write ~/Library/Preferences/com.apple.LaunchServices/com.apple.launchservices.secure.plist LSHandlers -array-add \
    '{ LSHandlerURLScheme = "https"; LSHandlerRoleAll = "com.google.Chrome"; }'

  # 重建 Launch Services 資料庫
  /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user
  # 登出
  osascript -e 'tell application "System Events" to log out'
}

installPackages
zshZim
otherConfigs
environmentSetting
