let python_highlight_all = 1
" setlocal smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
setlocal nosmartindent " Smartindent messes up indenting and shifting of #-comments.
setlocal expandtab " Sigh, everybody conforms to this, I guess I should too.
compiler pyunit
nmap <leader>pt :Pytest session
