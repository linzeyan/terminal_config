#!/usr/bin/env bash

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
RESET='\033[0m'
repoUri='https://github.com/linzeyan/terminal_config.git'
dirName="$HOME/git/terminal_config/macos"

brewPrefix="/usr/local"
if [[ "$(uname -m)" == "arm64" ]]; then
  brewPrefix="/opt/homebrew"
fi

msg() {
  echo -e "${GREEN}${1}${RESET}"
}

err() {
  echo -e "${RED}${1}${RESET}" >&2
}

installHomeBrew() {
  msg "Check homebrew is installed or not."
  if ! which brew &>/dev/null; then
    msg "Install homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    brewShellEnv='eval "$('"$brewPrefix"'/bin/brew shellenv)"'
    zProfile="$HOME/.zprofile"
    # Ensure zprofile exists
    if [[ ! -f "$zProfile" ]]; then
      touch "$zProfile"
    fi
    # Add brew shellenv only once
    if ! grep -Fxq "$brewShellEnv" "$zProfile"; then
      echo >>"$zProfile"
      echo "$brewShellEnv" >>"$zProfile"
    fi
    # Load brew into current shell if available
    if [[ -x "$brewPrefix/bin/brew" ]]; then
      eval "$("$brewPrefix/bin/brew" shellenv)"
    else
      err "brew not found at $brewPrefix/bin/brew"
      exit 1
    fi
    return 0
  fi

  msg "Update homebrew..."
  brew update
}

installPackages() {
  installHomeBrew

  mkdir -p "$HOME/git"
  if [[ ! -d "$HOME/git/terminal_config" ]]; then
    msg "Clone Config Repo"
    cd "$HOME/git" && git clone "${repoUri}"
  fi

  msg "Restore brew"
  brew bundle --file="${dirName}/Brewfile"
}

# Replaced by zshZim. Kept for reference.
# zshOMZ() {
#   if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
#     msg "Clone Oh-My-Zsh"
#     git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
#   fi
#   if [[ ! -d "${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]]; then
#     msg "Install zsh plugins ==> zsh-autosuggestions"
#     git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
#   fi
#   if [[ ! -d "${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]]; then
#     msg "Install zsh plugins ==> zsh-syntax-highlighting"
#     git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
#   fi
#   if [[ ! -d "$HOME/.git-radar" ]]; then
#     msg "Clone git-radar"
#     git clone --depth=1 https://github.com/linzeyan/git-radar.git ~/.git-radar
#   fi
# }

otherConfigs() {
  msg "Configure git global config"
  ln -sf "${dirName}/.gitconfig" "$HOME/.gitconfig"
  msg "Generate .zshrc"
  ln -sf "${dirName}/.zshrc" "$HOME/.zshrc"

  msg "Generate .vimrc"
  ln -sf "${dirName}/.vimrc" "$HOME/.vimrc"
  if [[ ! -d "$HOME/.vim/bundle/Vundle.vim" ]]; then
    msg "Clone Vundle.vim"
    git clone --depth=1 https://github.com/VundleVim/Vundle.vim.git "$HOME/.vim/bundle/Vundle.vim"
  fi
  msg "Install Vim Plugin"
  vim -c 'BundleInstall' -c 'q' -c 'q'

  msg "Symlink configs"
  ln -sf "${dirName}/.tmux.conf" "$HOME/.tmux.conf"
  ln -sf "${dirName}/.ssh" "$HOME/.ssh"
  ln -sf "${dirName}/curltime" "$HOME/curltime"
  ln -sf "${dirName}/.snipaste" "$HOME/.snipaste"

  msg "Setup lrzsz scripts"
  chmod +x "${dirName}/iterm2-zmodem/iterm2-"*
  sudo ln -sf "${dirName}/iterm2-zmodem/iterm2-"* "${brewPrefix}/bin/"

  msg "Restore mise config"
  mkdir -p "$HOME/.config/mise"
  ln -sf "${dirName}/.mise-config.toml" "$HOME/.config/mise/config.toml"
  mise install

  # msg "Accept Xcode license"
  # sudo xcodebuild -license accept
}

zshZim() {
  if [[ ! -f "$HOME/.zim/zimfw.zsh" ]]; then
    msg "Install zim"
    curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
  fi

  ln -sf "${dirName}/.zimrc" "$HOME/.zimrc"

  if [[ ! -d "$HOME/.zim/modules/powerlevel10k" ]]; then
    msg "Clone PowerLevel10k"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.zim/modules/powerlevel10k"
  fi
  msg "Install PowerLevel10k"
  export ZIM_HOME="$HOME/.zim"
  zsh "$HOME/.zim/zimfw.zsh" install
  ln -sf "${dirName}/.p10k.zsh" "$HOME/.p10k.zsh"
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
# environmentSetting
