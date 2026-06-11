if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

eval "$(direnv hook zsh)"
eval "$(mise activate zsh)"
eval "$(zoxide init zsh)"
eval "$(tirith init --shell zsh)"

setopt HIST_IGNORE_ALL_DUPS
bindkey -e
WORDCHARS=${WORDCHARS//[\/]}

if [[ -d /opt/homebrew/share/zsh/site-functions ]]; then
  fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
fi
if [[ -d /usr/local/share/zsh/site-functions ]]; then
  fpath=(/usr/local/share/zsh/site-functions $fpath)
fi

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=cyan,bold,underline"
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
## Declare the variable
typeset -A ZSH_HIGHLIGHT_PATTERNS
typeset -A ZSH_HIGHLIGHT_STYLES
## To have commands starting with `rm` in red:
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

if [[ ! ${ZIM_HOME:=${HOME}/.zim}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
source ${ZIM_HOME}/init.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[[ -f /usr/local/bin/library.bash ]] && source /usr/local/bin/library.bash
[ -f ~/.inshellisense/key-bindings.zsh ] && source ~/.inshellisense/key-bindings.zsh

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

## To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# export PROMPT="%1/%\$(git-radar --zsh) "
# export PROMPT="%(?:%{%}➜ :%{%}➜ )%{$fg[cyan]%}%c%{$reset_color%} \$(git-radar --zsh )"

export LS_COLORS="$(vivid generate modus-vivendi)"
# for carapace https://carapace.sh/
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
source <(carapace _carapace)
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
zstyle ':completion:*:git:*' group-order 'main commands' 'alias commands' 'external commands'
alias ls="eza --icons"
alias du="diskus"
# oMLX: CLI shim path begin
case ":$PATH:" in
  *":$HOME/.omlx/bin:"*) ;;
  *) export PATH="$HOME/.omlx/bin:$PATH" ;;
esac
# oMLX: CLI shim path end
# oMLX: persisted base path override
export OMLX_BASE_PATH="/Users/ricky/git/mlx-dir/.omlx"

# pnpm
export PNPM_HOME="/Users/ricky/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end

# mise / homebrew 共享的 GitHub Token，提升 API 速率限制
# export GITHUB_TOKEN="ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

agent() {
  ANTHROPIC_BASE_URL='http://0.0.0.0:8000' \
  ANTHROPIC_AUTH_TOKEN='dummy' \
  ANTHROPIC_DEFAULT_OPUS_MODEL='Qwen3-Next-80B-A3B-Thinking-8bit' \
  ANTHROPIC_DEFAULT_SONNET_MODEL='Qwen3-Coder-30B-A3B-Instruct-8bit' \
  ANTHROPIC_DEFAULT_HAIKU_MODEL='gemma-4-31b-it-4bit' \
  API_TIMEOUT_MS=3000000 \
  CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1 \
  claude "$@"
}
