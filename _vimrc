
" Normally this if-block is not needed, because `:set nocp` is done
" automatically when .vimrc is found. However, this might be useful
" when you execute `vim -u .vimrc` from the command line.
if &compatible
  " :set nocompatible should not be executed twice to avoid side effects
  set nocompatible
endif

set ttimeout
set ttimeoutlen=100
set display+=lastline
set formatoptions+=j            " Delete comment character when joining commented lines
set history=1000                " Keep 1000 lines of command line history
set tabpagemax=50               " Maximum number of tab pages
set viminfo^=!                  " Save and restore global variables

source $LocalAppData/nvim/init.vim