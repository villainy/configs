" General settings {{{
set shell=/usr/bin/bash

" Use GUI colors for the terminal. Enable this when TrueColor is working
"set termguicolors

" 4 is definitely correct
set shiftwidth=4
set softtabstop=4
set tabstop=4
" Use tabs... because $dayjob...
set noexpandtab

"Send cscope output to quickfix
set cscopequickfix=s-,c-,d-,i-,t-,e-
" Disable verbose cscope to hide duplicate db warnings
set nocscopeverbose

" Auto-close preview window after autocomplete
"autocmd CompleteDone * pclose
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

set mouse=
set autoindent
set ignorecase
set smartcase
set foldmethod=indent
set foldlevel=99
set ruler
set modeline
set incsearch
set number
set hidden
set cursorline
set encoding=utf-8
set fillchars+=stl:\ ,stlnc:\
set laststatus=2
set background=dark
set listchars=tab:\|\ 
set splitright
set noshowmode
" }}}

" Plugins {{{
call plug#begin('~/.config/nvim/plug')
 
Plug 'chriskempson/base16-vim'                            " Base16 colors
Plug 'villainy/murmur-lightline'                          " My murmur lightline theme adapted from airline
Plug 'itchyny/lightline.vim'                              " Syntax highlighting for hackers
Plug 'scrooloose/nerdtree'                                " A tree explorer plugin for vim.
Plug 'scrooloose/nerdcommenter'                           " Vim plugin for intensely orgasmic commenting
Plug 'junegunn/vim-easy-align'                            " A Vim alignment plugin
Plug 'tpope/vim-unimpaired'                               " unimpaired.vim: pairs of handy bracket
Plug 'embear/vim-foldsearch'                              " fold away lines that don't match a specific search pattern
Plug 'Rename'                                             " Rename a buffer within Vim and on disk
Plug 'ethanmuller/scratch.vim'                            " Plugin to create and use a scratch Vim buffer
Plug 'sjl/gundo.vim'                                      " Gundo.vim is Vim plugin to visualize your Vim undo tree.
Plug 'othree/eregex.vim'                                  " Perl/Ruby style regexp notation for Vim
Plug 'milkypostman/vim-togglelist'                        " Functions to toggle the [Location List] and the [Quickfix List] windows.
Plug 'tpope/vim-fugitive'                                 " fugitive.vim: a Git wrapper so awesome, it should be illegal
Plug 'airblade/vim-gitgutter'                             " A Vim plugin which shows a git diff in the gutter (sign column) and stages/undoes hunks.
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'       " The ultimate snippet solution for Vim.
Plug 'regedarek/ZoomWin'                                  " Zoom in/out of windows
Plug 'majutsushi/tagbar'                                  " Vim plugin that displays tags in a window, ordered by scope
Plug 'vim-php/tagbar-phpctags.vim'                        " Using phpctags to generate php ctags index for vim plugin tagbar.
Plug 'yssl/QFEnter'                                       " Open a Quickfix item in a window you choose
Plug 'neomake/neomake'                                    " A plugin for asynchronous :make using Neovim's job-control functionality
Plug 'Shougo/deoplete.nvim'                               " Dark powered asynchronous completion framework for neovim
Plug 'villainy/vim-go', { 'for' : 'go' }                  " My fork of faith/vim-go that actually works...
Plug 'Raimondi/delimitMate'                               " insert mode auto-completion for quotes, parens, brackets, etc.
Plug 'ludovicchabant/vim-gutentags'                       " A Vim plugin that manages your tag files
Plug 'junegunn/fzf', { 'dir': '~/.fzf',
	\ 'do': './install --bin' } | Plug 'junegunn/fzf.vim' " A command-line fuzzy finder written in Go
Plug 'chazy/cscope_maps'                                  " cscope keyboard mappings for VIM

" Syntax highlighting
Plug 'elzr/vim-json', { 'for' : 'json' }
Plug 'dag/vim-fish', { 'for' : 'fish' }
Plug 'StanAngeloff/php.vim', { 'for' : 'php' }
Plug 'pangloss/vim-javascript', { 'for' : 'javascript' }
Plug 'mxw/vim-jsx', { 'for' : 'javascript' } 

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
nnoremap <silent> <leader>cc :call g:ToggleColorColumn()<CR>

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %
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

