" Environment Settings {{{
let g:project_root='/home/mmorgan/src'
let g:netcat_bin = 'D:\Programs\Nmap\ncat'

if has("win32")
    let g:project_root='D:\\Users\\Michael\\Projects'
    let g:python_host_prog = 'C:\Users\Michael\AppData\Local\Programs\Python\Python27\python.exe'
    let g:python3_host_prog = 'C:\Users\Michael\AppData\Local\Programs\Python\Python37-32\python.exe'
endif

let g:snips_author = 'Michael Morgan'
let g:snips_email = 'mmorgan@morgan83.com'
let g:snips_copyright = 'Michael Morgan'
let g:snips_github = 'https://github.com/villainy'
" }}}

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
set completeopt=menuone,noinsert,noselect,preview
set cursorline
set expandtab
set fillchars+=stl:\ ,stlnc:\
set foldlevel=99
set foldmethod=indent
set guifont="SauceCodePro NF Regular:h14"
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

if has("win32")
    behave mswin

    "set shell=powershell shellquote=( shellpipe=\| shellxquote=
    "set shellcmdflag=-NoLogo\ -NoProfile\ -ExecutionPolicy\ RemoteSigned\ -Command
    "set shellredir=\|\ Out-File\ -Encoding\ UTF8
    set fileformat=unix
    set fileformats=unix,dos
endif
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

function! LightLineFiletype() " {{{
    if exists("*WebDevIconsGetFileTypeSymbol")
        return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
    endif
endfunction " }}}

function! LightLineFileformat() " {{{
    if exists("*WebDevIconsGetFileTypeSymbol")
        return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
    endif
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

" Vista {{{
function! VistaSourcePath() abort
    let source_path = ''

	let class = get(b:, 'vista_nearest_class', '')
    if !empty(class)
        let source_path .= class
    endif

	let method = get(b:, 'vista_nearest_method', '')
    if !empty(class) && !empty(method)
        let source_path .= '\'.method
    elseif !empty(method)
        let source_path .= method
    endif

    return source_path
endfunction
" }}}

" vim-lsp {{{
function! LspMapRoot()
    if exists("*lsp#utils#path_to_uri")
        return lsp#utils#path_to_uri(
                \ substitute(lsp#utils#find_nearest_parent_file_directory(
                \ lsp#utils#get_buffer_path(),
                \ ['.git/','setup.py', 'composer.json']), '^'.g:project_root, '/src', ''))
    endif
endfunction
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
if executable('rg')
    nnoremap gr :exec("Rg ".expand("<cword>"))<CR>
else
    nnoremap gr :grep <cword><CR>
endif

" Toggle mouse
nnoremap <silent> <leader>m :call ToggleMouse()<CR>

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

" Enter key for snippets in popup
imap <expr> <CR> pumvisible() ? "<C-R>=<SID>ExpandSnippetOrReturn()<CR>" : "<Plug>delimitMateCR"

nnoremap <silent> <C-t> :Vista!!<CR>

" GUI {{{
if has("clipboard")
    " CTRL-X and SHIFT-Del are Cut
    vnoremap <C-X> "+x
    vnoremap <S-Del> "+x

    " CTRL-C and CTRL-Insert are Copy
    vnoremap <C-C> "+y
    vnoremap <C-Insert> "+y

    " CTRL-V and SHIFT-Insert are Paste
    "map <C-V>		"+gP
    map <S-Insert>		"+gP

    "cmap <C-V>		<C-R>+
    cmap <S-Insert>		<C-R>+
endif

if exists('g:fvim_loaded')
    " Ctrl-ScrollWheel for zooming in/out
    nnoremap <silent> <C-ScrollWheelUp> :set guifont=+<CR>
    nnoremap <silent> <C-ScrollWheelDown> :set guifont=-<CR>
    nnoremap <A-CR> :FVimToggleFullScreen<CR>
endif
" }}}

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
nmap ,fs :Snippets<CR>
nmap ,ft :BTags<CR>
nmap ,fT :Tags<CR>
nmap <silent> <leader>gC :Commits<CR>
nmap <silent> <leader>gB :Commits<CR>
" }}}

