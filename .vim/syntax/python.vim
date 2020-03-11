
" Hilight python docstrings like python comments, not strings.
" from http://www.mail-archive.com/vim_use@googlegroups.com/msg06545.html
syn match  pythonBlock		":$" nextgroup=pythonDocString skipempty skipwhite
syn region pythonDocString	matchgroup=Normal start=+[uU]\='+ end=+'+ skip=+\\\\\|\\'+ contains=pythonEscape,@Spell contained
syn region pythonDocString	matchgroup=Normal start=+[uU]\="+ end=+"+ skip=+\\\\\|\\"+ contains=pythonEscape,@Spell contained
syn region pythonDocString	matchgroup=Normal start=+[uU]\="""+ end=+"""+ contains=pythonEscape,@Spell contained
syn region pythonDocString	matchgroup=Normal start=+[uU]\='''+ end=+'''+ contains=pythonEscape,@Spell contained
hi def link pythonDocString	Comment

" Hilight trailing whitespace as error
match Error /\s\+\%#\@<!$/
