call pathogen#infect()
call pathogen#helptags()
se nobackup
se directory=~/.vim/swp,.
se shiftwidth=4
se sts=4
se modelines=2
se modeline
se nocp
set tabstop=4        " tab width is 4 spaces
set shiftwidth=4     " indent also with 4 spaces
set expandtab        " expand tabs to spaces


if has("autocmd")
    filetype on
    filetype indent on
    filetype plugin on
endif

" se autoindent
se undofile
se undodir=~/.vimundo
"noremap <ESC>OP <F1>


" auto-closes preview window after you select what to auto-complete with
"autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
"autocmd InsertLeave * if pumvisible() == 0|pclose|endif


"
" maps NERDTree to F10
"
noremap <silent> <F10> :NERDTreeToggle<CR>
noremap! <silent> <F10> <ESC>:NERDTreeToggle<CR>


"
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

"
" My attempt at easy navigation/creation of windows:
"   Ctrl-Cursor keys to navigate open windows
"   Ctrl-F12 to close current window
" Also...
"   f4 TO NAVigate to next compile/link/flake8 error
"   F3 to navigate to next Syntastic error (first, invoke :Errors)
"
function! WinMove(key)
  let t:curwin = winnr()
  exec "wincmd ".a:key
  " if (t:curwin == winnr())
  "   " we havent moved
  "   " Create window in that direction,
  "   if (match(a:key,'[jk]')) "were we going up/down
  "     wincmd v
  "   else
  "     wincmd s
  "   endif
  "   exec "wincmd ".a:key
  " endif
endfunction
function! WinClose()
  if &filetype == "man"
    bd!
  else
    bd
  endif
endfunction

"
" In cmd mode, + and - vertically enlarge/shrink a split
"
"noremap  <silent> = :call WinMove('+')<CR>
"noremap  <silent> - :call WinMove('-')<CR>
"noremap  <silent> + :call WinMove('>')<CR>
"noremap  <silent> _ :call WinMove('<')<CR>


"
" incremental search that highlights results
"
se incsearch
se hlsearch
" Ctrl-L clears the highlight from the last search
noremap <C-l> :nohlsearch<CR><C-l>
noremap! <C-l> <ESC>:nohlsearch<CR><C-l>


"
" Fix insert-mode cursor keys in FreeBSD
"
if has("unix")
  let myosuname = system("uname")
  if myosuname =~ "FreeBSD"
    set term=cons25
  elseif myosuname =~ "Linux"
    set term=linux
  endif
endif


"
" Reselect visual block after indenting
"
"vnoremap < <gv
"vnoremap > >gv


"
" Keep search pattern at the center of the screen
"
"nnoremap <silent> n nzz
"nnoremap <silent> N Nzz
"nnoremap <silent> * *zz
"nnoremap <silent> # #zz


"
" Make Y behave like other capitals
"
"noremap Y y$


"
" Force Saving Files that Require Root Permission
"
"cmap w!! %!sudo tee > /dev/null %

"
" Syntastic - Ignore 'too long lines' from flake8 report
"
"let g:syntastic_python_checker_args = "--ignore=E501,E225"


"
"when the vim window is resized resize the vsplit panes as well
"
"au VimResized * exe "normal! \<c-w>="


"
" TAB and Shift-TAB in normal mode cycle buffers
"
noremap <Tab> :bn<CR>
noremap <S-Tab> :bp<CR>


"
" Syntax-coloring of files
"
syntax on
"colorscheme elflord
"colorscheme skittles_dark 
if expand('%:t')==".mynotes" 
    colorscheme note 
else
    colorscheme zenburn
endif
"colorscheme wombat256
"
" Disable cursors (force myself to learn VI moves)
"
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
"
" highlight current line
"
set cursorline

