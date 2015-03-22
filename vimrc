syntax on
set smarttab
set smartindent
set sw=2
set tabstop=2
set expandtab
set tw=80
set nu
set showcmd
set ruler
set showmatch
set nowritebackup
" set encoding=utf-8
set encoding=latin1
set wildignore+=*.o,*.obj,*.cmi,*.cmo,*.cma,*.cmx,*.a,*.cmxa,*.rem,*.lib,*.dll
set wildignore+=*.exe,*.aux,*.blg,*.dvi,*.log,*.pdf,*.ps,*.eps


fun CSettings()
  " wrap C code around with #if 0 ... #endif
  vmap ;, '<O<Esc>i#if 0<Esc>'>o<Esc>i#endif<Esc>
  set foldmethod=syntax
  map <F7> <ESC>:w<CR>:!make -f Makefile \| less<CR>
  let Tlist_Auto_Open      = 0
  let Tlist_Exit_OnlyWindow = 1
  let Tlist_File_Fold_Auto_Close = 1
  let Tlist_Process_File_Always = 1
"  TlistAddFiles $PWD/source/hlib/*.c
"  TlistAddFiles $PWD/include/*.h
  nnoremap <silent> tt :TlistToggle<CR>
  nnoremap <silent> tu :TlistUpdate<CR>
  set path=/usr/include,./,$HOME/local/include

  " add recursive function which searches for a tags file upwards until finding
  " one or reaching root
  set tags=./tags,tags
endfun

fun PythonSettings()
  map <S-F5>  <ESC>:w<CR>:!python -B %<CR>
  map <F5>  <ESC>:w<CR>:!idle %<CR>
  " check syntax
  map <F7>  <ESC>:w<CR>:!python -B -m py_compile %<CR>
  set foldmethod=syntax
  map ;st <ESC>opdb.set_trace()<ESC>:w<CR>
  let Tlist_Auto_Open      = 0
  let Tlist_Exit_OnlyWindow = 1
  let Tlist_File_Fold_Auto_Close = 1
  let Tlist_Process_File_Always = 1
"  TlistAddFiles ./*.py
  nnoremap <silent> tt :TlistToggle<CR>
  nnoremap <silent> tu :TlistUpdate<CR>
endfun

fun DjangoSettings()
  ab {{ {{  }}<ESC>3hi
  ab {% {%  %}<ESC>3hi
endfun

fun RubySettings()
  map <S-F5> <ESC>:w<CR>:!ruby %<CR>
  map <F5> <ESC>:w<CR>:!xterm irb %<CR>
  map <F7> <ESC>:w<CR>:!ruby -c %<CR>
  noremap X :!ri <cword><cr>
endfun

fun OctaveSettings()
  noremap X <ESC>:!echo "help <cword>" \| octave \| less<CR>
  highlight comment ctermfg=lightblue
  map <S-F5> <ESC>:w<CR>:!octave %<CR>
endfun

" Need to see how to automate wrapping around code in python
" try:
" 	CODE
" except:
" 	import pdb, traceback
" 	typ, value, tb = sys.exc_info()
"   traceback.print_exc()
"   pdb.post_mortem(tb)

au BufNewFile,BufRead *.py          call PythonSettings()
au BufNewFile,BufRead *.html        call DjangoSettings()
au BufRead,BufNewFile *.rb          call RubySettings()
au BufRead,BufNewFile	*.c,*.cpp,*.h call CSettings()
au BufRead,BufNewFile *.m           call OctaveSettings()
au BufNewFile,BufRead [mM]akefile set noexpandtab
au BufNewFile,BufRead [mM]akefile map <F7> <ESC>:w<CR>:!make -f %<CR>

fun BashSettings()
  ab getopts while getopts "" opt; do<CR>case $opt in<CR><TAB>*)<CR>;;<CR><C-d>esac<CR><C-d>done<CR>shift $((OPTIND-1))<CR><ESC>?""
  map <S-F5> <ESC>:w<CR>:!%:p<CR>
  map <C-h> <ESC>ggi<CR><ESC>ki# Distributed under the GPLv2 license<CR># Juan Pablo de la Cruz Gutierrez<CR><ESC>:w<CR>
endfun
au BufRead,BufNewFile *.sh          call BashSettings()


autocmd BufWritePre,FileWritePre *.html   ks|call LastMod()|'s
fun LastMod()
	if line("$") > 20
	  let l = 20
	else
		let l = line("$")
  endif
	exe "1," . l . "g/Last modified: /s/Last modified: .*/Last modified: " .  
			\ strftime("%Y %b %d")
endfun

set omnifunc=syntaxcomplete#Complete

nnoremap <silent> ]l :call NextIndent(0,1,0,1)<CR>

" set graphical font in gvim
" :set gfn? returns the name of the currently used graphical font
" another possibility is to call :set guifont? and then call
" :set guifont with the result
if has('gui_running')
  set gfn=Monospace\ 9
  colorscheme desert
endif

set runtimepath+=/home/juampa/source/tools/YouCompleteMe
