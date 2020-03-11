# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install

# The following lines were added by compinstall
zstyle :compinstall filename '/home/mike/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

source ~/.bash_aliases

function ps1_context {
	# For any of these bits of context that exist, display them and append a
	# space.
	virtualenv=`basename "$VIRTUAL_ENV"`
	for v in "$debian_chroot" "$virtualenv" "$PS1_CONTEXT"; do
		echo -n "${v:+$v }"
	done
}

function ps1_curdir {
		if [ "$VIRTUAL_ENV" ]; then
			p="${PWD/$VIRTUAL_ENV/♬}"
		else
			p="${PWD}"
		fi
		echo "${p/$HOME/~}"
}

setopt PROMPT_SUBST
[ -e  ~/mnt/jellydoughnut/lib/med/med.plugin.zsh ] && source ~/mnt/jellydoughnut/lib/med/med.plugin.zsh

# from man zsh-betaall
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn hg
#zstyle ':vcs_info:*' actionformats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{3}%a%F{5}]%f '
#zstyle ':vcs_info:*' formats       '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
#zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{2}:%F{3}%r'
precmd () {
	vcs_info
	ps1_context_v=$(ps1_context)
	ps1_curdir_v=$(ps1_curdir)
}
PS1='${vcs_info_msg_0_} ${ps1_context_v}%B%F{$PS1_HOSTCOLOR}%n@%m%f:%F{blue}${ps1_curdir_v}%f%b%# '

# Always fall back to filename completion
zstyle ':completion:*' completer _expand _complete _files # _correct #_approximate
