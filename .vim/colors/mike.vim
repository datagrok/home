" Vim color file
" Maintainer:	 Michael F. Lamb http://datagrok.org
" Last Change:	

" Base hilight colors: Cursor CursorColumn CursorIM CursorLine DiffAdd
" DiffChange DiffDelete DiffText Directory ErrorMsg FoldColumn Folded
" IncSearch LineNr MatchParen ModeMsg MoreMsg NonText Normal Pmenu PmenuSbar
" PmenuSel PmenuThumb Question Search SignColumn SpecialKey SpellBad SpellCap
" SpellLocal SpellRare StatusLine StatusLineNC TabLine TabLineFill TabLineSel
" Title VertSplit Visual VisualNOS WarningMsg WildMenu

" 'gvim -u NONE' has also 'lCursor' and omits 'CursorIM'.

let colors_name = "mike"

" Set 'background' back to the default.	The value can't
" always be estimated and is then guessed.
"hi clear Normal
"set bg&

" Remove all existing highlighting and set the defaults.
"hi clear

" Load the syntax highlighting defaults, if it's enabled.
if exists("syntax_on")
    syntax reset
endif

" Debian colors:
"#d70751 debian red
"#d78d07 orange
"#51d707 green
"#07d78d cyan
"#0751d7 blue
"#8d07d7 purple

" Lighter versions:
"#f82671 "Light deb red
"#f8ad26 "light orange
"#71f826 "light green
"#26f8ad "light cyan
"#2671f8 "light blue
"#ad26f8 "light purple

" Lighter yet:
"#fa6499 "exlight debred
"#fac464 "exlight orange
"#99fa64 "exlight green
"#64fac4 "exlight ctyan
"#6499fa "exlight blue
"#c464fa "exlight purple
"
"cterms
"	 0	 0	Black
"	 1	 4	DarkBlue
"	 2	 2	DarkGreen
"	 3	 6	DarkCyan
"	 4	 1	DarkRed
"	 5	 5	DarkMagenta
"	 6	 3	Brown, DarkYellow
"	 7	 7	LightGray, LightGrey, Gray, Grey
"	 8	 0*	DarkGray, DarkGrey
"	 9	 4*	Blue, LightBlue
"	 10	2*	Green, LightGreen
"	 11	6*	Cyan, LightCyan
"	 12	1*	Red, LightRed
"	 13	5*	Magenta, LightMagenta
"	 14	3*	Yellow, LightYellow
"	 15	7*	White

