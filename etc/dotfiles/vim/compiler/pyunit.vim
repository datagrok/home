" Vim compiler file
" Compiler:	Unit testing tool for Python
" Maintainer:	Max Ischenko <mfi@ukr.net>
" Last Change: 2004 Mar 27

if exists("current_compiler")
  finish
endif
let current_compiler = "pyunit"

if filereadable("alltests.py")
	setlocal makeprg=python3\ alltests.py
elseif filereadable("Makefile")
	setlocal makeprg=make
else
	setlocal makeprg=python3\ %
endif

" This doesn't quite work
"setlocal errorformat=
"	\%E%.%.%#Error\:\ %m,
"	\%Z\ \ File\ \"%f\"\\\,\ line\ %l%.%#,
"	\%I\ \ File\ \"%f\"\\\,\ line\ %l\\\,%m,
"	\%Z\ \ \ \ %.%#,
"	\%-G%.%#

" From stock pyunit.vim
"setlocal errorformat=
"	\%A\ \ File\ \"%f\"\\\,\ line\ %l%.%#,
"	\%C\ \ \ \ %.%#,
"	\%Z%[%^\ ]%\\@=%m
"

" From python.vim
setlocal errorformat=
	\%A\ \ File\ \"%f\"\\\,\ line\ %l\\\,%m,
	\%C\ \ \ \ %.%#,
	\%+Z%.%#Error\:\ %.%#,
	\%A\ \ File\ \"%f\"\\\,\ line\ %l,
	\%+C\ \ %.%#,
	\%-C%p^,
	\%Z%m,
	\%-G%.%#
