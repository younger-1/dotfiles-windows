" An example for a gvimrc file. " " The commands in this are executed when the GUI is started, after the vimrc
" has been executed.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2016 Apr 05
"
" To use it, copy it to
"         for Unix:  ~/.gvimrc
"        for Amiga:  s:.gvimrc
"   for MS-Windows:  $VIM\_gvimrc
"        for Haiku:  ~/config/settings/vim/gvimrc
"      for OpenVMS:  sys$login:.gvimrc


""""""""""""""""""""""
"      Colorscheme   "
""""""""""""""""""""""

" [Color]
" When starting the GUI, the default value for 'background' will be "light"

" colorscheme torte
" colorscheme seoul256-light


""""""""""""""""""""""
"      Settings      "
""""""""""""""""""""""

" set noguipty      " Make external commands work through a pipe instead of a pseudo-tty
set cmdheight=1	    " Make command line one lines high
set nomousehide	    " Don't hide the mouse when typing text

" Make shift-insert work like in Xterm
" map <S-Insert> <MiddleMouse>
" map! <S-Insert> <MiddleMouse>



" [GUI Font]
" This will bring up a font requester, where you can pick the font you want.
" set guifont=*

" GVim-bad-char:  Delugia_Nerd_Font, JetBrainsMono_NF, Consolas,
"                 Cascadia_Code, Cascadia_Mono, CaskaydiaCove_NF, 
"                 FiraCode_NF, FiraMono_NF, FuraMono_NF 
" { b for bold, i for italic, W300 for light, W200 for extraLight }
" set guifont=Hack_NF:h11
" set guifont=DejaVuSansMono_NF:h11
set guifont=等距更纱黑体_SC:h14
" set guifont=Sarasa_Term_SC_Light:h14:W300
" set guifont=Sarasa_Term_SC_Extralight:h14:W200:i
" set guifont=Iosevka_NF:h12


""""""""""""""""""""""
"      Appearance    "
""""""""""""""""""""""

" [Menu]
" Rebuild menu without restarting Vim
" source $VIMRUNTIME/delmenu.vim
" source <your-new-menu-file>
" source $VIMRUNTIME/menu.vim

" [Position]
set guiheadroom=0

" [Gui Options]
set guioptions-=T " Removes GUI bars
" set guioptions-=l " Removes scrollbars
" set guioptions-=r " Removes scrollbars
" set guioptions-=b " Removes scrollbars
set guioptions-=e " Disables the GUI tab line in favor of the plain text version, 
set guioptions+=c       " Console-like dialogs are used instead of graphical popup ones.



" Vim and gVim cursor
" set guicursor=n-v-c:block,o:hor50,i-ci:hor15,r-cr:hor30,sm:block
" set guicursor=n-v-c:block-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor,sm:block-Cursor-blinkwait175-blinkoff150-blinkon175



" set winaltkeys=no       " Don't use ALT keys for gui window's menus.

" Only for Win32
autocmd GUIEnter * simalt ~x
