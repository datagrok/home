if exists("current_compiler")
  finish
endif
let current_compiler = "pyflakes"

setlocal makeprg=pyflakes\ %

" import a
" import a.b <- ignore message for this
setlocal errorformat=%-G%f:%l:\ redefinition\ of\ unused\ %.%#
setlocal errorformat+=%f:%l:\ %m
