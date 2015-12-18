set ruler
set showmatch
set showmode


" Required to be able to use keypad keys and map missed escape sequences
set esckeys

" get easier to use and more user friendly vim defaults
" CAUTION: This option breaks some vi compatibility. 
"          Switch it off if you prefer real vi compatibility
set nocompatible

" Complete longest common string, then each full match
" enable this for bash compatible behaviour
" set wildmode=longest,full

" Try to get the correct main terminal type
if &term =~ "xterm"
    let myterm = "xterm"
else
    let myterm =  &term
endif
let myterm = substitute(myterm, "cons[0-9][0-9].*$",  "linux", "")
let myterm = substitute(myterm, "vt1[0-9][0-9].*$",   "vt100", "")
let myterm = substitute(myterm, "vt2[0-9][0-9].*$",   "vt220", "")
let myterm = substitute(myterm, "\\([^-]*\\)[_-].*$", "\\1",   "")

" Only do this part when compiled with support for autocommands. 
if has("autocmd") 
  " When editing a file, always jump to the last known cursor position. 
  " Don't do it when the position is invalid or when inside an event handler 
  " (happens when dropping a file on gvim). 
  autocmd BufReadPost * 
    \ if line("'\"") > 0 && line("'\"") <= line("$") | 
    \   exe "normal g`\"" | 
    \ endif 
 
endif " has("autocmd")

if has("gui_running")
  colorscheme desert
endif

syntax on
set modelines=0
set smarttab
set autoindent
set smartindent
set shiftwidth=2
set ts=2
set softtabstop=2
set expandtab
set nowritebackup
set showcmd
set statusline=%F%m%r%h\ [FORMAT={%ff}]\ [TYPE=%Y]\ [POS=%04l,%04v]
set ff=unix
set encoding=utf-8
"set encoding=latin1
set nu
set nofoldenable
set autoread

map <F10> :w!<CR>:!aspell -c %<CR>:e! %<CR>
set wildignore+=*.o,*.obj,*.cmi,*.cmo,*.cma,*.cmx,*.a,*.cmxa,*.rem,*.lib,*.dll,*.exe
set wildignore+=*.aux,*.blg,*.dvi,*.log,*.pdf,*.ps,*.eps
" disable expandtab for makefiles, so that command lines start with a \t
autocmd BufRead,BufWrite,BufNew *.mak set noexpandtab
autocmd BufRead,BufWrite,BufNew [mM]akefile* set noexpandtab
" files with name make.ti_c6x... are not recognized as makefiles
autocmd BufRead [mM]ake* set syntax=make
" currently there is no syntax description for lush, a lisp dialect
autocmd BufRead *.lsh set ft=lisp
" for gnuplot batch files
autocmd BufRead *.gp set ft=gnuplot

ab cperl #!/usr/bin/perl -w<CR><CR>use strict;<CR><CR>__END__<CR>Juan Pablo de la Cruz G.<ESC>gg

" octave
au BufRead,BufNewFile *.m  noremap X <ESC>:!echo "help <cword>" \| octave \| less<CR>
au BufRead,BufNewFile *.m highlight comment ctermfg=lightblue
au BufRead,BufNewFile *.m map <S-F5> <ESC>:w<CR>:!octave %<CR>

" perl
noremap _m :!perldoc <cword> <bar><bar> perldoc -m <cword><cr>
au BufRead,BufNewFile *.pl call SetPerlOptions()
function SetPerlOptions()
   noremap X :!perldoc <cword> <bar><bar> perldoc -f <cword><cr>
   map <F5> <ESC>:w<CR>:!perl -d %<CR>
   map <S-F5> <ESC>:w<CR>:!perl %<CR>
   map <F7> <ESC>:w<CR>:!perl -c %<CR>
   highlight comment ctermfg=lightblue
endfunction

" python
function SetPythonOptions()
  map <F5> <ESC>:w<CR>:!python %<CR>
  noremap X :!pydoc <cword><cr>
  set sw=2
  " fold on space
  noremap <space> za
endfunction
au BufRead,BufNewFile *.py call SetPythonOptions()

" ruby
function SetRubyOptions()
  map <S-F5> <ESC>:w<CR>:!ruby %<CR>
  map <F7> <ESC>:w<CR>:!ruby -c %<CR>
  noremap X :!ri <cword><cr>
  set sw=2
endfunction
au BufRead,BufNewFile *.rb call SetRubyOptions()

" c coding
au BufNewFile,BufRead *.c,*.cpp,*.h call SetCOptions()
function SetCOptions()
  " setlocal foldmethod=syntax
  " map <F6> ?{<CR>zf%<ESC>:nonhlsearch<CR>
  " map <S-F6> /}<CR>zf%<ESC>:nonhlsearch<CR>
  set tw=79
  " warns you if it finds lines exceeding the 80 characters limit
  syntax match Search /\%<80v.\%>77v/
  syntax match ErrorMsg /\%>79v.\+/
  " wrap visual selection with #if 0 #endif clauses
  vmap ;, '<ESC>di#if 0<CR><ESC>P`]I#endif<CR><ESC>'
  ab #i #include
  ab #d #define
  ab cmain #include <stdio.h><CR><CR>int main(int argc,char **argv)<CR>{<CR>	return 0;<CR>}<C-d><CR><ESC>gg
	map <F7> <ESC>:w<CR>:!make<CR>
endfunction

au BufNew,BufNewFile,BufRead *.js call SetJSOptions()
function SetJSOptions()
  set sw=2
  set expandtab
  map <S-F5> <ESC>:w<CR>:!node %<CR>
endfunction

" bash
au BufRead,BufNewFile *.sh map <S-F5> <ESC>:w<CR>:!%:p<CR>
ab getopts while getopts "" opt; do<CR>case $opt in<CR><TAB>*)<CR>;;<CR><C-d>esac<CR><C-d>done<CR>shift $((OPTIND-1))<CR><ESC>?""

set nocompatible
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Bundle 'Lokaltog/powerline' , {'rtp': 'powerline/bindings/vim/'}
Bundle 'scrooloose/nerdtree'
Bundle 'klen/python-mode'
Bundle 'davidhalter/jedi-vim'
call vundle#end()
filetype plugin indent on
set laststatus=2
" settings for python-mode
let g:pymode_rope = 0
let g:pymode_doc = 1
let g:pymode_doc_key = 'K'
let g:pymode_breakpoint=1
let g:pymode_breakpoint_bind='<leader>b'
let g:pymode_syntax=1
let g:pymode_folding=0

execute pathogen#infect()
filetype plugin indent on
