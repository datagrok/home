#!/bin/false # This file is sourced, not executed, by ~/.bashrc and ~/.zshrc
echo "Sourcing ~/.bash_aliases"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	# This calls 'export LS_COLORS=...'
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

if [ "$DISPLAY" -a ! "$SSH_CONNECTION" ]; then
	alias e='emacsclient -nw -c -a ""'
else
  alias e='emacsclient -nw -c -a ""'
fi

alias smbclient="smbclient -A .smb/auth"
alias svngvimdiff="svn diff --diff-cmd gvimdiff-svn-wrapper"
alias gitgvimdiff="GIT_EXTERNAL_DIFF=gvimdiff-git-diff-wrapper git diff"

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

[ -x /usr/bin/lbzip2 ] && alias bzip2='lbzip2'

alias gpg='gpg2'
