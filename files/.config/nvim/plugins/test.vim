Plug 'vim-test/vim-test'

let test#php#phpunit#executable = 'deliver vendor/bin/phpunit'

nmap <leader>Tn :TestNearest<CR>
nmap <leader>Tf :TestFile<CR>
nmap <leader>Ts :TestSuite<CR>
nmap <leader>Tl :TestLast<CR>
nmap <leader>Tv :TestVisit<CR>