" Appropriate python settings
autocmd FileType python
    \ setlocal tabstop=4
    \ softtabstop=4
    \ shiftwidth=4
    \ smarttab
    \ expandtab
" }}}

" Plugin settings {{{

" lightline.vim {{{
let g:lightline = {
			\ 'colorscheme': 'murmur',
			\ 'active': {
			\	'left': [ [ 'mode', 'paste' ],
			\				[ 'fugitive', 'readonly', 'filename', 'modified' ] ]
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
  return exists('*fugitive#head') ? fugitive#head() : ''
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

" Tagbar {{{
nmap <silent> <C-t> :TagbarToggle<CR>
" }}}

" fzf {{{
let $FZF_DEFAULT_COMMAND = 'find . -not -wholename "*.git/*"'
let g:fzf_layout = { 'up': '~30%' }
nmap ,ff :Files<CR>
nmap ,fh :Files $HOME<CR>
nmap ,fb :Buffers<CR>
nmap ,fr :Files /<CR>
nmap ,fc :Commits<CR>
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
" Add .inc files for $dayjob
let g:tagbar_sort = 0
let g:tagbar_compact = 1
let g:tagbar_type_php = {
	\ 'ctagsargs' : '--extensions=+.inc'
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
let g:gutentags_exclude = [ 'node_modules' ]
" }}}

" deoplete {{{
let g:deoplete#enable_at_startup = 1
" }}}

" }}}

" Custom highlighting last {{{
highlight Folded ctermbg=0
highlight LineNr ctermbg=0
highlight Comment term=bold ctermfg=14 guifg=#80a0ff
highlight CursorLineNr cterm=bold ctermbg=235 ctermfg=15
highlight CursorLine ctermbg=235
highlight StatusLineNC ctermbg=0
highlight FoldColumn ctermbg=0
highlight SignColumn ctermbg=0
highlight Pmenu ctermbg=0
highlight TabLine ctermbg=0
highlight TabLineSel ctermbg=0
highlight TabLineFill ctermbg=0
highlight CursorColumn ctermbg=0
highlight ColorColumn ctermbg=0
highlight Todo ctermbg=0
highlight GitGutterAdd ctermbg=0
highlight GitGutterChange ctermbg=0
highlight GitGutterDelete ctermbg=0
highlight GitGutterChangeDelete ctermbg=0
highlight SignifySignAdd ctermbg=0
highlight SignifySignChange ctermbg=0
highlight SignifySignDelete ctermbg=0
highlight PMenu ctermfg=27 ctermbg=234 guifg=#F5F5F5 guibg=#1C1C1C
highlight PMenuSel ctermfg=15 ctermbg=27 guifg=#FFFFFF guibg=#5F87FF
highlight VertSplit ctermfg=234 ctermbg=234
highlight DiffAdd term=bold ctermfg=2 ctermbg=237
highlight DiffChange term=bold ctermfg=8 ctermbg=237
highlight DiffDelete term=bold ctermfg=1 ctermbg=237
highlight DiffText term=reverse cterm=bold ctermfg=4 ctermbg=237
highlight Visual term=reverse ctermbg=237 guibg=#383838
highlight Directory guifg=#7cafc2
highlight Question guifg=#7cafc2
highlight Title guifg=#7cafc2
highlight DiffText guifg=#7cafc2
highlight Conceal guifg=#7cafc2
highlight Function guifg=#7cafc2
highlight Include guifg=#7cafc2
highlight DiffLine guifg=#7cafc2
highlight GitGutterChange guifg=#7cafc2
highlight markdownHeadingDelimiter guifg=#7cafc2
highlight NERDTreeDirSlash guifg=#7cafc2
highlight rubyAttribute guifg=#7cafc2
highlight sassMixinName guifg=#7cafc2
highlight SignifySignChange guifg=#7cafc2
highlight Search ctermbg=166 ctermfg=0
highlight colorcolumn term=underline ctermbg=235 guibg=#282828
highlight Character ctermfg=1 guifg=#ab4642
highlight Number ctermfg=9 guifg=#dc9656
highlight Boolean ctermfg=9 guifg=#dc9656
highlight Float ctermfg=9 guifg=#dc9656
highlight SpecialChar ctermfg=14 guifg=#a16946
highlight Delimiter ctermfg=14 guifg=#a16946
" }}}

" vim: foldmethod=marker ft=vim
