set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

Bundle 'decode/buftabs'
Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-surround'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/nerdcommenter'
Bundle 'scrooloose/syntastic'
Bundle 'ervandew/supertab'
Bundle 'msanders/snipmate.vim'
Bundle 'Townk/vim-autoclose'
Bundle 'kevinw/pyflakes-vim'
Bundle 'majutsushi/tagbar'
Bundle 'godlygeek/tabular'
Bundle 'jeetsukumaran/vim-buffergator'

Bundle 'L9'
Bundle 'FuzzyFinder'
Bundle 'taglist.vim'
Bundle 'bufpos'
Bundle 'bufexplorer.zip'

Bundle 'git://git.wincent.com/command-t.git'

filetype plugin indent on     " required!

" pathogen.vim: Manage your 'runtimepath' with ease
"source ~/.vim/bundle/vim-pathogen/autoload/pathogen.vim
"call pathogen#infect()

colorscheme lettuce
set fileencodings=ucs-bom,utf8,GB18030,Big5,latin1
set number
set background=dark
set encoding=utf-8
set guifont=Bitstream\ Vera\ Sans\ Mono\ 10
set guioptions-=T
set guioptions-=r
set guioptions-=l
syntax on

" Map shortcut key
let mapleader=","
let g:mapleader=","

set cf  " Enable error files & error jumping.
set clipboard+=unnamed  " Yanks go on clipboard instead.
set history=256  " Number of things to remember in history.
set autowrite  " Writes on make/shell commands
set ruler  " Ruler on
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
set expandtab " Turn tabs into spaces
set wildmenu " Make the command-line completion better
 
" Visual
set showmatch  " Show matching brackets.
set showcmd "show incomplete cmds down the bottom
set showmode "show current mode down the bottom
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

" Toggle NERNTree
map <leader>d :execute 'NERDTreeToggle ' . getcwd()<CR>

" Buftab
:let g:buftabs_in_statusline=1
:let g:buftabs_only_basename=1
:let g:buftabs_sorted_number=1