"			cterm		ctermfg		ctermbg		guifg		guibg		gui
if has("gui_running")
    if &background == "dark"
	" gvim dark
        hi Normal							guifg=Grey90	guibg=Grey10
        hi NonText			ctermfg=Grey			guifg=Grey35			gui=NONE
        hi Cursor			ctermfg=Black	ctermbg=White	guifg=bg	guibg=fg
        hi CursorLine							guibg=Grey15
        hi ErrorMsg	cterm=reverse	ctermfg=Red			guifg=bg	guibg=#d70751
        hi Pmenu					ctermbg=Grey	guifg=bg	guibg=fg
        hi PmenuSel					ctermbg=Red			guibg=#d70751
        hi Search	cterm=reverse	ctermfg=Red			guifg=bg	guibg=#d70751
        hi StatusLine			ctermfg=Grey 			guifg=Grey40
        hi StatusLineNC			ctermfg=Grey 			guifg=Grey25
        hi Title			ctermfg=Red 			guifg=#d70751
        hi Directory			ctermfg=Red			guifg=#d70751
        hi Visual					ctermbg=Grey			guibg=Grey25
        hi WarningMsg	cterm=reverse	ctermfg=Yellow			guifg=bg	guibg=#d78d07
        hi MatchParen	cterm=reverse	ctermfg=Red			guifg=bg	guibg=#d70751
        " For syntax hilighting
        hi Statement			ctermfg=Red			guifg=#d70751 "debian red
        hi Constant			ctermfg=Yellow			guifg=#d78d07 "orange
        hi Special			ctermfg=Green			guifg=#51d707 "green
        hi Identifier			ctermfg=Cyan			guifg=#07d78d "cyan
        hi PreProc			ctermfg=Blue			guifg=#0751d7 "blue
        hi Type				ctermfg=Magenta			guifg=#8d07d7 "purple
        hi Underlined	cterm=underline					guifg=NONE
    else
	" gvim light
        hi Normal	guifg=Grey10	guibg=Grey90
        hi NonText	guifg=Grey65	gui=NONE
        hi Cursor	guifg=bg	guibg=fg
        hi CursorLine	guibg=Grey85
        hi ErrorMsg	guifg=bg	guibg=#d70751
        hi Pmenu	guifg=bg	guibg=fg
        hi PmenuSel	guibg=#d70751
        hi Search	 	 guifg=bg	guibg=#d70751
        hi StatusLine	guifg=Grey60
        hi StatusLineNC	 	guifg=Grey75
        hi Title	guifg=#d70751
        hi Directory	guifg=#d70751
        hi Visual	guibg=Grey75
        hi WarningMsg	guifg=bg	guibg=#d78d07
        hi MatchParen	guifg=bg	guibg=#d70751
        " For syntax hilighting
        hi Statement	guifg=#d70751 "debian red
        hi Constant		guifg=#d78d07 "orange
        hi Special		guifg=#51d707 "green
        hi Identifier	guifg=#07d78d "cyan
        hi PreProc		guifg=#0751d7 "blue
        hi Type		guifg=#8d07d7 "purple
        hi Underlined	guifg=NONE
    endif
else
	"Console VIM
	if &background == "dark"
		hi NonText			ctermfg=DarkGray
		hi StatusLine		ctermfg=Gray
		hi StatusLineNC		ctermfg=DarkGray
		hi Title cterm=standout ctermfg=DarkRed
		hi NonText cterm=NONE ctermfg=DarkGrey
	else
	endif

	hi clear PMenu
	hi clear PMenuSel
	hi! link PMenu StatusLineNC
	hi! link PMenuSel StatusLine
endif

hi clear CursorColumn
hi clear FoldColumn
hi clear Folded
hi clear lCursor
hi clear LineNr
hi clear ModeMsg
hi clear MoreMsg
hi clear PmenuSbar
hi clear PmenuThumb
hi clear Question
hi clear SignColumn
hi clear SpecialKey
hi clear VertSplit
hi clear WildMenu
hi! link lCursor	Cursor
hi! link CursorColumn	CursorLine
hi! link FoldColumn	NonText
hi! link SpecialKey	NonText
hi! link Folded		NonText
hi! link LineNr		NonText
hi! link SignColumn	NonText
hi! link WildMenu	Search
hi! link PmenuThumb	StatusLine
hi! link PmenuSbar	StatusLineNC
hi! link VertSplit	StatusLineNC
hi! link ModeMsg	Title
hi! link MoreMsg	Title
hi! link Question	Title
" For syntax hilighting
hi clear Error
hi clear Ignore
hi clear Todo
hi clear Comment
hi! link Error		ErrorMsg
hi! link Ignore		NonText 
hi! link Todo		WarningMsg
hi! link Comment	NonText

"Test this sometime
"hi CursorIM

"GTK Toolkit does gui for this, test with others
"hi TabLineFill	gui=reverse
"hi TabLineSel	gui=bold
"hi TabLine	gui=underline guibg=DarkGrey

"Still have to experiment with this
"hi DiffAdd	guibg=DarkBlue
"hi DiffChange	guibg=DarkMagenta
"hi DiffDelete	gui=bold guifg=Blue guibg=DarkCyan
"hi DiffText	gui=bold guibg=Red

" vim: set noet ts=10 sw=4 :
