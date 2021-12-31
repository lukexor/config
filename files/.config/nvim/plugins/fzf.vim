Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'stsewd/fzf-checkout.vim'

let g:fzf_layout = { 'up': '~90%', 'window': { 'width': 0.8, 'height': 0.8, 'yoffset': 0.5, 'xoffset': 0.5 } }
let g:fzf_buffers_jump = 1
let g:fzf_commits_log_options = '--graph --pretty=format:"%C(yellow)%h (%p) %ai%Cred%d %Creset%Cblue[%ae]%Creset %s (%ar). %b %N"'

" Use rg
command! -bang -nargs=? -complete=dir Files
  \ call fzf#run(fzf#wrap(
  \   'files',
  \   fzf#vim#with_preview({ 'dir': <q-args>, 'sink': 'e', 'source': 'rg --files --hidden --glob !.git/' }), <bang>0))

" Add AllFiles which ignores .gitignore
command! -bang -nargs=? -complete=dir AllFiles
  \ call fzf#run(fzf#wrap(
  \   'allfiles',
  \   fzf#vim#with_preview({ 'dir': <q-args>, 'sink': 'e', 'source': 'rg --files --hidden --no-ignore --glob !.git/' }), <bang>0))

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg -. --ignore-file .git/ --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

nmap <leader>f :Files<CR>
nmap <leader>F :AllFiles<CR>
nmap <leader>b :Buffers<CR>
nmap <leader>B :BLines<CR>
nmap <leader>C :Commands<CR>
nmap <leader>H :History:<CR>
nmap <leader>S :Snippets<CR>
nmap <leader>M :Marks<CR>
nmap <leader>r :Rg<CR>
nmap <leader>gb :GBranches<CR>
nmap <leader>gc :BCommits<CR>
nmap <leader>gC :Commits<CR>
