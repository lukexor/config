Plug 'tpope/vim-projectionist'

let g:projectionist_heuristics = {
    \ "package.json": {
    \   "*": {
    \     "start": "npm start",
    \     "make": "npm run lint",
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
    \ "Cargo.toml": {
    \   "*": {
    \     "start": "cargo run",
    \     "make": "cargo clippy --all-targets",
    \     "console": "nu -c 'start https://play.rust-lang.org/' > /dev/null 2>&1; exit",
    \   },
    \ },
    \ }