"
" always show the status line
"
set laststatus=2
set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]
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
" But we must be able to hide them if we want to
"
function! TabsAndColumn80AndNumbers ()
    "
    " tabs must be visible
    "
    set list!
    set number!
    set listchars=tab:>-,trail:-
    if exists('+colorcolumn')
        "
        " Show me column 80
        "
        if &colorcolumn == ""
            set colorcolumn=80
        else
            set colorcolumn=
        endif
    endif
endfunction
nnoremap <Esc>[20~ :call TabsAndColumn80AndNumbers()<CR>
nnoremap <F9> :call TabsAndColumn80AndNumbers()<CR>

"
" Smart backspace
"
set backspace=start,indent,eol

"
" Avoid TABs like the plague
"
set expandtab
" Set vimdiff to ignore whitespace
set diffopt+=iwhite
set diffexpr=

"
" Much improved auto completion menus
"
set completeopt=menuone,longest,preview

"
" Use C-space for omni completion in insert mode.
" Disabled currently, because I am testing the
" 'YouCompleteMe' plugin...
"
"inoremap <expr> <C-Space> pumvisible() \|\| &omnifunc == '' ?
"            \ "\<lt>C-n>" :
"            \ "\<lt>C-x>\<lt>C-o><c-r>=pumvisible() ?" .
"            \ "\"\\<lt>c-n>\\<lt>c-p>\\<lt>c-n>\" :" .
"            \ "\" \\<lt>bs>\\<lt>C-n>\"\<CR>"
"imap <C-@> <C-Space>

"
" Stop warning me about leaving a modified buffer
"
set hidden

"
" Show command as I type it
"
"set showcmd

"
" Now that I use vim-paren-crosshairs, I need 256 colors in my console VIM
"
set t_Co=256

"
" After 'f' in normal mode, I always mistype 'search next' - use space for ;
"
noremap <space> ;

"
" Manpage for word under cursor via 'K' in command mode
"
runtime ftplugin/man.vim
noremap <buffer> <silent> K :exe "Man" expand('<cword>') <CR>

"
" Map SyntasticCheck to F6
"
noremap <silent> <F6> :SyntasticCheck<CR>
noremap! <silent> <F6> <ESC>:SyntasticCheck<CR>

let g:syntastic_mode_map = {
    \ 'mode': 'active',
    \ 'active_filetypes': [],
    \ 'passive_filetypes': ['cpp', 'c'] }
    "\ assive_filetypes': ['python', 'cpp', 'c'] }

"
" Now that I use the CtrlP plugin, a very useful shortcut is to open
" an XTerm in the folder of the currently opened file:
"
noremap <silent> <F2> :!urxvtc -e "cd %:p:h ; zsh" &<CR><CR>
noremap <silent> <Esc>OQ :!urxvtc -e "cd %:p:h ; zsh" &<CR><CR>
let g:ctrlp_working_path_mode = 0
let g:ctrlp_clear_cache_on_exit = 0

"
" Powerline settings
"
let g:Powerline_stl_path_style = 'short'

"
" Language-specific section
"

"
" For C and C++
"
    
" libclang use is mandatory now
"
"let g:clang_use_library = 1
let g:clang_use_library = 1
"set g:clang_library_path = /usr/lib64/llvm/libclang.so

" map F3 and SHIFT-F3 to toggle spell checking                         
nmap <F11> :setlocal spell spelllang=fr<CR>
imap <F11> <ESC>:setlocal spell spelllang=fr<CR>i
nmap <S-F11> :setlocal spell spelllang=<CR>
imap <S-F11> <ESC>:setlocal spell spelllang=<CR>i
set pastetoggle=<F2>


map j gj
map k gk
"NerdTree
map t <C-w><C-w>
map <C-/> \cc

"imap <C-/> <C-X><C-]>
imap <C-@> <C-X><C-N>
imap <C-o> <C-x><C-o>

au BufNewFile,BufRead *.c,*.cc,*.cpp,*.h call SetupCandCPPenviron()
function! SetupCandCPPenviron()
    "
    " Search path for 'gf' command (e.g. open #include-d files)
    "
    set path+=/usr/include/c++/**

    "
    " Tags
    "
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
