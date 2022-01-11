let b:digraphs = {
  \ "copyright": "©",
  \ "registered": "®",
  \ "degrees": "°",
  \ "+-": "±",
  \ "1S": "¹",
  \ "2S": "²",
  \ "3S": "³",
  \ "1/4": "¼",
  \ "1/2": "½",
  \ "3/4": "¾",
  \ "multiply": "×",
  \ "divide": "÷",
  \ "alpha": "α",
  \ "beta": "β",
  \ "delta": "δ",
  \ "epsilon": "ε",
  \ "theta": "θ",
  \ "lambda": "λ",
  \ "mu": "μ",
  \ "pi": "π",
  \ "rho": "ρ",
  \ "sigma": "σ",
  \ "tau": "τ",
  \ "phi": "φ",
  \ "omega": "ω",
  \ "<-": "←",
  \ "-^": "↑",
  \ "->": "→",
  \ "-v": "↓",
  \ "<->": "↔",
  \ "^-v": "↕",
  \ "<=": "⇐",
  \ "=>": "⇒",
  \ "<=>": "⇔",
  \ "sqrt": "√",
  \ "inf": "∞",
  \ "!=": "≠",
  \ "=<": "≤",
  \ ">=": "≥",
  \ }

nmap <leader>I :call <SID>ToggleDigraphs()<CR>

fun! s:ToggleDigraphs()
  if exists("g:digraphs_enabled") && g:digraphs_enabled
    for [abbr, symbol] in items(b:digraphs)
      :execute ":iunabbrev " .. abbr
    endfor
    let g:digraphs_enabled = 0
  else
    for [abbr, symbol] in items(b:digraphs)
      :execute ":iabbrev " .. abbr .. " " .. symbol
    endfor
    let g:digraphs_enabled = 1
  endif
endf