" vdebug {{{
let g:vdebug_keymap = {
\    "run" : ",dr",
\    "run_to_cursor" : ",dR",
\    "step_over" : ",dl",
\    "step_into" : ",dj",
\    "step_out" : ",dk",
\    "close" : ",dq",
\    "detach" : ",dD",
\    "set_breakpoint" : ",ds",
\    "eval_visual" : ",de"
\}
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

" follow symlink and set working directory
autocmd BufEnter *
            \ call FollowSymlink() |
            \ call SetProjectRoot()

" Auto-close preview window after autocomplete
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" vim-lsp isn't starting correctly on enabled filetypes
if has("win32")
    autocmd FileType php,python if exists("g:lsp_loaded") && g:lsp_loaded | call lsp#enable() | endif
endif
"}}}

" Plugins {{{
call plug#begin('~/.config/nvim/plug')

Plug 'chriskempson/base16-vim'                       " Base16 colors
Plug 'villainy/murmur-lightline'                     " My murmur lightline theme adapted from airline
Plug 'guns/xterm-color-table.vim',
            \ { 'on': 'XtermColorTable'}             " All 256 xterm colors with their RGB equivalents, right in Vim!
Plug 'itchyny/lightline.vim'                         " Syntax highlighting for hackers
Plug 'scrooloose/nerdtree'                           " A tree explorer plugin for vim.
Plug 'Xuyuanp/nerdtree-git-plugin'
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
Plug 'airblade/vim-gitgutter'                        " A Vim plugin which shows a git diff in the gutter (sign column)
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'  " The ultimate snippet solution for Vim.
Plug 'thomasfaingnaert/vim-lsp-snippets'
Plug 'thomasfaingnaert/vim-lsp-ultisnips'
Plug 'villainy/vista.vim', { 'branch': 'nearest-class' }
Plug 'yssl/QFEnter'                                  " Open a Quickfix item in a window you choose
Plug 'Raimondi/delimitMate'                          " insert mode auto-completion for quotes, parens, brackets, etc.
Plug 'ludovicchabant/vim-gutentags'                  " A Vim plugin that manages your tag files
Plug 'junegunn/fzf', {
            \ 'dir': '~/.fzf',
            \ 'do': './install --bin'
            \ } | 
            \ Plug 'villainy/fzf.vim', {
            \ 'branch': 'respect-tags-command' }     " A command-line fuzzy finder written in Go
Plug 'kshenoy/vim-signature'                         " Plugin to toggle, display and navigate marks
Plug 'tpope/vim-abolish'                             " Working with variants of a word
                                                     " Syntax highlighting
Plug 'sheerun/vim-polyglot'                          " A solid language pack for Vim.
Plug 'elzr/vim-json', { 'for' : 'json' }
Plug 'StanAngeloff/php.vim', { 'for' : 'php' }
Plug 'pangloss/vim-javascript', { 'for' : 'javascript' }
Plug 'mxw/vim-jsx', { 'for' : 'javascript' } 
Plug 'pearofducks/ansible-vim', { 'for' : 'ansible' }
Plug 'ekalinin/Dockerfile.vim', { 'for': [ 
            \ 'Dockerfile',
            \ 'yaml.docker-compose'
            \ ] }
Plug 'freitass/todo.txt-vim', { 'for': 'todo' }

Plug 'neomake/neomake'                               " A plugin for asynchronous :make using Neovim's job-control functionality
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp', { 'for' : ['php', 'python'] }

Plug 'Shougo/deoplete.nvim'                          " Dark powered asynchronous completion framework for neovim
Plug 'Shougo/neco-vim', { 'for' : 'vim' }            " The vim source for neocomplete/deoplete
Plug 'prabirshrestha/asyncomplete.vim', { 'for' : ['php', 'python'] }
Plug 'prabirshrestha/asyncomplete-lsp.vim', { 'for' : ['php', 'python'] }
Plug 'ryanoasis/vim-devicons'

Plug 'vim-vdebug/vdebug'
Plug 'embear/vim-localvimrc'

call plug#end()
" }}}

" Plugin settings {{{

" lightline.vim {{{
let g:lightline = {
            \ 'colorscheme': 'murmur',
            \ 'active': {
            \   'left': [ [ 'mode', 'paste' ],
            \               [ 'fugitive', 'readonly'],
            \               [ 'filename', 'model', 'class', 'source_path', 'modified' ] ]
            \ },
            \ 'component_function': {
            \   'filetype':    'LightLineFiletype',
            \   'fileformat':  'LightLineFileformat',
            \   'fugitive':    'LightLineFugitive',
            \   'readonly':    'LightLineReadonly',
            \   'source_path': 'VistaSourcePath',
            \   'modified':    'LightLineModified'
            \ },
            \ 'separator': { 'left': '', 'right': '' },
            \ 'subseparator': { 'left': '', 'right': '' }
            \ }
