" Vim color scheme
"
" Name:        xcode-midnight.vim
" Maintainer:  Alex Brausewetter - http://github.com/xoob
" License:     public domain
"
" A GUI only port of the 'Midnight' theme from Xcode 4 to Vim.
"
" Color Scheme Overview:
"   :ru syntax/hitest.vim
"

set background=dark

hi clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "xcode-midnight"

"
" Text
"

hi Normal                    guifg=#dadbdf guibg=#000000
hi CursorLine                              guibg=#181818
hi CursorColumn                            guibg=#181818
hi Visual                                  guibg=#837c60

hi LineNr                    guifg=#333333
hi NonText                   guifg=#333333
hi SpecialKey                guifg=#333333

hi Search                    guifg=#000000 guibg=#f0c674

hi Error                     guifg=#ffffff guibg=#db2c38
hi ErrorMsg                  guifg=#ffffff guibg=#db2c38

hi Underlined                guifg=#1919ff

hi Title            gui=bold guifg=#dadbdf
hi Directory                 guifg=#00a0ff

hi StatusLine       gui=bold guifg=#1e2028 guibg=#666666
hi StatusLineNC     gui=NONE guifg=#1e2028 guibg=#666666
hi VertSplit        gui=NONE guifg=#666666 guibg=#666666

hi Pmenu                     guifg=#aaaaaa guibg=#333333
hi PmenuSel                  guifg=#333333 guibg=#00a0ff

hi DiffDelete       gui=NONE guifg=#161616 guibg=#161616
hi DiffAdd          gui=NONE guifg=#dadbdf guibg=#045349
hi DiffChange                              guibg=#161616
hi DiffText         gui=NONE guifg=#dadbdf guibg=#063f7a

"
" Common Syntax
"

hi Comment                   guifg=#41cd45
hi SpecialComment            guifg=#41cd45
hi Todo                      guifg=#000000 guibg=#41cd45

hi String                    guifg=#ff2b38
hi Character                 guifg=#ff2b38
hi Number                    guifg=#786dff
hi Float                     guifg=#786dff

hi Statement        gui=NONE guifg=#d31895
hi Type             gui=NONE guifg=#d31895
hi Boolean                   guifg=#d31895

hi Identifier                guifg=#eeeeee
hi Function                  guifg=#eeeeee

hi Special                   guifg=#acadb1
hi Operator                  guifg=#acadb1

hi PreProc                   guifg=#e57c48
hi Constant                  guifg=#e57c48

hi StdLibIdentifier          guifg=#00a0ff
hi Attribute                 guifg=#3f5874

"
" PHP
"

hi link Delimiter                       Statement
hi link phpDefine                       Statement
hi link phpConditional                  Statement
hi link phpComparison                   Statement

hi link phpMemberSelector               Normal
hi link phpMagicMethods                 Normal

hi link phpFunctions                    Constant
hi link phpClasses                      Constant
hi link phpSpecial                      Constant
hi link phpSpecialFunction              Constant

hi link phpVarSelector                  Identifier
hi link phpMethodsVar                   Identifier

hi link phpParent                       Special
hi link phpMemberSelector               Operator

" 'None' is defined in syn/php.vim. Should be 'phpQuote'
hi link None                            String

"
" NERDTree
"

hi link NERDTreeCWD                     Directory
hi link NERDTreeDirSlash                Directory

hi NERDTreeExecFile gui=italic guifg=#dadbdf
hi NERDTreeRO       gui=italic guifg=#aaaaaa
hi NERDTreeLink     gui=italic guifg=#dadbdf

hi NERDTreeCWD                 guifg=#eeeeee

"
" XML + HTML
"

hi link xmlTag                          Statement
hi link xmlTagName                      Statement
hi link xmlEndTag                       Statement
hi link xmlDocTypeDecl                  Statement

hi link xmlProcessingDelim              Attribute
hi link xmlAttrib                       Attribute
hi link xmlNamespace                    Attribute

hi link htmlTag                         xmlTag
hi link htmlTagName                     xmlTagName
hi link htmlEndTag                      xmlEndTag
hi link htmlArg                         xmlAttrib

"
" Doxygen
"

hi link doxygenBrief                    SpecialComment
hi link doxygenSpecial                  SpecialComment
hi link doxygenHtmlSpecial              SpecialComment
hi link doxygenFormula                  SpecialComment
hi link doxygenSymbol                   SpecialComment
hi link doxygenBOther                   SpecialComment
hi link doxygenParamName                SpecialComment
hi link doxygenParamDirection           SpecialComment
hi link doxygenSpecialMultilineDesc     SpecialComment
hi link doxygenSpecialOnelineDesc       SpecialComment
hi link doxygenSpecialTypeOnelineDesc   SpecialComment
hi link doxygenHtmlCh                   SpecialComment
hi link doxygenHtmlCmd                  SpecialComment

"
" Shell
"

hi link shQuote                         String

"
" Ini
"

hi link dosiniNumber                    Normal

"
" Diff
"

hi link diffLine                        NonText
hi link diffFile                        NonText
hi link diffAdded                       DiffAdd

hi diffRemoved gui=NONE guifg=#dadbdf guibg=#790606
