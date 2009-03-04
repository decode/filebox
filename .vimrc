colorscheme torte
set nocompatible
set number
set background=dark
set encoding=utf-8
syntax on
filetype plugin indent on
set guioptions-=T

" Buftab
:let g:buftabs_in_statusline=1
:let g:buftabs_only_basename=1

" ruby omni completion
autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1

" External auto-indenting
nmap <leader>rci :%!ruby-code-indenter<cr> 

" Add recently accessed projects menu (project plugin)
set viminfo^=!
 
" Minibuffer Explorer Settings
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1
 
" alt+n or alt+p to navigate between entries in QuickFix
map <silent> <m-p> :cp <cr>
map <silent> <m-n> :cn <cr>

" Change which file opens after executing :Rails command
let g:rails_default_file='config/database.yml'

syntax enable

set cf  " Enable error files & error jumping.
set clipboard+=unnamed  " Yanks go on clipboard instead.
set history=256  " Number of things to remember in history.
set autowrite  " Writes on make/shell commands
set ruler  " Ruler on
set nu  " Line numbers on
set nowrap  " Line wrapping off
set timeoutlen=250  " Time to wait after ESC (default causes an annoying delay)
 
" Formatting (some of these are for coding in C and C++)
set ts=2  " Tabs are 2 spaces
set bs=2  " Backspace over everything in insert mode
set shiftwidth=2  " Tabs under smart indent
set nocp incsearch
set cinoptions=:0,p0,t0
set cinwords=if,else,while,do,for,switch,case
set formatoptions=tcqr
set cindent
set autoindent
set smarttab
set expandtab
 
" Visual
set showmatch  " Show matching brackets.
set mat=5  " Bracket blinking.
set list
" Show $ at end of line and trailing space as ~
" set lcs=tab:\ \ ,eol:$,trail:~,extends:>,precedes:<
set lcs=tab:\ \ ,eol:\ ,trail:\ ,extends:>,precedes:<
set novisualbell  " No blinking .
set noerrorbells  " No noise.
set laststatus=2  " Always show status line.
 
" gvim specific
set mousehide  " Hide mouse after chars typed
set mouse=a  " Mouse in all modes

" Backups & Files
set backup                     " Enable creation of backup file.
set backupdir=~/.vim/backups " Where backups will go.
set directory=~/.vim/tmp     " Where temporary files will go.


let base_dir = "/home/home/develop/projects/topicture" . expand("%")

" Central additions (also add the functions below)
:command RTlist call CtagAdder("app/models","app/controllers","app/views","public")

map <F7> :RTlist<CR>

" Optional, handy TagList settings

:nnoremap <silent> <F8> :Tlist<CR>

let Tlist_Compact_Format = 1
let Tlist_File_Fold_Auto_Close = 1

let Tlist_Use_Right_Window = 1
let Tlist_Exit_OnlyWindow = 1

let Tlist_WinWidth = 40

" Function that gets the dirtrees for the provided dirs and feeds 
" them to the TlAddAddFiles function below

func CtagAdder(...)
	let index = 1
	let s:dir_list = ''
	while index <= a:0
		let s:dir_list = s:dir_list . TlGetDirs(a:{index})
		let index = index + 1
	endwhile
	call TlAddAddFiles(s:dir_list)
	wincmd p
	exec "normal ="
	wincmd p
endfunc 

" Adds *.rb, *.rhtml and *.css files to TagList from a given list
" of dirs

func TlAddAddFiles(dir_list)
	let dirlist = a:dir_list
	let s:olddir = getcwd()
	while strlen(dirlist) > 0
		let curdir = substitute (dirlist, '|.*', "", "")
		let dirlist = substitute (dirlist, '[^|]*|\?', "", "")
		exec "cd " . g:base_dir
		exec "TlistAddFiles " . curdir . "/*.rb"
		exec "TlistAddFiles " . curdir . "/*.rhtml"
		exec "TlistAddFiles " . curdir . "/*.css"
"		exec "TlistAddFiles " . curdir . "/*.js"
	endwhile
	exec "cd " . s:olddir
endfunc

" Gets all dirs within a given dir, returns them in a string,
" separated by '|''s

func TlGetDirs(start_dir)
	let s:olddir = getcwd()
	exec "cd " . g:base_dir . '/' . a:start_dir
	let dirlist = a:start_dir . '|'
	let dirlines = glob ('*')
	let dirlines = substitute (dirlines, "\n", '/', "g")
	while strlen(dirlines) > 0
		let curdir = substitute (dirlines, '/.*', "", "")
		let dirlines = substitute (dirlines, '[^/]*/\?', "", "")
		if isdirectory(g:base_dir . '/' . a:start_dir . '/' . curdir)
			let dirlist = dirlist . TlGetDirs(a:start_dir . '/' . curdir)
		endif
	endwhile
	exec "cd " . s:olddir
	return dirlist
endfunc

