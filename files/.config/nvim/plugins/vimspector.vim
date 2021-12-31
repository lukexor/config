Plug 'puremourning/vimspector', { 'on': ['VimspectorLaunch', 'VimspectorToggleBreakpoint'] }

let g:vimspector_install_gadgets = [ 'CodeLLDB', 'debugger-for-chrome', 'vscode-bash-debug' ]

" mnemonic 'di' = 'debug inspect'
nmap <localleader>dd <Plug>VimspectorLaunch
nmap <localleader>db <Plug>VimspectorToggleBreakpoint
nmap <localleader>dc <Plug>VimspectorContinue
nmap <localleader>dq <Plug>VimspectorStop
nmap <localleader>dO <Plug>VimspectorStepOver
nmap <localleader>dI <Plug>VimspectorStepInto
nmap <localleader>dE <Plug>VimspectorStepOut
nmap <localleader>dr <Plug>VimspectorRunToCursor
nmap <localleader>dx :VimspectorReset<CR>
nmap <localleader>de :VimspectorEval
nmap <localleader>dw :VimspectorWatch
nmap <localleader>do :VimspectorShowOutput
nmap <localleader>di <Plug>VimspectorBalloonEval
xmap <localleader>di <Plug>VimspectorBalloonEval
