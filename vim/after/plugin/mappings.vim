"== Mapping Overrides

" Alternate a.vim
if maparg("<leader>ih") != ""
  iunmap <leader>ih
endif
if maparg("<leader>is") != ""
  iunmap <leader>is
endif
if maparg("<leader>ihn") != ""
  iunmap <leader>ihn
endif
" Unimpaired
if maparg("=p") != ""
  nunmap =p
endif
if maparg("=P") != ""
  nunmap =P
endif
