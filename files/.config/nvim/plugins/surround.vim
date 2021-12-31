Plug 'tpope/vim-surround'

" ==================================================================================================
" Key Maps   {{{1
" ==================================================================================================

" Surround text with punctuation easier 'you surround' + motion
nmap <leader>" ysiw"
nmap <leader>' ysiw'
nmap <leader>( ysiw(
nmap <leader>) ysiw)
nmap <leader>> ysiw>
nmap <leader>[ ysiw[
nmap <leader>] ysiw]
nmap <leader>` ysiw`
nmap <leader>{ ysiw{
nmap <leader>} ysiw}
nmap <leader><Bar> ysiw|

" Same mappers for visual mode
vmap <leader>" gS"
vmap <leader>' gS'
vmap <leader>( gS(
vmap <leader>) gS)
vmap <leader>< gS<
vmap <leader>> gS>
vmap <leader>[ gS[
vmap <leader>] gS]
vmap <leader>` gS`
vmap <leader>{ gS{
vmap <leader>} gS}
vmap <leader><Bar> gS|

nmap <localleader>[ ysip[
nmap <localleader>] ysip]
nmap <localleader>rh ds'ds}
nmap <localleader>sh ysiw}lysiw'
nmap <localleader>{ ysip{
nmap <localleader>} ysip{

