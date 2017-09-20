" General settings {{{
set shell=/usr/bin/bash

" Use GUI colors for the terminal. Enable this when TrueColor is working
set termguicolors

set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab

"Send cscope output to quickfix
set cscopequickfix=s-,c-,d-,i-,t-,e-
" Disable verbose cscope to hide duplicate db warnings
set nocscopeverbose

" Auto-close preview window after autocomplete
"autocmd CompleteDone * pclose
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

let python_higlight_all=1

" Don't enable mouse if we're running in screen/tmux
if $TERM =~# '^screen'
  set mouse=
else
  set mouse=a
endif

" Set encoding when vim first starts
if has("vim_starting")
  set encoding=utf-8
endif

set scrolljump=5 " lines to scroll when cursor leaves screen
set scrolloff=3  " minimum lines to keep above and below cursor
set autoindent
set ignorecase
set smartcase
set foldmethod=indent
set foldlevel=99
set ruler
set modeline
set incsearch
set number
set relativenumber
set hidden
set cursorline
set fillchars+=stl:\ ,stlnc:\
set laststatus=2
set listchars=tab:\|\ 
set splitright
set noshowmode
" }}}

" Misc functions {{{
"Send command output to a new tab for easier viewing (ie :map keymap list)
function! TabMessage(cmd)
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
endfunction
command! -nargs=+ -complete=command TabMessage call TabMessage(<q-args>)

function! g:ToggleColorColumn()
    if &colorcolumn != ''
        setlocal colorcolumn&
    else
        setlocal colorcolumn=+1
    endif
endfunction

" follow symlinked file
function! FollowSymlink()
    let current_file = expand('%:p')
    " check if file type is a symlink
    if getftype(current_file) == 'link'
        " if it is a symlink resolve to the actual file path
        "   and open the actual file
        let actual_file = resolve(current_file)
        silent! execute 'file ' . actual_file
    end
endfunction

" set working directory to git project root
" or directory of current file if not git project
function! SetProjectRoot()
    " default to the current file's directory
    let directory = expand('%:p:h')
    if isdirectory(directory) && !&previewwindow
        lcd %:p:h
        let git_dir = system("git rev-parse --show-toplevel")
        " See if the command output starts with 'fatal' (if it does, not in a git repo)
        let is_not_git_dir = matchstr(git_dir, '^fatal:.*')
        " if git project, change local directory to git project root
        if empty(is_not_git_dir)
            lcd `=git_dir`
        endif
    endif
endfunction

" follow symlink and set working directory
autocmd BufEnter *
            \ call FollowSymlink() |
            \ call SetProjectRoot()

" Format python with autopep8
function! PepFmt()
  if executable('python3-autopep8')
    let line = line('.')
    let col = col('.')
    let path = expand('%')
    if filereadable(path)
      let joined_lines = system(printf('python3-autopep8 %s', shellescape(path)))
      if 0 == v:shell_error
        silent % delete _
        silent put=joined_lines
        silent 1 delete _
        silent call cursor(line, col)
      else
        call s:cexpr('line %l\, column %c of %f: %m', joined_lines)
      endif
    else
      call s:error(printf('cannot read a file: "%s"', path))
    endif
  else
    call s:error('cannot execute binary file: python3-autopep8')
  endif
endfunction

" W also w's
command W write

" }}}

" Misc keymaps {{{
" Toggle line wrapping
nnoremap <silent> <leader>w :set wrap!<CR>

" Move pop from ctrl-t
nnoremap <silent> <leader>] :pop<CR>

