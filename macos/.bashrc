# System-wide .bashrc file for interactive bash(1) shells.
if [ -z "$PS1" ]; then
   return
fi

source /usr/local/etc/bash_completion.d/git-prompt.sh
source /usr/local/etc/bash_completion.d/git-completion.bash
export PATH=$PATH:$HOME/.git-radar
export CLICOLOR="true"
export LSCOLORS="gxfxcxdxcxegedabagacad"
GIT_PS1_SHOWCOLORHINTS=1
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWUPSTREAM=verbose
GIT_PS1_DESCRIBE_STYLE=branch
#PROMPT_COMMAND='__git_ps1 "\u@\h:\W" " \\\$ ""\n\[\033[0;95m\]➽ \[\033[0m\]"'
PS1='\u@\h \w'
export GIT_RADAR_COLOR_BRANCH="\\033[0;93m"
PS1="$PS1\$(git-radar --bash) \\033[1;91m✗\[\033[0m\] \n\[\033[1;95m\]➜\\[\033[0m\] "
alias ll="ls -lhAF"
alias flushdns="sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder;"
alias port_listen='lsof -n -i4TCP|awk /LISTEN/'
alias port_established='lsof -n -i4TCP|awk /ESTABLISHED/'
# Make bash check its window size after a process completes
shopt -s checkwinsize
[ -r "/etc/bashrc_$TERM_PROGRAM" ] && . "/etc/bashrc_$TERM_PROGRAM"
