" Zhayedan vim color file
" Maintainer: Lucas Petherbridge <LukeXOR@gmail.com>
" Version: 6.1.0

hi clear
if exists("syntax_on")
    syntax reset
endif
let colors_name="zhayedan"

" Summary:
" Blue flavored colorscheme for dark backgrounds.

" Description:
" This was adapted from the lucius colorscheme: http://www.vim.org/scripts/script.php?script_id=2536
"
" Installation:
" Copy the file to your vim colors directory and then do :colorscheme zhayedan.

set background=dark

hi Normal       guifg=#607371   guibg=#071f29   ctermfg=007    ctermbg=NONE      gui=none      cterm=none

hi Comment      guifg=#707070   guibg=NONE      ctermfg=245    ctermbg=NONE      gui=none      cterm=none

hi Constant     guifg=#2d8078   guibg=NONE      ctermfg=030    ctermbg=NONE      gui=none      cterm=none
hi BConstant    guifg=#2d8078   guibg=NONE      ctermfg=030    ctermbg=NONE      gui=bold      cterm=bold

hi Identifier   guifg=#2974b7   guibg=NONE      ctermfg=025    ctermbg=NONE      gui=none      cterm=none
hi BIdentifier  guifg=#2974b7   guibg=NONE      ctermfg=025    ctermbg=NONE      gui=bold      cterm=bold

hi Statement    guifg=#598629   guibg=NONE      ctermfg=070    ctermbg=NONE      gui=none      cterm=none
hi BStatement   guifg=#598629   guibg=NONE      ctermfg=070    ctermbg=NONE      gui=bold      cterm=bold

hi PreProc      guifg=#a0e0d0   guibg=NONE      ctermfg=115    ctermbg=NONE      gui=none      cterm=none
hi BPreProc     guifg=#a0e0d0   guibg=NONE      ctermfg=115    ctermbg=NONE      gui=bold      cterm=bold

hi Type         guifg=#a0d0e0   guibg=NONE      ctermfg=116    ctermbg=NONE      gui=none      cterm=none
hi BType        guifg=#a0d0e0   guibg=NONE      ctermfg=116    ctermbg=NONE      gui=bold      cterm=bold

hi Special      guifg=#c0a0d0   guibg=NONE      ctermfg=182    ctermbg=NONE      gui=none      cterm=none
hi Delimiter    guifg=#c0a0d0   guibg=NONE      ctermfg=039    ctermbg=NONE      gui=none      cterm=none
hi BSpecial     guifg=#c0a0d0   guibg=NONE      ctermfg=182    ctermbg=NONE      gui=bold      cterm=bold

if version >= 700
  hi Pmenu			ctermfg=Black	ctermbg=Cyan				guifg=Black	guibg=Cyan
  hi PmenuSel			ctermfg=Black	ctermbg=Grey				guifg=Black	guibg=Grey
  hi PmenuSbar			ctermfg=Black	ctermbg=Grey				guifg=Black	guibg=Grey
  hi PmenuThumb	cterm=reverse						gui=reverse
endif

" == Text Markup ==
hi Underlined   guifg=fg        guibg=NONE      ctermfg=fg     ctermbg=NONE      gui=underline cterm=underline
hi Error        guifg=#e07070   guibg=#503030   ctermfg=167    ctermbg=236       gui=none      cterm=none
hi Todo         guifg=#e0e090   guibg=#505000   ctermfg=186    ctermbg=NONE      gui=none      cterm=none
hi MatchParen   guibg=#000000        guibg=#c0e070   ctermbg=000     ctermbg=192       gui=none      cterm=bold
hi NonText      guifg=#405060   guibg=NONE      ctermfg=024    ctermbg=NONE      gui=none      cterm=none
hi SpecialKey   guifg=#406050   guibg=NONE      ctermfg=023    ctermbg=NONE      gui=none      cterm=none
hi Title        guifg=#50b0d0   guibg=NONE      ctermfg=074    ctermbg=NONE      gui=bold      cterm=bold

" == Text Selection ==
hi Cursor       guibg=#000000        guibg=fg        ctermbg=000     ctermbg=fg        gui=none      cterm=none
hi CursorIM     guibg=#000000        guibg=fg        ctermbg=000     ctermbg=fg        gui=none      cterm=none
hi CursorColumn guifg=NONE      guibg=#484848   ctermfg=NONE   ctermbg=237       gui=none      cterm=none
hi CursorLine   guifg=NONE      guibg=#484848   ctermfg=NONE   ctermbg=237       gui=none      cterm=none
hi Visual       guifg=NONE      guibg=#205070   ctermfg=NONE   ctermbg=024       gui=none      cterm=none
hi VisualNOS    guifg=fg        guibg=NONE      ctermfg=fg     ctermbg=NONE      gui=underline cterm=underline
hi IncSearch    guibg=#000000        guibg=#50d0d0   ctermbg=000     ctermbg=029       gui=none      cterm=none
hi Search       guibg=#000000        guibg=#e0a020   ctermbg=000     ctermbg=025       gui=none      cterm=none