" Open tag definition in vertical split
nnoremap <C-W>[ :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
au Filetype go nnoremap <C-W>[ :vsp <CR>:exe "GoDef" <CR>

" Toggle paste
nnoremap <silent> <F12> :set paste!<CR>

" search from visual mode selection
vnoremap // y/<C-R>"<CR>"

" Toggle colorcolumn
nnoremap <silent> <leader>tc :call g:ToggleColorColumn()<CR>

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

" Map C-c to completion in insert mode. I'd rather use C-tab or S-tab but
" couldn't get them working right in terminal...
inoremap <C-c> <C-x><C-o>

" Toggle line numbers/relative numbers
nnoremap <silent> <leader>nn :set nu!<CR>
nnoremap <silent> <leader>nr :set rnu!<CR>
" }}}

" Filetypes {{{
" Set appropriate filetypes
autocmd BufEnter *.erb,*.rhtml setf eruby
autocmd BufEnter *.mako setf mako
autocmd BufEnter *.cib setf pcmk
autocmd BufEnter *.tdl setf xml
autocmd BufEnter *.nse setf lua
autocmd BufEnter *.cron setf crontab
autocmd BufEnter *.md setf markdown

" Strip trailing whitespace from code files on save
"autocmd FileType php,python,java,pl,javascript,c,cpp autocmd BufWritePre <buffer> :%s/\s\+$//e"

" Python stuff
autocmd FileType python
            \ setlocal tabstop=4
            \ softtabstop=4
            \ shiftwidth=4
            \ smarttab
            \ expandtab
"autocmd BufWritePost *.py call PepFmt()

" dart stuff
autocmd BufEnter *.dart setf dart
autocmd BufWritePost *.dart DartFmt

" PHP stuff
autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
" The following is for PHPCD. I'd love to use it but it's buggy as sin :( {{{
"autocmd FileType php call SetPHPCompleter()
"autocmd BufEnter *.php call SetPHPCompleter()

"function! SetPHPCompleter()
  ""If this is a composer project and update/install has run then use PHPCD
  "if filereadable(getcwd().'/composer.lock')
    "setlocal omnifunc=phpcd#CompletePHP
  ""Otherwise use phpcomplete
  "else
    "setlocal omnifunc=phpcomplete#CompletePHP
  "endif
"endfunction
"}}}

" }}}

" Plugins {{{
call plug#begin('~/.config/nvim/plug')

Plug 'chriskempson/base16-vim'                      " Base16 colors
Plug 'villainy/murmur-lightline'                    " My murmur lightline theme adapted from airline
Plug 'guns/xterm-color-table.vim',
            \ { 'on': 'XtermColorTable'}            " All 256 xterm colors with their RGB equivalents, right in Vim!
Plug 'itchyny/lightline.vim'                        " Syntax highlighting for hackers
Plug 'scrooloose/nerdtree'                          " A tree explorer plugin for vim.
Plug 'scrooloose/nerdcommenter'                     " Vim plugin for intensely orgasmic commenting
Plug 'junegunn/vim-easy-align'                      " A Vim alignment plugin
Plug 'tpope/vim-unimpaired'                         " unimpaired.vim: pairs of handy bracket
Plug 'embear/vim-foldsearch'                        " fold away lines that don't match a specific search pattern
Plug 'Rename'                                       " Rename a buffer within Vim and on disk
Plug 'ethanmuller/scratch.vim'                      " Plugin to create and use a scratch Vim buffer
Plug 'sjl/gundo.vim'                                " Gundo.vim is Vim plugin to visualize your Vim undo tree.
Plug 'othree/eregex.vim'                            " Perl/Ruby style regexp notation for Vim
Plug 'milkypostman/vim-togglelist'                  " Functions to toggle the [Location List] and the [Quickfix List] windows.
Plug 'tpope/vim-fugitive'                           " fugitive.vim: a Git wrapper so awesome, it should be illegal
Plug 'airblade/vim-gitgutter'                       " A Vim plugin which shows a git diff in the gutter (sign column) and stages/undoes hunks.
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets' " The ultimate snippet solution for Vim.
" TagBar seems to be crashing neovim even after this issue...
" https://github.com/neovim/neovim/issues/5817
Plug 'majutsushi/tagbar'                            " Vim plugin that displays tags in a window, ordered by scope
Plug 'vim-php/tagbar-phpctags.vim'                  " Using phpctags to generate php ctags index for vim plugin tagbar.
Plug 'yssl/QFEnter'                                 " Open a Quickfix item in a window you choose
Plug 'neomake/neomake'                              " A plugin for asynchronous :make using Neovim's job-control functionality
Plug 'villainy/vim-go', { 'for' : 'go' }            " My fork of faith/vim-go that actually works...
Plug 'Raimondi/delimitMate'                         " insert mode auto-completion for quotes, parens, brackets, etc.
Plug 'ludovicchabant/vim-gutentags'                 " A Vim plugin that manages your tag files
Plug 'junegunn/fzf', {
            \ 'dir': '~/.fzf',
            \ 'do': './install --bin'
            \ } | Plug 'junegunn/fzf.vim'           " A command-line fuzzy finder written in Go
Plug 'chazy/cscope_maps'                            " cscope keyboard mappings for VIM
"Plug 'tpope/vim-sleuth'                             " Heuristically set buffer options
Plug 'davidhalter/jedi'                             " Awesome autocompletion and static analysis library for python.
Plug 'kshenoy/vim-signature'                        " Plugin to toggle, display and navigate marks

" Padawan is nice but doesn't seem to handle completion for builtins
"if filereadable($HOME."/.composer/vendor/bin/padawan-server")
  "Plug 'mkusher/padawan.vim', { 'for' : 'php' }     " A vim plugin for padawan.php completion server
"endif

" This seems to be the best completion for PHP. Handles builtins and indexes
" Composer projects. Have to keep an eye on the PHPCD processes.  It's buggy
" and regularly crashes vim completely. Shame...
"Plug 'phpvim/phpcd.vim', {
      "\ 'for': 'php' , 
      "\ 'do': 'composer update' } " PHP Completion Daemon for Vim
" Guess I'm sticking to old stable phpcomplete for now
Plug 'shawncplus/phpcomplete.vim', { 'for' : 'php' }   " Improved PHP omnicompletion


" deoplete and sources
Plug 'Shougo/deoplete.nvim'                            " Dark powered asynchronous completion framework for neovim
Plug 'Shougo/neco-vim', { 'for' : 'vim' }              " The vim source for neocomplete/deoplete
Plug 'zchee/deoplete-go', { 'for' : 'go' }             " deoplete.nvim source for Go
Plug 'zchee/deoplete-jedi', { 'for' : 'python' }       " deoplete.nvim source for Python
Plug '~/src/mmorgan/deoplete-dart', { 'for' : 'dart' } " deoplete.nvim source for Dart (in-progress)

" Syntax highlighting
Plug 'elzr/vim-json', { 'for' : 'json' }
Plug 'dag/vim-fish', { 'for' : 'fish' }
Plug 'StanAngeloff/php.vim', { 'for' : 'php' }
Plug 'pangloss/vim-javascript', { 'for' : 'javascript' }
Plug 'mxw/vim-jsx', { 'for' : 'javascript' } 
Plug 'dart-lang/dart-vim-plugin', { 'for' : 'dart' }
Plug 'hdima/python-syntax', { 'for' : 'python' }
Plug 'sheerun/vim-polyglot' " A solid language pack for Vim.
Plug 'pearofducks/ansible-vim'
<<<<<<< HEAD
Plug 'ekalinin/Dockerfile.vim'
=======
Plug 'freitass/todo.txt-vim', { 'for': 'todo' }
>>>>>>> dc6793cd1fa34c5c31565dcd2ebf5d0508384f58

" Java omni-complete
Plug 'yuratomo/java-api-complete'
Plug 'yuratomo/java-api-javax'
Plug 'yuratomo/java-api-org'
Plug 'yuratomo/java-api-sun'
Plug 'yuratomo/java-api-servlet2.3'
Plug 'yuratomo/java-api-android'
Plug 'yuratomo/java-api-junit'

" Add plugins to &runtimepath
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

function! LightLineModified()
    if &filetype == "help"
        return ""
    elseif &modified
        return "+"
    elseif &modifiable
        return ""
    else
        return ""
    endif
endfunction

function! LightLineReadonly()
    if &filetype == "help"
        return ""
    elseif &readonly
        return ""
    else
        return ""
    endif
endfunction

function! LightLineFugitive()
    if exists("*fugitive#head")
        let branch = fugitive#head()
        return branch !=# '' ? ' '.branch : ''
    endif
    return ''
endfunction
" }}}

" base16 {{{
let base16colorspace=256  " Access colors present in 256 colorspace
colorscheme base16-default-dark
" }}}

" vim-easy-align {{{
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
" }}}

" vim-fugitive {{{
nmap <silent> <Leader>gs :Gstatus<CR>
nmap <silent> <Leader>gc :Gcommit<CR>
" }}}

" vim-gitgutter {{{
let g:gitgutter_enabled = 0
nmap <silent> <Leader>gg :GitGutterToggle<CR>
nmap <silent> <Leader>gn :GitGutterNextHunk<CR>
nmap <silent> <Leader>gp :GitGutterPrevHunk<CR>
" }}}

" eregex.vim {{{
let g:eregex_default_enable = 0
nnoremap <leader>/ :call eregex#toggle()<CR>
" }}}

" gundo.vim {{{
nnoremap <silent> U :GundoToggle<CR>
" }}}

" scratch.vim {{{
" Open scratch buffers
nmap <C-s>w :Sscratch<CR>
nmap <C-s>v :Vscratch<CR>
" }}}

" NERDTree {{{
nmap <silent> <C-x> :NERDTreeToggle<CR>
" "}}}

