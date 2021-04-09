function! younger#before() abort
    " let g:neomake_enabled_c_makers = ['clang']
    " nnoremap jk <esc>
    let g:neoformat_python_black = {
        \ 'exe': 'black',
        \ 'stdin': 1,
        \ 'args': ['-q', '-'],
        \ }
    let g:neoformat_enabled_python = ['black']
    let g:tagbar_ctags_bin = 'C:/Users/younger/scoop/apps/universal-ctags/current/ctags'

endfunction

function! younger#after() abort
    " iunmap jk
endfunction


