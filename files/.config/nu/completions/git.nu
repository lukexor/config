export alias ga = git add
export alias gb = git branch -v
export alias gba = git branch -a
export alias gbd = git branch -d
export alias gbm = git branch -v --merged
export alias gbnm = git branch -v --no-merged
export alias gc = git commit
export alias gcam = git commit --amend
export alias gco = git checkout
export alias gcp = git cherry-pick
export alias gd = git diff
export alias gdc = git diff --cached
export alias gdt = git difftool
export alias gf = git fetch origin
export alias glg = git log --graph --pretty=format:'%C(yellow)%h (%p) %ai%Cred%d %Creset%Cblue[%ae]%Creset %s (%ar). %b %N'
export alias gm = git merge
export alias gops = git push origin (git rev-parse --abbrev-ref HEAD | str trim) -u
export alias gopsn = git push origin (git rev-parse --abbrev-ref HEAD | str trim) -u --no-verify
export alias gpl = git pull
export alias gps = git push
export alias gr = git restore
export alias grhh = git reset HEAD --hard
export alias grm = git rm
export alias gs = git switch
export alias gsl = git stash list
export alias gst = git status
export alias gt = git tag
export alias gun = git reset HEAD --

# Git local branches
def git-branches [] {
  ^git branch | lines | each { |line| $line | str replace '\* ' "" | str trim }
}

# Git all branches
def git-all-branches [] {
  ^git branch -a | lines | wrap name | where name !~ HEAD | get name | each { |line| $line | str replace '\* ' "" | | str replace "remotes/origin/" "" | str trim } | uniq
}

# Git remotes
def git-remotes [] {
  ^git remote | lines | each { |line| $line | str trim }
}

# Git logs
def git-log [] {
  ^git log --pretty=%h | lines | each { |line| $line | str trim }
}

# Git files
def git-files [] {
  ^git ls-files | lines
}

# System files
def system-files [] {
  ^ls
}

# Cleanup modes
def cleanup-modes [] {
  [strip whitespace verbatim scissors default]
}

# Merge-strategies
def merge-strategies [] {
  [ort recursive resolve octopus ours subtree]
}

# Merge-strategy options
def merge-strategy-opts [] {
  [ours theirs ignore-space-change ignore-all-space ignore-space-at-eol
  ignore-cr-at-eol renormalize no-renormalize find-renames rename-threshold
  subtree patience diff-algorithm no-renames]
}

# Merge Conflict styles
def conflict-style [] {
  [merge diff3]
}

# Checkout git branch
export def gcb [branch: string@git-branches] {
  git checkout -b $branch
}

# Join two or more development histories together
export extern "git merge" [
  ...commits: string@git-all-branches               # name of the branch to merge
  -n                                                # do not show a diffstat at the end of the merge
  --stat                                            # show a diffstat at the end of the merge
  --summary                                         # (synonym to --stat)
  --log: number                                     # add (at most <n>) entries from shortlog to merge commit message
  --squash                                          # create a single commit instead of doing a merge
  --commit                                          # perform a commit if the merge succeeds (default)
  --no-commit                                       # perform the merge and stop just before creating the merge commit
  --edit(-e)                                        # edit message before committing
  --no-edit                                         # accept the auto-generated message
  --cleanup: string@cleanup-modes                   # how to strip spaces and #comments from message
  --ff                                              # allow fast-forward (default)
  --ff-only                                         # abort if fast-forward is not possible
  --rerere-autoupdate                               # update the index with reused conflict resolution if possible
  --verify-signatures                               # verify that the named commit has a valid GPG signature
  --strategy(-s): string@merge-strategies           # merge strategy to use
  --strategy-option(-X): string@merge-strategy-opts # option for selected merge strategy
  --message(-m): string                             # merge commit message (for a non-fast-forward merge)
  --file(-F): string@system-files                   # read message from file
  --verbose(-v)                                     # be more verbose
  --quiet(-q)                                       # be more quiet
  --abort                                           # abort the current in-progress merge
  --quit                                            # --abort but leave index and working tree alone
  --continue                                        # continue the current in-progress merge
  --allow-unrelated-histories                       # allow merging unrelated histories
  --progress                                        # force progress reporting
  --gpg-sign(-S): string                            # GPG sign commit
  --autostash                                       # automatically stash/stash pop before and after
  --overwrite-ignore                                # update ignored files (default)
  --signoff                                         # add a Signed-off-by trailer
  --no-verify                                       # bypass pre-merge-commit and commit-msg hooks
]

