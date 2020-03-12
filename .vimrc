runtime bundle/vim-pathogen/autoload/pathogen.vim
syntax on
if has("autocmd")
	filetype plugin indent on
endif

" Jump to the last position when reopening a file (from Debian $VIM/vimrc)
if has("autocmd")
	au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
				\| exe "normal g'\"" | endif
endif

set tags+=tags;/home/mike " Search up until my homedir for a tags file.
set modeline            " God damn it debian! I want modelines
set encoding=utf-8
"set fileencodings=ucs-bom,utf-8,sjis,euc-jp,default,latin1
set showcmd		" Show (partial) command in status line.
" Include vim-fugitive data in statusline.
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
set incsearch		" Incremental search
set autowrite		" Automatically save before commands like :next and :make
set updatecount=2000	" Make swapfile write less often
set hlsearch		" Hilight searches
set autoindent		" Copy indent of previous line
" smartindent is crap. Don't use it.
" http://vim.wikia.com/wiki/Restoring_indent_after_typing_hash
set cinkeys-=0#
set indentkeys-=0#
set shiftwidth=4
set tabstop=4
set expandtab		" I love tab characters, but I'm never gonna win :(
set shiftround
set wildmenu    
set visualbell		" Kill that damn bell
"set hidden		" Let me jump around to other files without saving mine
set diffopt+=iwhite	" Ignore whitespace in 'vimdiff'
set relativenumber	" Show relative numberlines
"

" Useful with inotifywait; both required:
"set nobackup
"set nowritebackup

if hostname() == 'io'	" Laptop-only settings
    " Less safe but good for saving laptop power
    set nofsync		" Don't constantly spin up my disk
    set swapsync=	" Ditto above
    set guiheadroom=0	" Do I still need this?
    "set lines=53
endif

" Turn off the blink for normal use; use faster strobe for rare occasions
set gcr=
	    \n-v-c:block-Cursor/lCursor-blinkon0,
	    \o:hor50-Cursor-blinkwait50-blinkoff50-blinkon50,
	    \i-ci:ver25-Cursor/lCursor-blinkon0,
	    \r-cr:hor20-Cursor/lCursor-blinkon0,
	    \sm:block-Cursor-blinkwait50-blinkoff50-blinkon50

" K&R style, from :h section
"map [[ ?{<CR>w99[{
"map ][ /}<CR>b99]}
"map ]] j0[[%/{<CR>
"map [] k$][%?}<CR>

noremap ; :

if &term =~ "xterm"
    set t_Co=256
endif

set guifont=Monospace\ 11
set guioptions=agire
set foldmethod=indent
set foldminlines=0
set foldcolumn=3
set foldnestmax=2
"set foldtext=
set nofoldenable
set background=dark
set listchars=eol:$,tab:\ -,nbsp:_,trail:.,extends:>,precedes:<  
colorscheme mike

set linebreak
" 'set showbreak' and 'let &showbreak' differ!?
let &showbreak="\u00bb   "

nnoremap <Up>		g<Up>
nnoremap <Down>		g<Down>
nnoremap j			gj
nnoremap k			gk
inoremap <Up>		<C-O>g<Up>
inoremap <Down>		<C-O>g<Down>

inoremap {<cr>		{<cr>}<esc>O

inoremap [<cr>		[<cr>]<esc>O

inoremap (<cr>		(<cr>)<esc>O

inoremap /*<space>	/*<space><space>*/<left><left><left>
inoremap /*<cr>		/*<cr>*/<esc>O

noremap <f5> 		:make<cr>
noremap <M-right>	:cnext<cr>
noremap <M-left>	:cprevious<cr>
noremap <M-up>		:cw<cr>
noremap <M-down>	:cc<cr>


"swap words, swap chars map by chris campbell (vim tip#329)
" --- gw is useful... choose something else.
"nnoremap <silent> gw "_yiw:s/\(\%#\w\+\)\(\W\+\)\(\w\+\)/\3\2\1/<cr><c-o><c-l>
"nnoremap <silent> gc xph
"nnoremap <silent> gl "_yiw?\w\+\_W\+\%#<CR>:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<cr><c-o><c-l>
"nnoremap <silent> gr "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<cr><c-o>/\w\+\_W\+<CR><c-l>

"Datestamps! http://vim.wikia.com/wiki/VimTip97
" RFC822 format: Wed, 29 Aug 2007 02:37:15 -0400
inoremap <leader>date Date:<space><C-R>=strftime("%a, %d %b %Y %H:%M:%S %z")<CR>
" ISO8601/W3C format: 2007-08-29T02:37:13-0400 http://www.w3.org/TR/NOTE-datetime
inoremap <leader>Di <C-R>=strftime("%FT%T%z")<CR>
" The preferred date and time representation for the current locale
" Wed 29 Aug 2007 02:36:57 AM EDT in my locale
inoremap <leader>Dl <C-R>=strftime("%c")<CR>

let hs_highlight_delimiters = 1
let hs_highlight_boolean = 1
let hs_highlight_types = 1
let hs_highlight_more_types = 1
let hs_highlight_debug = 1
let g:haddock_browser = 'epiphany -n'
let g:haddock_indexfiledir = "~/.vim"
let g:haddock_docdir = '/usr/share/doc/ghc6-doc/html/'
let g:ftplugin_sql_omni_key_right = '<C-Right>'
let g:ftplugin_sql_omni_key_left = '<C-Left>'

let g:netrw_list_hide         = '^\.,\.class,\.pyc'

let g:xml_syntax_folding = 1

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
	 	\ | wincmd p | diffthis

" Hilight with "errors" inner tabs
" match errorMsg /[^\t]\zs\t\+/

" Make latexsuite find my custom latex stuff
let g:Tex_TEXINPUTS = '~/lib/latex2e/**'

" Bootstrap pathogen vim-package manager
call pathogen#infect()

nnoremap <C-S-Up> :silent! let &guifont = substitute(
 \ &guifont,
 \ '\zs\d\+$',
 \ '\=eval(submatch(0)+1)',
 \ '')<CR>
nnoremap <C-S-Down> :silent! let &guifont = substitute(
 \ &guifont,
 \ '\zs\d\+$',
 \ '\=eval(submatch(0)-1)',
 \ '')<CR>

ab <leader>-> →
ab <leader><- ←
ab <leader>^ ↑
ab <leader>v ↓
inoremap <leader>airplane ✈
ab <leader>8< ✂
ab <leader>./ ✓
ab <leader>--- —
" ab <leader>therefore ∴ " vim throws a syntax error on this for some reason

" Words that I consistently misspell
ab hueristic heuristic

" vim: set ts=8:
