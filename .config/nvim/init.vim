" Settings {{{
" Set encoding when vim first starts
if has("vim_starting")
    set encoding=utf-8
endif

" Use ripgrep
if executable("rg")
    set grepprg=rg\ --vimgrep\ --no-heading
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

set autoindent
set cursorline
set expandtab
set fillchars+=stl:\ ,stlnc:\
set foldlevel=99
set foldmethod=indent
set hidden
set ignorecase
set incsearch
set laststatus=2
set listchars=tab:\|\ 
set modeline
set mouse=a
set noshowmode
set number
set relativenumber
set ruler
set scrolljump=5 " lines to scroll when cursor leaves screen
set scrolloff=3  " minimum lines to keep above and below cursor
set shiftwidth=4
set signcolumn=yes
set smartcase
set smarttab
set softtabstop=4
set splitright
set tabstop=4
set termguicolors " Use GUI colors for the terminal. Enable this when TrueColor is working
set updatetime=250
" }}}

" Commands/Functions {{{
command! W write
command! -nargs=+ -complete=command TabMessage call TabMessage(<q-args>)

function! TabMessage(cmd) " {{{ Send command output to a new tab for easier viewing (ie :map keymap list)
    redir => message
    silent execute a:cmd
    redir END
    if empty(message)
        echoerr "no output"
    else
        " use "new" instead of "tabnew" below if you prefer split windows instead of tabs
        tabnew
        setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
        silent put=message
    endif
endfunction " }}}

function! g:ToggleColorColumn() " {{{ Toggle the 80 character shame line
    if &colorcolumn != ''
        setlocal colorcolumn&
    else
        setlocal colorcolumn=+1
    endif
endfunction " }}}

function! FollowSymlink() " {{{ Resolve open symlinks to their referenced file
    let current_file = expand('%:p')
    " check if file type is a symlink
    if getftype(current_file) == 'link'
        " if it is a symlink resolve to the actual file path
        "   and open the actual file
        let actual_file = resolve(current_file)
        silent! execute 'file ' . actual_file
    end
endfunction " }}}

function! SetProjectRoot() " {{{ Set working directory to git project root or directory of current file if not git project

    " default to the current file's directory
    let directory = expand('%:p:h')
    if isdirectory(directory) && !&previewwindow && expand("%:h") !~ ".git"
        lcd %:p:h
        let git_dir = system("git rev-parse --show-toplevel")
        " See if the command output starts with 'fatal' (if it does, not in a git repo)
        let is_not_git_dir = matchstr(git_dir, '^fatal:.*')
        " if git project, change local directory to git project root
        if empty(is_not_git_dir)
            lcd `=git_dir`
        endif
    endif
endfunction " }}}

function! ToggleMouse() " {{{
    " check if mouse is enabled
    if &mouse == 'a'
        " disable mouse
        set mouse=
    else
        " enable mouse everywhere
        set mouse=a
    endif
endfunc " }}}

" Load local configs {{{
function! LoadLocalConfig()
  if filereadable(getcwd().'/.vimrc.local')
    source getcwd().'/.vimrc.local'
  endif
endfunction " }}}

" Lightline Functions {{{
function! LightLineModified() " {{{ Modified flag +
    if &filetype == "help"
        return ""
    elseif &modified
        return "+"
    elseif &modifiable
        return ""
    else
        return ""
    endif
endfunction " }}}

function! LightLineReadonly() " {{{ Readonly flag 
    if &filetype == "help"
        return ""
    elseif &readonly
        return ""
    else
        return ""
    endif
endfunction " }}}

function! LightLineFugitive() " {{{ Git branch 
    if exists("*fugitive#head")
        let branch = fugitive#head()
        return branch !=# '' ? ' '.branch : ''
    endif
    return ''
endfunction " }}}
" }}}

" UltiSnips {{{
function! <SID>ExpandSnippetOrReturn() " {{{ Allow enter key to use a snippet
    let snippet = UltiSnips#ExpandSnippetOrJump()
    if g:ulti_expand_or_jump_res > 0
        return snippet
    else
        return "\<C-Y>"
    endif
endfunction " }}}
" }}}
" }}}

" Keymaps {{{
" Toggle line wrapping
nnoremap <silent> <leader>w :set wrap!<CR>

" Move pop from ctrl-t
nnoremap <silent> <leader>] :pop<CR>

