"" Uncomment this if this plugin somehow lands in a
"" system-wide dir or the vim distribution.
" if exists("current_compiler")
"   finish
" endif
" let current_compiler = 'javac'

""This is necessarry for 'older vims,' not mine though.
" if exists(":CompilerSet") != 2
" 	command -nargs=* CompilerSet setlocal <args>
" endif

if filereadable("Makefile")
	CompilerSet makeprg=make\ 2>&1\ \\\|\ vim-javac-filter
else
	CompilerSet makeprg=javac\ %\ 2>&1\ \\\|\ vim-javac-filter
endif

" Use with sed filter vim-javac-filter:
" #!/bin/sed -f
" /\^$/s/\t/\ /g;/:[0-9]\+:/{h;d};/^[ \t]*\^/G;
CompilerSet errorformat=%Z%f:%l:\ %m,%A%p^,%-G%*[^slfr]%.%#
" The format of a simple error from javac looks like this.
" Note the tab characters (because I use them in my source)
" in the beginning of the listing line and pointer line:
" 
" 	ExampleClass.java:2: cannot find symbol
" 	symbol  : class err
" 	location: class ExampleClass
" 	^Ipublic ExampleClass(err e) { }
" 	^I                    ^
" 	1 error
" 
" The errorformat in $VIMURUNTIME/compiler/javac is: >
" 	:setl efm=%A%f:%l:\ %m,%-Z%p^,%-C%.%#,%-G%.%#
" While the ones in the help file read: >
" 	:setl efm=%A%f:%l:\ %m,%-Z%p^,%-C%.%#
" 	:setl efm=%A%f:%l:\ %m,%+Z%p^,%+C%.%#,%-G%.%#
" Mine reads: >
" 	:setl efm=%Z%f:%l:\ %m,%A%p^,%-G%*[^sl]%.%#
