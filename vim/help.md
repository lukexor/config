# Functions
<F1>          Help
<F2>          File Tree
<F3>          Tagbar

# Tabs
<C-n>         New Buffer
<C-a>         Previous Buffer
<C-d>         Next Buffer

# Code
<l>m          Make

# Formatting
<l>rs         Strip trailing space
<l>rt         Retab spaces w/ tabs
<l>mt         Toggle ShowMarks
<l>ma         Clear all marks

# Folds
zo            Open one fold
zO            Open fold recursive
zR            Open all folds
zc            Close one fold
zC            Close fold recursive
zM            Close all folds
zi            Enable/Disable folds

# Quick Edits
<l>ev         Edit vimrc
<l>ep         Edit snippets
<l>sv         Source vimrc

# Spelling
<l>ss         Toggle Spellcheck
<l>sn         Next misspelled word
<l>sp         Previous misspelled
<l>sa         Add Word
<l>s?         Spelling Suggestions

cs"'          Replace " with '
ysiw]         Surround with ]
ds]           Delete surounding ]

# Git Commands
:Git          [args]    Execute any git command
:GBrowse      Open current file in GitHub
:Gmove        Git moves and renames buffer
:Gremove      Git removes and deletes buffer

<l>gm         [args]    Merge a branch or tag
<l>gst        [args]    Opens Git status in a buffer window
  -           Add/Reset file
  p           Add/Reset Patch file
<l>gc         Commits currently staged changes, prompts for commit message
<l>gpl        Update the current branch
<l>gps        Push the current branch
<l>glg        Open the git log in a split window
<l>gd         Compared staged version of file with working
<l>gb         Bring up a git blame panel
  <ENTER>     Edit commit
  o           Edit commit with split window

[c            Next git Hunk
]c            Next git Hunk
<l>hp         Preview git hunk
<l>hs         Stage git hunk
<l>hu         Undo git hunk

# FZF Commands
<C-b>         Open buffer
<C-o>         Fuzzy open file
<C-p>         Search Snippets
<C-m>         Search File History
<C-t>         Search All Tags
:BCommits     Search Commits for current buffer
:BTags        Search Tags for current buffer
:Commits      Search All Commits
:GFiles       Open Git file
:Maps         Search Mappings
:Marks        Search Marks

# TComment
gc{motion}
gc<Count>c{motion}
gcc
gc            (Visual Mode)

# Sessions
SaveSession   [name]
OpenSession   [name]
RestartVim
DeleteSession [name]

# Alternate Files
:A            switches to the header file corresponding to the current file being edited (or vise versa)
:AS           splits and switches
:AV           vertical splits and switches
:AN           cycles through matches
:IH           switches to file under cursor
:IHS          splits and switches
:IHV          vertical splits and switches
:IHN          cycles through matches
<l>ih         switches to file under cursor
<l>is         switches to the alternate file of file under cursor (e.g. on  <foo.h> switches to foo.cpp)
<l>ihn        cycles through matches

# EasyAlign
ga=