" Open tag definition in vertical split
nnoremap <C-W>[ :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

" Toggle paste
nnoremap <silent> <F12> :set paste!<CR>

" search from visual mode selection
vnoremap // y/<C-R>"<CR>"

" Toggle colorcolumn
nnoremap <silent> <leader>tc :call g:ToggleColorColumn()<CR>

" Grep word under cursor
nnoremap gr :grep <cword><CR>

" Toggle mouse
nnoremap <silent> <leader>m :call ToggleMouse()<CR>

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

" Enter key for snippets in popup
imap <expr> <CR> pumvisible() ? "<C-R>=<SID>ExpandSnippetOrReturn()<CR>" : "<Plug>delimitMateCR"

nnoremap <silent> <C-t> :TagbarToggle<CR>

" GitGutter {{{
nmap <silent> <Leader>gg :GitGutterToggle<CR>
nmap <silent> <Leader>gn :GitGutterNextHunk<CR>
nmap <silent> <Leader>gp :GitGutterPrevHunk<CR>
" }}}

" EasyAlign {{{
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
" }}}

" vim-fugitive {{{
nmap <silent> <Leader>gs :Gstatus<CR>
nmap <silent> <Leader>gc :Gcommit<CR>
nmap <silent> <Leader>gb :Gblame<CR>
nmap <silent> <Leader>gp :Gpull<CR>
nmap <silent> <Leader>gP :Gpush<CR>
" }}}

" eregex.vim {{{
nnoremap <leader>/ :call eregex#toggle()<CR>
" }}}

" gundo.vim {{{
nnoremap <silent> U :GundoToggle<CR>
" }}}

" scratch.vim {{{
nmap <C-s>w :Sscratch<CR>
nmap <C-s>v :Vscratch<CR>
" }}}

" NERDTree {{{
nmap <silent> <C-x> :NERDTreeToggle<CR>
" "}}}

" fzf {{{
nmap ,ff :Files<CR>
nmap ,fh :Files $HOME<CR>
nmap ,fb :Buffers<CR>
nmap ,fr :Files /<CR>
nmap ,fc :Commits<CR>
nmap ,fs :Snippets<CR>
nmap ,ft :BTags<CR>
nmap ,fT :Tags<CR>
" }}}
" }}}

" Auto commands {{{
" Set appropriate filetypes
autocmd BufEnter *.erb,*.rhtml setf eruby
autocmd BufEnter *.mako setf mako
autocmd BufEnter *.cib setf pcmk
autocmd BufEnter *.tdl setf xml
autocmd BufEnter *.nse setf lua
autocmd BufEnter *.cron setf crontab
autocmd BufEnter *.md setf markdown

autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
"
" follow symlink and set working directory
autocmd BufEnter *
            \ call FollowSymlink() |
            \ call SetProjectRoot()

" Auto-close preview window after autocomplete
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" Load local configs
autocmd BufReadPre * call LoadLocalConfig()
"}}}

" Plugins {{{
call plug#begin('~/.config/nvim/plug')

Plug 'chriskempson/base16-vim'                       " Base16 colors
Plug 'villainy/murmur-lightline'                     " My murmur lightline theme adapted from airline
Plug 'guns/xterm-color-table.vim',
            \ { 'on': 'XtermColorTable'}             " All 256 xterm colors with their RGB equivalents, right in Vim!
Plug 'itchyny/lightline.vim'                         " Syntax highlighting for hackers
Plug 'scrooloose/nerdtree'                           " A tree explorer plugin for vim.
Plug 'scrooloose/nerdcommenter'                      " Vim plugin for intensely orgasmic commenting
Plug 'junegunn/vim-easy-align'                       " A Vim alignment plugin
Plug 'tpope/vim-unimpaired'                          " unimpaired.vim: pairs of handy bracket
Plug 'embear/vim-foldsearch'                         " fold away lines that don't match a specific search pattern
Plug 'vim-scripts/Rename'                            " Rename a buffer within Vim and on disk
Plug 'ethanmuller/scratch.vim'                       " Plugin to create and use a scratch Vim buffer
Plug 'sjl/gundo.vim'                                 " Gundo.vim is Vim plugin to visualize your Vim undo tree.
Plug 'othree/eregex.vim'                             " Perl/Ruby style regexp notation for Vim
Plug 'milkypostman/vim-togglelist'                   " Functions to toggle the [Location List] and the [Quickfix List] windows.
Plug 'tpope/vim-fugitive'                            " fugitive.vim: a Git wrapper so awesome, it should be illegal
Plug 'airblade/vim-gitgutter'                        " A Vim plugin which shows a git diff in the gutter (sign column) and stages/undoes hunks.
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'  " The ultimate snippet solution for Vim.
Plug 'majutsushi/tagbar'                             " Vim plugin that displays tags in a window, ordered by scope
Plug 'yssl/QFEnter'                                  " Open a Quickfix item in a window you choose
Plug 'neomake/neomake'                               " A plugin for asynchronous :make using Neovim's job-control functionality
Plug 'Raimondi/delimitMate'                          " insert mode auto-completion for quotes, parens, brackets, etc.
Plug 'ludovicchabant/vim-gutentags'                  " A Vim plugin that manages your tag files
Plug 'junegunn/fzf', {
            \ 'dir': '~/.fzf',
            \ 'do': './install --bin'
            \ } | Plug 'villainy/fzf.vim'            " A command-line fuzzy finder written in Go
