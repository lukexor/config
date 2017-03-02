runtime after/ftplugin/global/formatoptions.vim
runtime after/ftplugin/global/shiftfour.vim
runtime after/ftplugin/global/indent.vim
runtime custom_plugins/trackperlvars.vim

augroup Perl_Setup
	autocmd!
	autocmd BufNewFile *.pl :0r $HOME/.vim/templates/perl/pl_script
	autocmd BufNewFile *.pm :0r $HOME/.vim/templates/perl/pm_module
	autocmd BufNewFile *.t :0r $HOME/.vim/templates/perl/test
augroup END
augroup LoadProject
	autocmd!
	autocmd BufWinEnter * call SetProjectConfig()
augroup END

let g:syntastic_enable_perl_checker=1
let g:syntastic_perl_checkers=['perl', 'perlcritic']
let g:syntastic_perl_lib_path=[ './lib' ]
let b:cmt = exists('b:cmt') ? b:cmt : '#'
let perl_sub_pat = '^\s*\%(has\|sub\|func\|method\|package\)\s\+'
" These settings are for perl.vim syntax
let perl_include_pod=1    " Syntax highlight pod documentation correctly
let perl_extended_vars=1    " Syntax color complex things like @{${'foo'}}

Xnoremap <silent> <buffer> <leader>F  [Run perltidy] :!perltidy --quiet --standard-output --nostandard-error-output<CR>
Nnoremap <silent> <buffer> cv         [Rename perl variable] <Plug>(TPVRenameNormalGlobal)
Vnoremap <silent> <buffer> cv         [Visual rename perl variable] <Plug>(TPVRenameVisual)
" Nnoremap <silent> <buffer> *          [Search for next instance of perl variable] <Plug>(TPVLocateNext)
" Nnoremap <silent> <buffer> #          [Search for next instance of perl variable] <Plug>(TPVLocatePrev)
Nnoremap <silent> <buffer> gd         [Locate perl variable declaration] <Plug>(TPVLocateDeclaration)
Nnoremap <silent> <buffer> tt         [Lock tracking of perl variable] <Plug>(TPVToggleTracking)
Nnoremap <silent> <buffer> <expr> zs  [Create folds around current search ] FS_FoldAroundTarget(@/, {'context':1})
Nnoremap <silent> <buffer> <expr> zp  [Create folds around perl subroutines] FS_FoldAroundTarget(perl_sub_pat,{'context':1})
Nnoremap <silent> <buffer> <expr> za  [Create folds showing only subroutines and comments] FS_FoldAroundTarget(perl_sub_pat.'\zs\\|^\s*#.*',{'context':0, 'folds':'invisible'})
Nnoremap <silent> <buffer> <leader>et [Edit filename.t in a vertical split] :call EditPerlTestFile()<CR>
Nnoremap <silent> <buffer> <leader>eT [Edit Test::Class filename.pm in a vertical split] :call EditPerlTestClassFile()<CR>

function! PerlModuleFile(module)
	let filepath = system("perldoc -l " . a:module)
	return substitute(filepath, '\n\+$', '', '')
endfunction
function! SetProjectConfig()
	let path = expand('%:p:h')
	if path =~ 'fcs'
		setlocal complete-=w complete-=i
		let b:t_directory = "$HOME/lib/fcs/t/"
		let b:tc_directory = "$HOME/lib/fcs/t/lib/Test/"
	else
		let b:t_directory = "./t/"
		let b:tc_directory = "./t/lib/Test/"
	endif
endfunction

if exists('*EditPerlTestFile')
	finish
endif
function! EditPerlTestFile()
	let filename = expand('%:p:t:r')
	execute ":vsp " . b:t_directory . filename . ".t"
endfunction
function! EditPerlTestClassFile()
	let filename = expand('%:p:s?.*lib/??:r:gs?/?/?')
	execute ":vsp " . b:tc_directory . filename . ".pm"
endfunction
