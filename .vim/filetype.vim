augroup filetypedetect
	au! BufRead,BufNewFile *.rhtml setfiletype eruby
augroup END

augroup filetypedetect
	au! BufRead,BufNewFile *.css setfiletype css
augroup END

augroup filetypedetect
	au BufRead,BufNewFile *.R setf r
  au BufRead,BufNewFile *.R set syntax=r
augroup END