# List, create, or delete branches
export extern "git branch" [
  branch_or_old?: string@git-branches               # name of the branch to target or old branch
  new_branch?: string@git-branches                  # name of the new branch
  --abbrev: number                                  # use <n> digits to display object names
  --all(-a)                                         # list both remote-tracking and local branches
  --color: string                                   # use colored output
  --column: string                                  # list branches in columns
  --contains: string                                # print only branches that contain the commit
  --copy(-c)                                        # copy a branch and its reflog
  --create-reflog                                   # create the branch's reflog
  --delete(-d)                                      # delete fully merged branch
  --edit-description                                # edit the description for the branch
  --force(-f)                                       # force creation, move/rename, deletion
  --format: string                                  # format to use for the output
  --help(-h)                                        # help
  --ignore-case(-i)                                 # sorting and filtering are case insensitive
  --list(-l)                                        # list branch names
  --merged?: string                                 # print only branches that are merged
  --move(-m)                                        # move/rename a branch and its reflog
  --no-contains: string                             # print only branches that don't contain the commit
  --no-emerged?: string                             # print only branches that are not merged
  --points-at: string                               # print only branches of the object
  --quiet(-q)                                       # suppress informational messages
  --remotes(-r)                                     # act on remote-tracking branches
  --set-upstream-to(-u): string                     # change the upstream info
  --show-current                                    # show current branch name
  --sort: string                                    # field name to sort on
  --track(-t)                                       # set up tracking mode (see git-pull(1))
  --unset-upstream                                  # unset the upstream info
  --verbose(-v)                                     # show hash and subject, give twice for upstream branch
  -C                                                # copy a branch, even if target exists
  -D                                                # delete branch (even if not merged)
  -M                                                # move/rename a branch, even if target exists
]

# Switch branches or restore working tree files
export extern "git checkout" [
  ...targets: string@git-all-branches               # name of the branch or files to checkout
  --conflict: string                                # conflict style (merge or diff3)
  --detach(-d)                                      # detach HEAD at named commit
  --force(-f)                                       # force checkout (throw away local modifications)
  --guess                                           # second guess 'git checkout <no-such-branch>' (default)
  --ignore-other-worktrees                          # do not check if another worktree is holding the given ref
  --ignore-skip-worktree-bits                       # do not limit pathspecs to sparse entries only
  --merge(-m)                                       # perform a 3-way merge with the new branch
  --orphan: string                                  # new unparented branch
  --ours(-2)                                        # checkout our version for unmerged files
  --overlay                                         # use overlay mode (default)
  --overwrite-ignore                                # update ignored files (default)
  --patch(-p)                                       # select hunks interactively
  --pathspec-from-file: string                      # read pathspec from file
  --progress                                        # force progress reporting
  --quiet(-q)                                       # suppress progress reporting
  --recurse-submodules: string                      # control recursive updating of submodules
  --theirs(-3)                                      # checkout their version for unmerged files
  --track(-t)                                       # set upstream info for new branch
  -B: string                                        # create/reset and checkout a branch
  -b: string                                        # create and checkout a new branch
  -l                                                # create reflog for new branch
]

# Download objects and refs from another repository
export extern "git fetch" [
  repository?: string@git-remotes                   # name of the branch to fetch
  --all                                             # Fetch all remotes
  --append(-a)                                      # Append ref names and object names to .git/FETCH_HEAD
  --atomic                                          # Use an atomic transaction to update local refs.
  --depth: int                                      # Limit fetching to n commits from the tip
  --deepen: int                                     # Limit fetching to n commits from the current shallow boundary
  --shallow-since: string                           # Deepen or shorten the history by date
  --shallow-exclude: string                         # Deepen or shorten the history by branch/tag
  --unshallow                                       # Fetch all available history
  --update-shallow                                  # Update .git/shallow to accept new refs
  --negotiation-tip: string                         # Specify which commit/glob to report while fetching
  --negotiate-only                                  # Do not fetch, only print common ancestors
  --dry-run                                         # Show what would be done
  --write-fetch-head                                # Write fetched refs in FETCH_HEAD (default)
  --no-write-fetch-head                             # Do not write FETCH_HEAD
  --force(-f)                                       # Always update the local branch
  --keep(-k)                                        # Keep dowloaded pack
  --multiple                                        # Allow several arguments to be specified
  --auto-maintenance                                # Run 'git maintenance run --auto' at the end (default)
  --no-auto-maintenance                             # Don\'t run 'git maintenance' at the end
  --auto-gc                                         # Run 'git maintenance run --auto' at the end (default)
  --no-auto-gc                                      # Don't run 'git maintenance' at the end
  --write-commit-graph                              # Write a commit-graph after fetching
  --no-write-commit-graph                           # Don\'t write a commit-graph after fetching
  --prefetch                                        # Place all refs into the refs/prefetch/ namespace
  --prune(-p)                                       # Remove obsolete remote-tracking references
  --prune-tags(-P)                                  # Remove any local tags that do not exist on the remote
  --no-tags(-n)                                     # Disable automatic tag following
  --refmap: string                                  # Use this refspec to map the refs to remote-tracking branches
  --tags(-t)                                        # Fetch all tags
  --recurse-submodules: string                      # Fetch new commits of populated submodules (yes/on-demand/no)
  --jobs(-j): int                                   # Number of parallel children
  --no-recurse-submodules                           # Disable recursive fetching of submodules
  --set-upstream                                    # Add upstream (tracking) reference
  --submodule-prefix: string                        # Prepend to paths printed in informative messages
  --upload-pack: string                             # Non-default path for remote command
  --quiet(-q)                                       # Silence internally used git commands
  --verbose(-v)                                     # Be verbose
  --progress                                        # Report progress on stderr
  --server-option(-o): string                       # Pass options for the server to handle
  --show-forced-updates                             # Check if a branch is force-updated
  --no-show-forced-updates                          # Don\'t check if a branch is force-updated
  -4                                                # Use IPv4 addresses, ignore IPv6 addresses
  -6                                                # Use IPv6 addresses, ignore IPv4 addresses
]

