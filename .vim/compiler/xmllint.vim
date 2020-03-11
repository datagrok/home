" Vim compiler file
" Compiler:	xmllint
" Maintainer:	Doug Kearns <djkea2@gus.gscit.monash.edu.au>
" URL:		http://gus.gscit.monash.edu.au/~djkea2/vim/compiler/xmllint.vim
" Last Change:	2004 Nov 27

if exists("current_compiler")
  finish
endif
let current_compiler = "xmllint"

let s:cpo_save = &cpo
set cpo-=C

setlocal makeprg=xmllint\ --valid\ --noout\ %

setlocal errorformat=
		    \%Z%p^,
			\%E%f:%l:\ element\ %[%^:]%#:\ error\ :\ %m,
		    \%W%f:%l:\ element\ %[%^:]%#:\ warning\ :\ %m,
		    \%E%f:%l:\ element\ %[%^:]%#:\ validity\ error\ :\ %m,
		    \%W%f:%l:\ element\ %[%^:]%#:\ validity\ warning\ :\ %m,
		    \%C%.%#

setlocal shellpipe=2>&1\|\ sed\ '/\\^$/s/\\t/\ \ \ \ \ \ \ \ /g'\ \|\ tee

let &cpo = s:cpo_save
unlet s:cpo_save
