set enc=utf-8
set fenc=utf-8
set termencoding=utf-8
set nobackup
set directory=~/.vim/swp,.
set shiftwidth=4
set sts=4
set modelines=2
set modeline
set nocp
set tabstop=4        " tab width is 4 spaces
set shiftwidth=4     " indent also with 4 spaces
set expandtab        " expand tabs to spaces
"set linebreak        " break longline
"set textwidth=120
"set lazyredraw

" highlight matching braces
set showmatch
" intelligent comments
set comments=sl:/*,mb:\ *,elx:\ */

" incremental search that highlights results
set incsearch
set hlsearch

" highlight current line
set cursorline

" Smart backspace
set backspace=start,indent,eol

" Set vimdiff to ignore whitespace
set diffopt+=iwhite
set diffexpr=

set undofile
set undodir=~/.vimundo

" Stop warning me about leaving a modified buffer
set hidden

" Now that I use vim-paren-crosshairs, I need 256 colors in my console VIM
set t_Co=256

"mapping stuff
"
" in normal mode F2 will save the file
nmap <F2> :w<CR>
" in insert mode F2 will exit insert, save, enters insert again
imap <F2> <ESC>:w<CR>i
" switch between header/source with F4
map <F4> :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>

" build using makeprg with <F7>
map <F7> :make<CR>
" build using makeprg with <S-F7>
map <S-F7> :make clean all<CR>
" goto definition with F12
map <F12> <C-]>
map <F1> <C-w><C-w>

" Map SyntasticCheck to F6
noremap <silent> <F6> :SyntasticCheck<CR>
noremap! <silent> <F6> <ESC>:SyntasticCheck<CR>

noremap <silent> <F10> :NERDTreeToggle<CR>
noremap! <silent> <F10> <ESC>:NERDTreeToggle<CR>

" map F3 and SHIFT-F3 to toggle spell checking                         
nmap <F11> :setlocal spell spelllang=fr<CR>
imap <F11> <ESC>:setlocal spell spelllang=fr<CR>i
nmap <S-F11> :setlocal spell spelllang=<CR>
imap <S-F11> <ESC>:setlocal spell spelllang=<CR>i

" Ctrl-L clears the highlight from the last search
noremap <C-l> :nohlsearch<CR><C-l>
noremap! <C-l> <ESC>:nohlsearch<CR><C-l>

" TAB and Shift-TAB in normal mode cycle buffers
noremap <Tab> :bn<CR>
noremap <S-Tab> :bp<CR>

" Disable cursors (force myself to learn VI moves)
map <down> <nop>
map <left> <nop>
map <right> <nop>
map <up> <nop>

"imap <down> <nop>
"imap <left> <nop>
"imap <right> <nop>
"imap <up> <nop>

"fix azerty
map <S-q> <S-a>
map <&> <1>

map j gj
map k gk
"NerdTree
map t <C-w><C-w>
"map <C-/> \cc

"imap <C-/> <C-X><C-]>
imap <C-@> <C-X><C-N>
imap <C-o> <C-x><C-o>
"Tcomment
"nmap <C-/> <c-_><c-_>
nnoremap <C-/> <C-_><C-_>

" Much improved auto completion menus
"set completeopt=menuone,longest,preview
set completeopt=longest,menuone
:inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

"vim plug
call plug#begin('~/.vim/plugged')

Plug 'junegunn/seoul256.vim'
Plug 'junegunn/vim-easy-align'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'lervag/vimtex'
Plug 'Valloric/YouCompleteMe', { 'do': './install.sh' }
Plug 'vim-scripts/Align'
Plug 'xolox/vim-notes'
Plug 'xolox/vim-misc'
Plug 'gerw/vim-latex-suite'
Plug 'tpope/vim-surround'
Plug 'kien/ctrlp.vim'
Plug 'rking/ag.vim'
Plug 'chriskempson/base16-vim'
Plug 'vhdirk/vim-cmake'
Plug 'bling/vim-airline'
Plug 'tpope/vim-fugitive'
call plug#end()
"end vim plug

" tells NERDTree to use ASCII chars
" and to ignore some files
"
let g:NERDTreeDirArrows=0
let g:NERDTreeIgnore=['\.pyc$', '\.o$']

"
" Better TAB completion for files (like the shell)
"
if has("wildmenu")
    set wildmenu
    set wildmode=longest:full
    "set wildmode=longest,list
    " Ignore stuff (for TAB autocompletion)
    set wildignore+=*.a,*.o
    set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png
    set wildignore+=.DS_Store,.git,.hg,.svn
    set wildignore+=*~,*.swp,*.tmp
endif

" Syntax-coloring of files
syntax on
"colorscheme wombat256


" always show the status line
"set laststatus=2
"set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]
"              | | | | |  |   |      |  |     |    |
"              | | | | |  |   |      |  |     |    + current
"              | | | | |  |   |      |  |     |       column
"              | | | | |  |   |      |  |     +-- current line
"              | | | | |  |   |      |  +-- current % into file
"              | | | | |  |   |      +-- current syntax in
"              | | | | |  |   |          square brackets
"              | | | | |  |   +-- current fileformat
"              | | | | |  +-- number of lines
"              | | | | +-- preview flag in square brackets
"              | | | +-- help flag in square brackets
"              | | +-- readonly flag in square brackets
"              | +-- rodified flag in square brackets
"              +-- full path to file in the buffer

