" my filetype file
if exists("did_load_filetypes")
    finish
endif
augroup filetypedetect
    au! BufRead,BufNewFile	*.mips	setfiletype mips
    au! BufRead,BufNewFile	*.mxm	setfiletype maxima
    au! BufRead,BufNewFile	*.P 	setfiletype prolog
    au! BufRead,BufNewFile	*.pp 	setfiletype puppet
    au! BufRead,BufNewFile	*.viki 	setfiletype viki
    au! BufRead,BufNewFile	*.mako 	setfiletype mako
    au! BufRead,BufNewFile	*.pdc 	setfiletype pandoc
    au! BufRead,BufNewFile	*.pandoc 	setfiletype pandoc
    au! BufRead,BufNewFile	*.md 	setfiletype markdown
augroup END
