" Vim filetype plugin file
" Language:	nushell (nu)
" Maintainer: Lucas Petherbridge <me@lukeworks.tech>
" Last Change: Dec 30, 2021

if exists("b:did_ftplugin")
  finish
endif

runtime! ftplugin/sh.vim ftplugin/sh_*.vim ftplugin/sh/*.vim
