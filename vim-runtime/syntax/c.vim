" Highlight Class and Function names
syn match    cCustomParen    "?=(" contains=cParen contains=cCppParen
syn match    cCustomFunc     "\w\+\s*(\@=" contains=cCustomParen
syn match    cCustomScope    "::"
syn match    cCustomClass    "\w\+\s*::" contains=cCustomScope
syn match    cCustomEnum     "[A-Z]\{4,\}"

hi def cCustomFunc  cterm=bold ctermfg=032
hi def cCustomEnum  cterm=bold ctermfg=074
hi def link cCustomClass Function