" fzf {{{
let $FZF_DEFAULT_COMMAND = 'find . -not -wholename "*.git/*"'
let g:fzf_layout = { 'up': '~30%' }
nmap ,ff :Files<CR>
nmap ,fh :Files $HOME<CR>
nmap ,fb :Buffers<CR>
nmap ,fr :Files /<CR>
nmap ,fc :Commits<CR>
nmap ,fs :Snippets<CR>
nmap ,ft :BTags<CR>
nmap ,fT :Tags<CR>
" }}}

" java-api-complete {{{
let g:javaapi#delay_dirs = [
            \ 'java-api-javax',
            \ 'java-api-org',
            \ 'java-api-sun',
            \ 'java-api-servlet2.3',
            \ 'java-api-android',
            \ ]

au BufNewFile,BufRead *.java    setl omnifunc=javaapi#complete
au CompleteDone *.java          call javaapi#showRef()
au BufNewFile,BufRead *.java    inoremap <expr> <c-down> javaapi#nextRef()
au BufNewFile,BufRead *.java    inoremap <expr> <c-up>   javaapi#prevRef()

if has("balloon_eval") && has("balloon_multiline") 
    au BufNewFile,BufRead *.java  setl bexpr=javaapi#balloon()
    au BufNewFile,BufRead *.java  setl ballooneval