"



" After 'f' in normal mode, I always mistype 'search next' - use space for ;
noremap <space> ;

" Manpage for word under cursor via 'K' in command mode
runtime ftplugin/man.vim
noremap <buffer> <silent> K :exe "Man" expand('<cword>') <CR>


let g:syntastic_mode_map = {
    \ 'mode': 'active',
    \ 'active_filetypes': [],
    \ 'passive_filetypes': ['cpp', 'c'] }
    "\ assive_filetypes': ['python', 'cpp', 'c'] }

" Now that I use the CtrlP plugin, a very useful shortcut is to open
" an XTerm in the folder of the currently opened file:
"noremap <silent> <F2> :!urxvtc -e "cd %:p:h ; zsh" &<CR><CR>
"noremap <silent> <Esc>OQ :!urxvtc -e "cd %:p:h ; zsh" &<CR><CR>
"let g:ctrlp_working_path_mode = 0
"let g:ctrlp_clear_cache_on_exit = 0

" Powerline settings
let g:Powerline_stl_path_style = 'short'

"Auto toggle paste when insert buffer
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"
inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
function! XTermPasteBegin()
    set pastetoggle=<Esc>[201~
    set paste
    return ""
endfunction


if has("gui_running")
    set guitablabel=%-0.12t%M
    set guioptions-=T
    set guioptions-=r
    set guioptions-=L
    set guioptions+=a
    set guioptions-=m
    set listchars=tab:▸\ ,eol:¬ " Invisibles using the Textmate style
    "set guifont=monospace\ 9 
    "set guifont=Sauce\ Code\ Powerline\ 9
    "set guifont=Inconsolata\ for\ Powerline\ 11
    set guifont=Terminus\ 11
    set background=light
    " colorscheme solarized
    "colorscheme jellybeans
    "Darkest background
    let g:seoul256_background = 233
    colo seoul256
    "colo zenburn
endif


au BufNewFile,BufRead *.c,*.cc,*.cpp,*.h call SetupCandCPPenviron()
function! SetupCandCPPenviron()
    "
    " Search path for 'gf' command (e.g. open #include-d files)
    "
    set path+=/usr/include/c++/**

    " Tags
    " If I ever need to generate tags on the fly, I uncomment this:
    noremap <C-F11> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
    set tags+=/usr/include/tags

    "
    " Toggle TagList window with F8
    "
    noremap <buffer> <silent> <F8> :TlistToggle<CR>
    noremap! <buffer> <silent> <F8> <ESC>:TlistToggle<CR>
    let g:Tlist_Use_Right_Window = 1

    "
    " Especially for C and C++, use section 3 of the manpages
    "
    noremap <buffer> <silent> K :exe "Man" 3 expand('<cword>') <CR>
endfunction

augroup vimrc_autocmds
  autocmd BufEnter * highlight OverLength ctermbg=darkgrey guibg=#592929
  autocmd BufEnter * match OverLength /\%120v.*/
augroup END


if expand('%:t')=="note:newtodo" 
    colorscheme slate 
    set guifont=monaco 9 
else
    "colorscheme zenburn
    "colorscheme jellybeans

    "Darkest background
    let g:seoul256_background = 233
    colo seoul256
    " Switch
    set background=dark
endif
let g:ctrlp_map = '<c-p>'

let g:syntastic_check_on_open=1
let g:syntastic_enable_signs=1
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'

let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
let g:tcommentModeExtra='>>'
let g:tcommentOpModeExtra='>>'


let g:notes_unicode_enabled = 1
let g:notes_list_bullets=['•', '◦', '▸', '▹', '▪', '▫']
let g:notes_tab_indents=1
let g:notes_directories=['~/.notes']

"latex suite
set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'
"cycle through keywords
set iskeyword+=:
let g:Tex_DefaultTargetFormat = 'pdf'
"let g:Tex_CompileRule_pdf = 'latexmk -pdf -pv -g'
"g:Tex_CompileRule_pdf 'pdflatex -interaction=nonstopmode $*'

set nofoldenable
set nocompatible   " Disable vi-compatibility
set laststatus=2   " Always show the statusline
set encoding=utf-8 " Necessary to show Unicode glyphs


  if !exists('g:airline_symbols')
    let g:airline_symbols = {}
  endif


    " unicode symbols
  let g:airline_left_sep = '»'
  let g:airline_left_sep = '▶'
  let g:airline_right_sep = '«'
  let g:airline_right_sep = '◀'
  let g:airline_symbols.crypt = '🔒'
  let g:airline_symbols.linenr = '␊'
  let g:airline_symbols.linenr = '␤'
  let g:airline_symbols.linenr = '¶'
  let g:airline_symbols.paste = 'ρ'
  let g:airline_symbols.paste = 'Þ'
  let g:airline_symbols.whitespace = 'Ξ'

  " powerline symbols
  let g:airline_left_sep = ''
  let g:airline_left_alt_sep = ''
  let g:airline_right_sep = ''
  let g:airline_right_alt_sep = ''
  let g:airline_symbols.branch = ''
  let g:airline_symbols.readonly = ''
  let g:airline_symbols.linenr = ''


  let g:airline_theme='zenburn'


  let g:airline_detect_crypt=0
  let g:airline#extensions#whitespace#enabled = 0
  let g:airline_extensions = ['tabline', 'branch']
