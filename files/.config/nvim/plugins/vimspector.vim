Plug 'puremourning/vimspector'

let g:vimspector_install_gadgets = [ 'CodeLLDB', 'debugger-for-chrome', 'vscode-bash-debug' ]

" mnemonic 'di' = 'debug inspect'
nmap <leader>dd <Plug>VimspectorLaunch
nmap <leader>db <Plug>VimspectorToggleBreakpoint
nmap <leader>dc <Plug>VimspectorContinue
nmap <leader>dq <Plug>VimspectorStop
nmap <leader>dO <Plug>VimspectorStepOver
nmap <leader>dI <Plug>VimspectorStepInto
nmap <leader>dE <Plug>VimspectorStepOut
nmap <leader>dr <Plug>VimspectorRunToCursor
nmap <leader>dx :VimspectorReset<CR>
nmap <leader>de :VimspectorEval
nmap <leader>dw :VimspectorWatch
nmap <leader>do :VimspectorShowOutput
nmap <leader>di <Plug>VimspectorBalloonEval
xmap <leader>di <Plug>VimspectorBalloonEval
