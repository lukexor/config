" Zhayedan vim color file
" Maintainer: Lucas Petherbridge <lukexor@gmail.com>
" Version: 6.1.0

hi clear
if exists("syntax_on")
    syntax reset
endif
let colors_name="zhayedan"

" Summary:
" Blue flavored colorscheme for dark backgrounds. Very minimal.

" Description:
" This was adapted from the lucius colorscheme: http://www.vim.org/scripts/script.php?script_id=2536
"
" Installation:
" Copy the file to your vim colors directory and then do :colorscheme zhayedan.

set background=dark

hi Normal       ctermfg=230   ctermbg=NONE      cterm=none

hi Comment      ctermfg=215     ctermbg=NONE      cterm=none

hi Constant     ctermfg=035    ctermbg=NONE      cterm=none
hi BConstant    ctermfg=035    ctermbg=NONE      cterm=bold

hi Function     ctermfg=178    ctermbg=NONE      cterm=NONE
hi Class        ctermfg=178    ctermbg=NONE      cterm=none
hi Structure    ctermfg=178    ctermbg=NONE      cterm=none

hi Identifier           ctermfg=230    ctermbg=NONE      cterm=none
hi BIdentifier          ctermfg=230    ctermbg=NONE      cterm=bold
hi DefinedName          ctermfg=230    ctermbg=NONE      cterm=none
hi Enumerator           ctermfg=230    ctermbg=NONE      cterm=none
hi EnumerationName      ctermfg=230    ctermbg=NONE      cterm=none
hi Member               ctermfg=220    ctermbg=NONE      cterm=none
hi Type                 ctermfg=230    ctermbg=NONE      cterm=none
hi Union                ctermfg=230    ctermbg=NONE      cterm=none
hi GlobalConstant       ctermfg=230    ctermbg=NONE      cterm=none
hi GlobalVariable       ctermfg=230    ctermbg=NONE      cterm=none
hi LocalVariable        ctermfg=230    ctermbg=NONE      cterm=none
hi perlVarPlain         ctermfg=80    ctermbg=NONE      cterm=none
hi jsVariableDef        ctermfg=80    ctermbg=NONE      cterm=none

hi Statement    ctermfg=230    ctermbg=NONE      cterm=none
hi BStatement   ctermfg=230    ctermbg=NONE      cterm=bold

hi PreProc      ctermfg=230    ctermbg=NONE      cterm=none
hi BPreProc     ctermfg=230    ctermbg=NONE      cterm=bold

hi Type         ctermfg=230    ctermbg=NONE      cterm=none
hi BType        ctermfg=230    ctermbg=NONE      cterm=bold

hi Special      ctermfg=230    ctermbg=NONE      cterm=none
hi Delimiter    ctermfg=230    ctermbg=NONE      cterm=none
hi BSpecial     ctermfg=230    ctermbg=NONE      cterm=bold

" == Text Markup ==
hi Underlined   ctermfg=fg     ctermbg=NONE      cterm=underline
hi Error        ctermfg=167    ctermbg=236       cterm=none
hi Todo         ctermfg=186    ctermbg=NONE      cterm=none
hi MatchParen   cterm=bold
hi NonText      ctermfg=245    ctermbg=NONE      cterm=none
hi SpecialKey   ctermfg=grey    ctermbg=NONE     cterm=none
hi Title        ctermfg=074    ctermbg=NONE      cterm=bold

" == Text Selection ==
hi Cursor       cterm=none
hi CursorIM     cterm=none
hi CursorColumn ctermfg=NONE   ctermbg=234       cterm=none
hi CursorLine   ctermfg=NONE    ctermbg=234     cterm=none
hi Visual       ctermfg=NONE   ctermbg=024       cterm=none
hi VisualNOS    ctermfg=fg     ctermbg=NONE      cterm=underline
hi IncSearch    cterm=none
hi Search       cterm=none

" == UI ==
hi Pmenu        ctermfg=000     ctermbg=252       cterm=none
hi PmenuSel     ctermfg=000     ctermbg=024       cterm=none
hi PMenuSbar    cterm=none
hi PMenuThumb   ctermfg=000 ctermbg=244       cterm=none
hi StatusLine   ctermfg=036    ctermbg=black      cterm=bold
hi StatusLineNC ctermfg=240    ctermbg=252       cterm=none
hi TabLine      cterm=none
hi TabLineFill  ctermfg=240    ctermbg=252       cterm=none
hi TabLineSel   ctermfg=fg     ctermbg=024       cterm=bold
hi VertSplit    ctermfg=245    ctermbg=252       cterm=none
hi Folded       cterm=none
hi FoldColumn   cterm=none

" == Spelling =="{{{
hi SpellBad     cterm=undercurl
hi SpellCap     cterm=undercurl
hi SpellRare    cterm=undercurl
hi SpellLocal   cterm=undercurl"}}}

" == Diff ==
hi DiffAdd      ctermfg=fg     ctermbg=022       cterm=none
hi DiffChange   ctermfg=fg     ctermbg=058       cterm=none
hi DiffDelete   ctermfg=fg     ctermbg=052       cterm=none
hi DiffText     ctermfg=220    ctermbg=058       cterm=bold

" == Misc ==
hi Directory    ctermfg=151    ctermbg=NONE      cterm=none
hi ErrorMsg     ctermfg=196    ctermbg=NONE      cterm=none
hi SignColumn   ctermfg=145    ctermbg=black         cterm=none
hi ShowMarksHLl cterm=none
hi ShowMarksHLu cterm=none
hi ShowMarksHLo cterm=none
hi ShowMarksHLm cterm=none
hi LineNr       ctermfg=grey     cterm=none
hi CursorLineNr         ctermfg=036     cterm=none
hi MoreMsg      ctermfg=117    ctermbg=NONE      cterm=none
hi ModeMsg      ctermfg=fg     ctermbg=NONE      cterm=none
hi Question     ctermfg=fg     ctermbg=NONE      cterm=none
hi WarningMsg   ctermfg=173    ctermbg=NONE      cterm=none
hi WildMenu     ctermfg=NONE   ctermbg=024       cterm=none
hi ColorColumn  ctermfg=NONE   ctermbg=red       cterm=none
hi Ignore       ctermbg=000