# Update remote refs along with associated objects
export extern "git push" [
  remote?: string@git-remotes                       # the branch of the remote
  ...refs: string@git-branches                      # the branch / refspec
  --all                                             # push all refs
  --atomic                                          # request atomic transaction on remote side
  --delete(-d)                                      # delete refs
  --dry-run(-n)                                     # dry run
  --exec: string                                    # receive pack program
  --follow-tags                                     # push missing but relevant tags
  --force(-f)                                       # force updates
  --force-with-lease: string                        # require old value of ref to be at this value
  --ipv4(-4)                                        # use IPv4 addresses only
  --ipv6(-6)                                        # use IPv6 addresses only
  --mirror                                          # mirror all refs
  --no-verify                                       # bypass pre-push hook
  --porcelain                                       # machine-readable output
  --progress                                        # force progress reporting
  --prune                                           # prune locally removed refs
  --push-option(-o): string                         # option to transmit
  --quiet(-q)                                       # be more quiet
  --receive-pack: string                            # receive pack program
  --recurse-submodules: string                      # control recursive pushing of submodules
  --repo: string                                    # repository
  --set-upstream(-u)                                # set upstream for git pull/status
  --signed: string                                  # GPG sign the push
  --tags                                            # push tags (can\'t be used with --all or --mirror)
  --thin                                            # use thin pack
  --verbose(-v)                                     # be more verbose
  --help(-h)
]

# Switch branches
export extern "git switch" [
  switch?: string@git-all-branches                  # name of branch to switch to
  --create(-c): string                              # create a new branch
  --detach(-d): string@git-log                      # switch to a commit in a detatched state
  --force-create(-C): string                        # forces creation of new branch, if it exists then the existing branch will be reset to starting point
  --force(-f)                                       # alias for --discard-changes
  --guess                                           # if there is no local branch which matches then name but there is a remote one then this is checked out
  --ignore-other-worktrees                          # switch even if the ref is held by another worktree
  --merge(-m)                                       # attempts to merge changes when switching branches if there are local changes
  --no-guess                                        # do not attempt to match remote branch names
  --no-progress                                     # do not report progress
  --no-recurse-submodules                           # do not update the contents of sub-modules
  --no-track                                        # do not set "upstream" configuration
  --orphan: string                                  # create a new orphaned branch
  --progress                                        # report progress status
  --quiet(-q)                                       # suppress feedback messages
  --recurse-submodules                              # update the contents of sub-modules
  --track(-t)                                       # set "upstream" configuration
  --help(-h)                                        # help
]

# Restore working tree files
export extern "git restore" [
  ...args: any
  --source(-s): string                              # which tree-ish to checkout from
  --staged(-S)                                      # restore the index
  --worktree(-W)                                    # restore the working tree (default)
  --ignore-unmerged                                 # ignore unmerged entries
  --overlay                                         # use overlay mode
  --quiet(-q)                                       # suppress progress reporting
  --recurse-submodules                              # control recursive updating of submodules
  --progress                                        # force progress reporting
  --merge(-m)                                       # perform a 3-way merge with the new branch
  --conflict: string@conflict-style       # conflict style (merge or diff3)
  --ours(-2)                                        # checkout our version for unmerged files
  --theirs(-3)                                      # checkout their version for unmerged files
  --patch(-p)                                       # select hunks interactively
  --ignore-skip-worktree-bits                       # do not limit pathspecs to sparse entries only
  --pathspec-from-file: path                        # read pathspec from file
  --pathspec-file-nul                               # with --pathspec-from-file, pathspec elements are separated with NUL character
]
