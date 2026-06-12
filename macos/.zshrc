# ==================================================
# Powerlevel10k Instant Prompt (必須在最頂端)
# ==================================================
## 加速 zsh 啟動速度，在其他設定載入前先顯示 Prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# ==================================================

# ==================================================
# 系統環境變數與 FPATH 設定 (必須在所有補全/框架載入前)
# ==================================================
## Homebrew (Apple Silicon) 的 Completion 路徑
if [[ -d /opt/homebrew/share/zsh/site-functions ]]; then
  fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
fi
## Homebrew (Intel Mac) 的 Completion 路徑
if [[ -d /usr/local/share/zsh/site-functions ]]; then
  fpath=(/usr/local/share/zsh/site-functions $fpath)
fi
# ==================================================

# ==================================================
# Zsh 核心內建設定
# ==================================================
setopt HIST_IGNORE_ALL_DUPS # 歷史紀錄去重複
setopt INTERACTIVE_COMMENTS # 允許在命令中使用 # 作為註解

bindkey -e # 使用 Emacs Key Binding

## 將 "/" 從 WORDCHARS 移除
## 讓 Ctrl+W 刪除路徑時能以目錄為單位刪除
WORDCHARS=${WORDCHARS//[\/]}

## 載入終端機按鍵定義
zmodload -F zsh/terminfo +p:terminfo
# ==================================================

# ==================================================
# Zim 框架與主題載入
# ==================================================
## 初始化 Zim Framework
## 若 .zimrc 比 init.zsh 新則重新產生設定
if [[ ! ${ZIM_HOME:=${HOME}/.zim}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi

## 載入 Zim
source ${ZIM_HOME}/init.zsh
## 載入 Powerlevel10k 主題
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# ==================================================

# ==================================================
# 套件詳細設定 (如高亮、補全樣式)
# ==================================================
## zsh-autosuggestions 建議文字樣式
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=cyan,bold,underline"
## 啟用 zsh-syntax-highlighting 高亮器
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

## 宣告 Pattern 與 Style 變數
typeset -A ZSH_HIGHLIGHT_PATTERNS
typeset -A ZSH_HIGHLIGHT_STYLES

## ZSH_HIGHLIGHT_PATTERNS
## 危險指令高亮顯示 避免誤刪除檔案
ZSH_HIGHLIGHT_PATTERNS+=('rm -f'  'fg=white,bold,bg=red')
ZSH_HIGHLIGHT_PATTERNS+=('rm -r'  'fg=white,bold,bg=red')
ZSH_HIGHLIGHT_PATTERNS+=('rm -rf' 'fg=white,bold,bg=red')
ZSH_HIGHLIGHT_PATTERNS+=('rm -fr' 'fg=white,bold,bg=red')
ZSH_HIGHLIGHT_PATTERNS+=('sudo *' 'fg=white,bold,bg=red') # sudo 指令高亮

## ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan' # 路徑顏色
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=magenta,bold' # 保留字顏色
### 括號層級顏色
ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=red,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=yellow,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[cursor]='bg=blue' # 游標所在文字背景色
# ZSH_HIGHLIGHT_STYLES[line]='bold' # 整行加粗

## Completion 提示格式
zstyle ':completion:*' menu select # 當有多個候選項時，顯示選單
zstyle ':completion:*' group-name '' # 保留補全結果群組機制，允許群組名稱顯示
zstyle ':completion:*' group-order \
  'commands' \
  'aliases' \
  'functions' \
  'parameters' \
  'files'
zstyle ':completion:*' format $'\e[2;37m%d\e[m' # 群組標題顯示格式
# ==================================================

# ==================================================
# 外部工具與 CLI 載入 (Evals & Sources)
# ==================================================
eval "$(direnv hook zsh)" # direnv：進入目錄時自動載入 .envrc
eval "$(mise activate zsh)" # mise：管理多版本 Runtime（Node.js、Python、Go 等）
eval "$(zoxide init zsh)" # zoxide：智慧型 cd，根據使用頻率快速跳轉目錄
eval "$(tirith init --shell zsh)" # tirith：Shell 助手

## 載入 Inshellisense 鍵盤快捷鍵
[ -f ~/.inshellisense/key-bindings.zsh ] && source ~/.inshellisense/key-bindings.zsh

## carapace 補全系統
## 支援 zsh / fish / bash / inshellisense
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
source <(carapace _carapace)


# ==================================================
# 歷史紀錄搜尋快捷鍵綁定
# ==================================================

## ↑ ↓ 使用 history-substring-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

## 根據終端機設定綁定上下鍵
if [[ -n ${terminfo[kcuu1]} && -n ${terminfo[kcud1]} ]]; then
  bindkey ${terminfo[kcuu1]} history-substring-search-up
  bindkey ${terminfo[kcud1]} history-substring-search-down
fi

## Ctrl+P / Ctrl+N 搜尋歷史紀錄
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

## Vi Normal Mode 的 j/k 搜尋歷史紀錄
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

## 讓 Option + 左右鍵可以跳單字
bindkey '^[[1;3C' forward-word  # Option + →
bindkey '^[[1;3D' backward-word # Option + ←
# ==================================================

# ==================================================
# 環境變數、別名 (Alias) 與自訂函式
# ==================================================
## Prompt 自訂範例
# export PROMPT="%1/%\$(git-radar --zsh) "
# export PROMPT="%(?:%{%}➜ :%{%}➜ )%{$fg[cyan]%}%c%{$reset_color%} \$(git-radar --zsh )"

## 使用 vivid 產生 LS_COLORS 配色
export LS_COLORS="$(vivid generate modus-vivendi)"

alias ls="eza --icons" # ls 改用 eza
alias du="diskus" # du 改用 diskus（速度更快）

## 載入自訂函式庫
[[ -f /usr/local/bin/library.bash ]] && source /usr/local/bin/library.bash


## 指定 oMLX 資料儲存目錄
export OMLX_BASE_PATH="$HOME/git/mlx-dir/.omlx"

# 將 oMLX CLI Shim 加入 PATH
case ":$PATH:" in
  *":$HOME/.omlx/bin:"*) ;;
  *) export PATH="$HOME/.omlx/bin:$PATH" ;;
esac

## pnpm 安裝路徑
export PNPM_HOME="$HOME/Library/pnpm"

# 將 pnpm 加入 PATH
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac

# 提供給 mise / Homebrew 共用
# 可提高 GitHub API Rate Limit
# export GITHUB_TOKEN="ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

## Claude Code Wrapper
agent() {
  ANTHROPIC_BASE_URL='http://0.0.0.0:8000' \
  ANTHROPIC_AUTH_TOKEN='dummy' \
  ANTHROPIC_DEFAULT_OPUS_MODEL='Qwen3-Next-80B-A3B-Thinking-8bit' \
  ANTHROPIC_DEFAULT_SONNET_MODEL='Qwen3-Coder-30B-A3B-Instruct-8bit' \
  ANTHROPIC_DEFAULT_HAIKU_MODEL='gemma-4-31b-it-4bit' \
  API_TIMEOUT_MS=3000000 \
  CLAUDE_CODE_AUTO_COMPACT_WINDOW=400000 \
  CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1 \
  claude "$@"
}