" }}}

" NERDTree {{{
let NERDTreeMinimalUI=1
let NERDTreeDirArrowExpandable='▸'
let NERDTreeDirArrowCollapsible='▾'

let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "",
    \ "Staged"    : "",
    \ "Untracked" : "",
    \ "Renamed"   : "",
    \ "Unmerged"  : "",
    \ "Deleted"   : "",
    \ "Dirty"     : "",
    \ "Clean"     : "",
    \ 'Ignored'   : "",
    \ "Unknown"   : ""
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
    let $FZF_DEFAULT_COMMAND = 'rg --files --no-ignore --hidden --follow --glob "!.git/*" --glob "!tags"'
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
let g:UltiSnipsEditSplit="vertical"          " vsplit when editing snippet file
let g:UltiSnipsJumpForwardTrigger="<tab>"    " Map tab/shifttab for entering snippet popup instead of whatever the insane default was
let g:UltiSnipsJumpBackwardTrigger="<S-tab>" " Integrate with YCM
let g:UltiSnipsExpandTrigger="<nop>"
let g:ulti_expand_or_jump_res = 0            " Local snippet vars
" }}}

" vim-togglelist {{{
let g:toggle_list_copen_command="botright copen" " Force quickfix window location
" }}}

" Vista {{{
let g:vista#renderer#enable_icons = 1
if exists('*nvim_open_win')
    let g:vista_echo_cursor_strategy = "floating_win"
endif

let g:vista_executive_for = {
            \ 'php': 'vim_lsp',
            \ 'python': 'vim_lsp',
            \ }

let g:vista_fzf_preview = ['up:~30%']
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
let g:deoplete#omni_patterns = {}
"
" Disable for LSP languages
au FileType php
\ call deoplete#custom#buffer_option('auto_complete', v:false)
au FileType python
\ call deoplete#custom#buffer_option('auto_complete', v:false)
" }}}

" neomake {{{
call neomake#configure#automake('nrw', 1000)
"
" Disable for LSP languages
let g:neomake_php_enabled_makers = []
let g:neomake_python_enabled_makers = []
" }}}

" phpcomplete-extended {{{
"let g:phpcomplete_index_composer_command = '/usr/bin/composer'
" }}}

" vim-lsp {{{
let g:lsp_signs_enabled = 1
"let g:lsp_log_verbose = 1
"let g:lsp_log_file = expand('~/.config/nvim/vim-lsp.log')
"let g:asyncomplete_log_file = expand('~/.config/nvim/asyncomplete.log')

au User lsp_setup call lsp#register_server({
            \ 'name': 'pyls',
            \ 'cmd': {server_info->[&shell, &shellcmdflag, g:netcat_bin.' localhost 8000']},
            \ 'whitelist': ['python'],
            \ 'root_uri': {server_info->LspMapRoot()}})

au User lsp_setup call lsp#register_server({
            \ 'name': 'phpls',
            \ 'cmd': {server_info->[&shell, &shellcmdflag, g:netcat_bin.' localhost 2088']},
            \ 'whitelist': ['php'],
            \ 'root_uri': {server_info->LspMapRoot()}})
" }}}

" vdebug {{{
" Allows Vdebug to bind to all interfaces.
let g:vdebug_options = copy(g:vdebug_options_defaults)

" Stops execution at the first line.
let g:vdebug_options['break_on_open'] = 1
let g:vdebug_options['max_children'] = 128

" Use the compact window layout.
let g:vdebug_options['watch_window_style'] = 'compact'

" Because it's the company default.
let g:vdebug_options['ide_key'] = 'vdebug'


" Need to set as empty for this to work with Vagrant boxes.
let g:vdebug_options['server'] = 'localhost'
" }}}
" }}}

" Custom highlighting {{{
highlight Error ctermfg=0 ctermbg=1 guifg=#e4e4e4 guibg=#ab4642
" }}}

" vim: foldmethod=marker ft=vim
