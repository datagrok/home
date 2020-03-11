#!/bin/false # This file is sourced, not executed, by zsh for login shells.

setopt nonomatch
source ~/.profile
setopt nomatch
function ps1_context {
	# For any of these bits of context that exist, display them and append a
	# space.
	virtualenv=`basename "$VIRTUAL_ENV"`
	for v in "$debian_chroot" "$virtualenv" "$PS1_CONTEXT"; do
		echo -n "${v:+$v }"
	done
	# Take advantage of the fricken awesome tools from
	# /etc/bash_completion.d/git
	__git_ps1 "±%s "
}

function ps1_curdir {
		p="${PWD/$VIRTUAL_ENV/♬}"
		echo "${p/$HOME/~}"
}
# "$(ps1_context) $(ps1_curdir) "
