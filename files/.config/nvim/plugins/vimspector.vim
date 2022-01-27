Plug 'puremourning/vimspector', { 'on': [
  \ '<Plug>VimspectorLaunch',
  \ '<Plug>VimspectorToggleBreakpoint',
  \ '<Plug>VimspectorToggleConditionalBreakpoint' ]
  \ }

let g:vimspector_install_gadgets = [
  \ 'CodeLLDB',
  \ 'debugger-for-chrome',
  \ 'vscode-bash-debug',
  \ ]

" mnemonic 'di' = 'debug inspect'
nmap <localleader>dd <Plug>VimspectorLaunch
nmap <localleader>dc <Plug>VimspectorContinue
nmap <localleader>dp <Plug>VimspectorPause
nmap <localleader>dq <Plug>VimspectorStop
nmap <localleader>db <Plug>VimspectorToggleBreakpoint
nmap <localleader>dB <Plug>VimspectorToggleConditionalBreakpoint
nmap <localleader>do <Plug>VimspectorStepOver
nmap <localleader>di <Plug>VimspectorStepInto
nmap <localleader>dO <Plug>VimspectorStepOut
nmap <localleader>dr <Plug>VimspectorRunToCursor
nmap <localleader>dR <Plug>VimspectorRestart
nmap <localleader>de <Plug>VimspectorBalloonEval
xmap <localleader>de <Plug>VimspectorBalloonEval
