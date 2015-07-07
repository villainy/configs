" Vundle
" git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

set shell=/usr/bin/bash
set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

Plugin 'bling/vim-airline'
"Plugin 'edkolev/tmuxline.vim'
Plugin 'chriskempson/base16-vim'
Plugin 'scrooloose/nerdtree'
"Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/syntastic'
"Plugin 'taglist.vim'
Plugin 'majutsushi/tagbar'
Plugin 'L9'
Plugin 'FuzzyFinder'
Plugin 'seveas/bind.vim'
Plugin 'tangledhelix/vim-kickstart'
Plugin 'elzr/vim-json'
Plugin 'regedarek/ZoomWin'
Plugin 'chase/vim-ansible-yaml'
"Plugin 'techlivezheng/vim-plugin-minibufexpl'
Plugin 'dag/vim-fish'
"Plugin 'tpope/vim-pathogen'
Plugin 'tpope/vim-fugitive'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
"Plugin 'Valloric/YouCompleteMe'
Plugin 'Raimondi/delimitMate'
Plugin 'tpope/vim-unimpaired'
Plugin 'shawncplus/phpcomplete.vim'
Plugin 'StanAngeloff/php.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList          - list configured plugins
" :PluginInstall(!)    - install (update) plugins
" :PluginSearch(!) foo - search (or refresh cache first) for foo
" :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

set mouse=a
set shiftwidth=4
set softtabstop=4
set tabstop=4
set noexpandtab
"set expandtab
"set autoindent
set ignorecase
set smartcase
"set foldmethod=marker
set foldmethod=indent
set foldlevel=99
set ruler
set modeline
set incsearch
set nu
set hidden

"let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_theme = 'murmur'
let g:airline_powerline_fonts = 1
let g:Powerline_symbols = 'fancy'
set encoding=utf-8
set fillchars+=stl:\ ,stlnc:\
set laststatus=2

set background=dark
colorscheme base16-default

set t_Co=256

set guifont=Source\ Code\ Pro\ for\ Powerline\ 12

autocmd BufEnter *.erb,*.rhtml setf eruby
autocmd BufEnter *.pl compiler perl
autocmd BufEnter *.mako setf mako
autocmd BufEnter *.cib setf pcmk
autocmd BufEnter *.tdl setf xml
autocmd BufEnter *.nse setf lua

nmap <silent> <C-x> :NERDTreeToggle<CR>
"nmap <silent> <C-w>a :bdelete<CR>
"nmap <silent> <C-w>e :bprev<CR>
"nmap <silent> <C-w>r :bnext<CR>
"nmap <silent> <C-t> :TlistToggle<CR>
nmap <silent> <C-t> :TagbarToggle<CR>
nmap ,f :FufFileWithCurrentBufferDir<CR>
nmap ,b :FufBuffer<CR>

let g:syntastic_java_javac_config_file_enabled = 1
let g:Tlist_Show_One_File = 1
source ~/.vimrc-highlight

autocmd BufEnter *.erb,*.rhtml setf eruby
autocmd BufEnter *.pl compiler perl
autocmd BufEnter *.mako setf mako
autocmd BufEnter *.cib setf pcmk
autocmd BufEnter *.tdl setf xml
autocmd BufEnter *.nse setf lua

autocmd FileType python set et
