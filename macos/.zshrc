if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
setopt HIST_IGNORE_ALL_DUPS
bindkey -e
WORDCHARS=${WORDCHARS//[\/]}
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
source ${ZIM_HOME}/init.zsh
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
zmodload -F zsh/terminfo +p:terminfo
if [[ -n ${terminfo[kcuu1]} && -n ${terminfo[kcud1]} ]]; then
  bindkey ${terminfo[kcuu1]} history-substring-search-up
  bindkey ${terminfo[kcud1]} history-substring-search-down
fi
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
ZSH_DISABLE_COMPFIX=true
# ZSH_THEME="robbyrussell"
# CASE_SENSITIVE="true"
# HYPHEN_INSENSITIVE="true"
# DISABLE_LS_COLORS="true"
# DISABLE_AUTO_TITLE="true"
# DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="yyyy-mm-dd"
plugins=()
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=cyan,bold,underline"
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
# Declare the variable
typeset -A ZSH_HIGHLIGHT_PATTERNS
typeset -A ZSH_HIGHLIGHT_STYLES
# To have commands starting with `rm` in red:
ZSH_HIGHLIGHT_PATTERNS+=('rm -f' 'fg=white,bold,bg=red')
ZSH_HIGHLIGHT_PATTERNS+=('rm -r' 'fg=white,bold,bg=red')
ZSH_HIGHLIGHT_PATTERNS+=('rm -rf' 'fg=white,bold,bg=red')
ZSH_HIGHLIGHT_PATTERNS+=('rm -fr' 'fg=white,bold,bg=red')
ZSH_HIGHLIGHT_PATTERNS+=('sudo *' 'fg=white,bold,bg=red')
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=red,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=yellow,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[cursor]='bg=blue'
# ZSH_HIGHLIGHT_STYLES[line]='bold'
# export LANG=en_US.UTF-8
export GOPATH=${HOME}/.go
alias gitdiff='git diff | git-split-diffs --color | less -RFX'
alias gitlog='git log -p | git-split-diffs --color | less -RFX'
alias list_npm_package='npm list -g --depth=0'
alias colorPrint='for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+"\n"}; done'
# pip zsh completion start
function _pip_completion {
  local words cword
  read -Ac words
  read -cn cword
  reply=( $( COMP_WORDS="$words[*]" \
             COMP_CWORD=$(( cword-1 )) \
             PIP_AUTO_COMPLETE=1 $words[1] 2>/dev/null ))
}
compctl -K _pip_completion pip3
# pip zsh completion end
alias proxy="
    export http_proxy=socks5://127.0.0.1:9050;
    export HTTP_PROXY=socks5://127.0.0.1:9050;
    export https_proxy=socks5://127.0.0.1:9050;
    export HTTPS_PROXY=socks5://127.0.0.1:9050;
    export SSH_proxy=socks5://127.0.0.1:9050;
    export SSH_PROXY=socks5://127.0.0.1:9050;
    export all_proxy=socks5://127.0.0.1:9050;
    export ALL_PROXY=socks5://127.0.0.1:9050;
    export no_proxy=socks5://127.0.0.1:9050;
    export NO_PROXY=socks5://127.0.0.1:9050;"
alias unproxy="
    unset http_proxy;
    unset HTTP_PROXY;
    unset https_proxy;
    unset HTTPS_PROXY;
    unset ssh_proxy;
    unset SSH_PROXY;
    unset all_proxy;
    unset ALL_PROXY;
    unset no_proxy;
    unset NO_PROXY"
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
#export PROMPT="%1/%\$(git-radar --zsh) "
#export PROMPT="%(?:%{%}➜ :%{%}➜ )%{$fg[cyan]%}%c%{$reset_color%} \$(git-radar --zsh )"
alias backup_brew='brew bundle dump --describe --force --file="~/git/terminal_config/macos/Brewfile"'
alias restore_brew='brew bundle --file="~/git/terminal_config/macos/Brewfile"'
alias flushdns='sudo killall -HUP mDNSResponder;sudo killall mDNSResponderHelper;sudo dscacheutil -flushcache'
alias port_listen='lsof -PRlni4TCP|awk /LISTEN/'
alias port_established='lsof -PRlni4TCP|awk /ESTABLISHED/'
alias localip='for ip in $(ifconfig -l);do addr=$(ipconfig getifaddr ${ip});if [ "$(ipconfig getifaddr $ip;echo $?)" != 1 ];then echo $ip: $addr;fi;done'
alias routing='netstat -rf inet'
alias weather='curl wttr.in'
alias oracle='ssh opc@129.146.172.132'
alias changeMACaddress='networksetup -setairportpower en0 off && networksetup -setairportpower en0 on && sudo ifconfig en0 ether 14:7d:da:aa:46:53 && sleep 5 && networksetup -setairportnetwork en0 Tstar5 && ifconfig en0 | grep ether | awk "{print \$2}"'
alias restoreMACaddress='networksetup -setairportpower en0 off && networksetup -setairportpower en0 on && sudo ifconfig en0 ether f0:18:98:3c:c5:89 && sleep 5 && networksetup -setairportnetwork en0 Tstar5 && ifconfig en0 | grep ether | awk "{print \$2}"'
alias sudo='/usr/local/bin/sudo'
alias tojson='yq eval -j'
alias toyaml='yq eval -P'
if [[ $(uname -s) == "Darwin" ]]; then
  export PATH=${PATH}:${HOME}/Library/Python/3.9/bin:/usr/local/sbin:${GOPATH}/bin
  # The next line updates PATH for the Google Cloud SDK.
  . "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
  ## The next line enables shell command completion for gcloud.
  . "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

fi
autoCompletion='/usr/local/share/zsh/site-functions'
alias k='kubectl'
alias kctx='kubectx'
alias kns='kubens'
[[ -f ${autoCompletion}/_kubectl ]] || kubectl completion zsh >${autoCompletion}/_kubectl
compinit
