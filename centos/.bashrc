if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
export PS1="\u(\W)\$(git-radar --bash) "
alias agent='eval $(ssh-agent)'
