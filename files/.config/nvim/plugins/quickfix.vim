Plug 'romainl/vim-qf'

nmap gn <Plug>(qf_qf_next)
nmap gp <Plug>(qf_qf_previous)
nmap <leader>ct <Plug>(qf_qf_toggle)
" Clear quickfix
nnoremap <leader>cc :cexpr []