" == UI ==
hi Pmenu        guifg=#000000   guibg=#b0b0b0   ctermbg=000     ctermbg=252       gui=none      cterm=none
hi PmenuSel     guifg=#e0e0e0   guibg=#205070   ctermfg=fg     ctermbg=024       gui=none      cterm=none
hi PMenuSbar    guibg=#000000        guibg=#b0b0b0   ctermbg=000     ctermbg=254       gui=none      cterm=none
hi PMenuThumb   guifg=NONE      guibg=#808080   ctermfg=fg     ctermbg=244       gui=none      cterm=none
hi StatusLine   guibg=#000000        guibg=#b0b0b0   ctermfg=253    ctermbg=238       gui=bold      cterm=bold
hi StatusLineNC guifg=#404040   guibg=#b0b0b0   ctermfg=240    ctermbg=252       gui=none      cterm=none
hi TabLine      guibg=#000000        guibg=#b0b0b0   ctermbg=000     ctermbg=252       gui=none      cterm=none
hi TabLineFill  guifg=#404040   guibg=#b0b0b0   ctermfg=240    ctermbg=252       gui=none      cterm=none
hi TabLineSel   guifg=#e0e0e0   guibg=#205070   ctermfg=fg     ctermbg=024       gui=bold      cterm=bold
hi VertSplit    guifg=#606060   guibg=#b0b0b0   ctermfg=245    ctermbg=252       gui=none      cterm=none
hi Folded       guibg=#000000        guibg=#808080   ctermbg=000     ctermbg=246       gui=none      cterm=none
hi FoldColumn   guibg=#000000        guibg=#808080   ctermbg=000     ctermbg=246       gui=none      cterm=none

" == Spelling =="{{{
"hi SpellBad     guisp=#ee0000                   ctermfg=fg     ctermbg=160       gui=undercurl cterm=undercurl
"hi SpellCap     guisp=#eeee00                   ctermbg=NONE   ctermbg=226       gui=undercurl cterm=undercurl
"hi SpellRare    guisp=#ffa500                   ctermbg=NONE   ctermbg=214       gui=undercurl cterm=undercurl
"hi SpellLocal   guisp=#ffa500                   ctermbg=NONE   ctermbg=214       gui=undercurl cterm=undercurl"}}}

" == Diff ==
hi DiffAdd      guifg=fg        guibg=#405040   ctermfg=fg     ctermbg=022       gui=none      cterm=none
hi DiffChange   guifg=fg        guibg=#605040   ctermfg=fg     ctermbg=058       gui=none      cterm=none
hi DiffDelete   guifg=fg        guibg=#504040   ctermfg=fg     ctermbg=052       gui=none      cterm=none
hi DiffText     guifg=#e0b050   guibg=#605040   ctermfg=220    ctermbg=058       gui=bold      cterm=bold

" == Misc ==
hi Directory    guifg=#b0d0a0   guibg=NONE      ctermfg=151    ctermbg=NONE      gui=none      cterm=none
hi ErrorMsg     guifg=#ee0000   guibg=NONE      ctermfg=196    ctermbg=NONE      gui=none      cterm=none
hi SignColumn   guifg=#a0b0b0   guibg=#282828   ctermfg=145    ctermbg=233       gui=none      cterm=none
hi LineNr       guibg=#000000        guibg=#808080   ctermfg=246    ctermbg=0         gui=none      cterm=none
hi MoreMsg      guifg=#60c0d0   guibg=NONE      ctermfg=117    ctermbg=NONE      gui=none      cterm=none
hi ModeMsg      guifg=fg        guibg=NONE      ctermfg=fg     ctermbg=NONE      gui=none      cterm=none
hi Question     guifg=fg        guibg=NONE      ctermfg=fg     ctermbg=NONE      gui=none      cterm=none
hi WarningMsg   guifg=#e07060   guibg=NONE      ctermfg=173    ctermbg=NONE      gui=none      cterm=none
hi WildMenu     guifg=NONE      guibg=#205070   ctermfg=NONE   ctermbg=024       gui=none      cterm=none
hi ColorColumn  guifg=NONE      guibg=#484038   ctermfg=NONE   ctermbg=101       gui=none      cterm=none
hi Ignore       guibg=#000000                        ctermbg=000
