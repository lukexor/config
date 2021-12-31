Plug 'romainl/vim-qf'

nmap [q <Plug>(qf_qf_previous)
nmap ]q <Plug>(qf_qf_next)
nmap <leader>ct <Plug>(qf_qf_toggle)
" Clear quickfix
nnoremap <leader>cc :cexpr []
