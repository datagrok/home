let java_highlight_java_lang_ids = 1
let java_highlight_all = 1
" 'indent' or 'style':
" let java_highlight_functions = "indent"

compiler javac

iab <buffer> pc public class {<CR><++><CR>}<esc>2-2ea
iab <buffer> psvm public static void main(String args[]) {<cr>}<esc>-o

if exists("loaded_matchit") && !exists("b:match_words")
	let b:match_ignorecase = 0
	"let s:notelse= '\%(\<else\s\+\)\@<!'
	let s:notelse= '\(\<else\)\@<!'
	let b:match_words = s:notelse. '\<if\>:\<else\s\+if\>\|\<else\>,{:},(:),try:catch'
endif
