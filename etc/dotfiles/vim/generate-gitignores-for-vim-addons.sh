#!/bin/sh

# I want git to ignore any files in ~/.vim that are placed there by the
# vim-addons utility. This will generate a list of files to be merged into
# ~/.vim/.gitignore.

set -e
cd ~/.vim
(
	echo '.VimballRecord'
	echo '.netrwhist'
	cat /usr/share/vim/registry/*.yaml | sed -n '/^\s\+-\s\+/{s/^\s\+-\s\+//;p}'
	cat .gitignore
) | sort | uniq > .gitignore.new
mv .gitignore.new .gitignore
