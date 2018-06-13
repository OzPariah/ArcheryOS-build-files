"test
if v:progname =~? "evim"
  finish
endif

" Get the defaults that most users want.
source $VIMRUNTIME/defaults.vim

set nobackup		" do not keep a backup file, use versions instead
set nowritebackup		" do not keep a backup file, use versions instead

if &t_Co > 2 || has("gui_running")
  set hlsearch
endif

if has("autocmd")

  augroup vimrcEx
  au!

  autocmd FileType text setlocal textwidth=78

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

if has('syntax') && has('eval')
  packadd! matchit
endif

set ignorecase
set smartcase

set hlsearch

set showmatch

set mat=2

set noerrorbells
set novisualbell
set t_vb=
set tm=500

syntax enable

set smarttab

set ai "Auto indent
set si "Smart indent

set number
set relativenumber

set clipboard=unnamedplus
set background=dark

map `` <Esc>/<++><Enter>"_c4l
inoremap `` <Esc>/<++><Enter>"_c4l
vnoremap `` <Esc>/<++><Enter>"_c4l
autocmd StdinReadPre * let s:std_in=1

