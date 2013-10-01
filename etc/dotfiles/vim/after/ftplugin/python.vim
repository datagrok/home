let python_highlight_all = 1
" setlocal smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
setlocal nosmartindent " Smartindent messes up indenting and shifting of #-comments.
setlocal expandtab " Sigh, everybody conforms to this, I guess I should too.
compiler pyunit
nmap <leader>pt :Pytest session
setlocal tw=72
" Pep-8: wrap code to 79 cols, or up to 99 if it improves readability.
" Wrap stuff that is less finicky, like docstrings, to 72 cols..
setlocal colorcolumn=73,80,100
setlocal nowrap