endif
" }}}

" UltiSnips {{{
"vsplit when editing snippet file
let g:UltiSnipsEditSplit="vertical"
"Map tab/shifttab for entering snippet popup instead of whatever the insane
"default was
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-tab>"
"Integrate with YCM
let g:UltiSnipsExpandTrigger="<nop>"
let g:ulti_expand_or_jump_res = 0
"Local snippet vars
let g:snips_author = 'Michael Morgan <mmorgan@sevone.com>'
let g:snips_copyright = 'SevOne Inc.'
"Allow enter key to use a snippet
function! <SID>ExpandSnippetOrReturn()
    let snippet = UltiSnips#ExpandSnippetOrJump()
    if g:ulti_expand_or_jump_res > 0
        return snippet
    else
        return "\<C-Y>"
    endif
endfunction
imap <expr> <CR> pumvisible() ? "<C-R>=<SID>ExpandSnippetOrReturn()<CR>" : "<Plug>delimitMateCR"
" }}}

" vim-togglelist {{{
" Force quickfix window location
let g:toggle_list_copen_command="botright copen"
" }}}

" Tagbar {{{
nmap <silent> <C-t> :TagbarToggle<CR>
" Add .inc files for $dayjob
let g:tagbar_sort = 0
let g:tagbar_compact = 1
let g:tagbar_type_php = {
            \ 'ctagsargs' : '--extensions=+.inc'
            \ }
let g:tagbar_type_dart = {
            \ 'ctagsbin' : 'pub',
            \ 'ctagsargs' : ['global', 'run', 'dart_ctags:tags', '--skip-sort', '--line-numbers'],
            \ 'ctagstype' : 'dart',
            \ 'kinds'     : [
                \ 'c:classes',
                \ 'f:function',
                \ 'M:static method',
                \ 'm:method',
                \ 'i:field'
            \ ]
            \ }
" }}}

" vim-go {{{
let g:go_bin_path = $HOME . '/.go/bin'
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
" }}}

" gutentags {{{
" Exclude node_modules from gutentags or you'll just run out of memory have
" have a multi-GB tags file...
let g:gutentags_ctags_exclude = [ 'node_modules' ]
"let g:gutentags_enabled = 0
" }}}

" deoplete {{{
let g:deoplete#enable_at_startup = 1
"call deoplete#enable_logging('DEBUG', '/home/mmorgan/tmp/deoplete.log')
let g:deoplete#omni_patterns = {}
"let g:deoplete#omni_patterns.php = '\h\w*\|[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'

"Dart
let g:deoplete#sources#dart#dart_sdk_path = '/opt/dart/dart-sdk'
let g:deoplete#sources#dart#dart_analysis_server_flags = '--enable-instrumentation --instrumentation-log-file /tmp/dart_analysis.log --port 15151'

" }}}

" neomake {{{
autocmd BufWrite * :Neomake
" }}}

" phpcomplete-extended {{{
let g:phpcomplete_index_composer_command = '/usr/bin/composer'
" }}}

" padawan.vim {{{
"let $PATH=$PATH . ':' . expand('~/.composer/vendor/bin')
"let g:padawan#composer_command = "/usr/bin/php /usr/bin/composer"
"let g:padawan#cli = '/usr/bin/php '.$HOME.'/.composer/vendor/bin/padawan'
"let g:padawan#server_command = '/usr/bin/php '.$HOME.'/.composer/vendor/bin/padawan-server'
" }}}

" phpcd.vim {{{
let g:phpcd_php_cli_executable = '/usr/bin/php'
" }}}

" }}}

" Custom highlighting {{{
highlight Error ctermfg=0 ctermbg=1 guifg=#e4e4e4 guibg=#ab4642
" }}}

" Load local configs {{{
function! LoadLocalConfig()
  if filereadable(getcwd().'/.vimrc.local')
    source getcwd().'/.vimrc.local'
  endif
endfunction

autocmd BufReadPre * call LoadLocalConfig()
" }}}

" vim: foldmethod=marker ft=vim