Plug 'davidhalter/jedi', { 'for' : 'python'}         " Awesome autocompletion and static analysis library for python.
Plug 'kshenoy/vim-signature'                         " Plugin to toggle, display and navigate marks
Plug 'tpope/vim-abolish'                             " Working with variants of a word

Plug 'shawncplus/phpcomplete.vim', { 'for' : 'php' } " Improved PHP omnicompletion

                                                     " deoplete and sources
Plug 'Shougo/deoplete.nvim'                          " Dark powered asynchronous completion framework for neovim
Plug 'Shougo/neco-vim', { 'for' : 'vim' }            " The vim source for neocomplete/deoplete
Plug 'zchee/deoplete-jedi', { 'for' : 'python' }     " deoplete.nvim source for Python

                                                     " Syntax highlighting
Plug 'elzr/vim-json', { 'for' : 'json' }
Plug 'StanAngeloff/php.vim', { 'for' : 'php' }
Plug 'pangloss/vim-javascript', { 'for' : 'javascript' }
Plug 'mxw/vim-jsx', { 'for' : 'javascript' } 
Plug 'sheerun/vim-polyglot'                          " A solid language pack for Vim.
Plug 'pearofducks/ansible-vim'
Plug 'ekalinin/Dockerfile.vim'
Plug 'freitass/todo.txt-vim', { 'for': 'todo' }

call plug#end()
" }}}

" Plugin settings {{{

" lightline.vim {{{
let g:lightline = {
            \ 'colorscheme': 'murmur',
            \ 'active': {
            \   'left': [ [ 'mode', 'paste' ],
            \               [ 'fugitive', 'readonly'],
            \               [ 'filename', 'modified' ] ]
            \ },
            \ 'component_function': {
            \   'fugitive': 'LightLineFugitive',
            \   'readonly': 'LightLineReadonly',
            \   'modified': 'LightLineModified'
            \ },
            \ 'separator': { 'left': '', 'right': '' },
            \ 'subseparator': { 'left': '', 'right': '' }
            \ }
" }}}

" base16 {{{
let base16colorspace=256  " Access colors present in 256 colorspace
colorscheme base16-default-dark
" }}}

" vim-gitgutter {{{
let g:gitgutter_enabled = 1
" }}}

" eregex.vim {{{
let g:eregex_default_enable = 0
" }}}

" fzf {{{
if executable("rg")
    let $FZF_DEFAULT_COMMAND = 'rg --files'
else
    let $FZF_DEFAULT_COMMAND = 'find . -not -wholename "*.git/*"'
endif

let g:fzf_layout = { 'up': '~30%' }

let g:fzf_action = {
    \ 'ctrl-q': 'bdelete',
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-x': 'split',
    \ 'ctrl-v': 'vsplit' }

command! FZFMulti call fzf#run(fzf#wrap({
            \'options': ['--multi'],
            \}))
" }}}

" UltiSnips {{{
let g:snips_author = 'Michael Morgan'
let g:snips_email = 'mmorgan@morgan83.com'
let g:snips_copyright = 'Michael Morgan'
let g:snips_github = 'https://github.com/villainy'

let g:UltiSnipsEditSplit="vertical"          " vsplit when editing snippet file
let g:UltiSnipsJumpForwardTrigger="<tab>"    " Map tab/shifttab for entering snippet popup instead of whatever the insane default was
let g:UltiSnipsJumpBackwardTrigger="<S-tab>" " Integrate with YCM
let g:UltiSnipsExpandTrigger="<nop>"
let g:ulti_expand_or_jump_res = 0            " Local snippet vars
" }}}

" vim-togglelist {{{
let g:toggle_list_copen_command="botright copen" " Force quickfix window location
" }}}

" Tagbar {{{
let g:tagbar_sort = 0
let g:tagbar_compact = 1
" }}}

" gutentags {{{
" Exclude node_modules from gutentags or you'll just run out of memory and have
" have a multi-GB tags file...
let g:gutentags_ctags_exclude = [ 'node_modules' ]
"let g:gutentags_enabled = 0
" }}}

" deoplete {{{
"call deoplete#enable_logging('DEBUG', '/home/mmorgan/tmp/deoplete.log')

let g:deoplete#enable_at_startup = 1
"let g:deoplete#omni_patterns = {}
" }}}

" neomake {{{
call neomake#configure#automake('nrw', 1000)
" }}}

" phpcomplete-extended {{{
"let g:phpcomplete_index_composer_command = '/usr/bin/composer'
" }}}
" }}}

" Custom highlighting {{{
highlight Error ctermfg=0 ctermbg=1 guifg=#e4e4e4 guibg=#ab4642
" }}}

" vim: foldmethod=marker ft=vim
