Plug 'tpope/vim-projectionist'

let g:projectionist_heuristics = {
    \ "package.json": {
    \   "*": {
    \     "start": "npm start",
    \   },
    \   "*.ts": {
    \     "type": "source",
    \     "alternate": "{}.test.ts",
    \   },
    \   "*.tsx": {
    \     "type": "source",
    \     "alternate": "{}.test.tsx",
    \   }
    \ },
    \ }
