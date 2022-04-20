def "nu-complete git branches" [] {
  ^git branch | lines | each { |line| $line | str replace '\* ' "" | str trim }
}

def "nu-complete git all branches" [] {
  ^git branch -a | lines | wrap name | where name !~ HEAD | get name | each { |line| $line | str replace '\* ' "" | | str replace "remotes/origin/" "" | str trim }
}

def "nu-complete git remotes" [] {
  ^git remote | lines | each { |line| $line | str trim }
}

def "nu-complete git files" [] {
  ^git ls-files | lines
}

export extern "git merge" [
  branch?: string@"nu-complete git all branches" # name of the branch to merge
  --abort                                        # abort the current in-progress merge
  --allow-unrelated-histories                    # allow merging unrelated histories
  --autostash                                    # automatically stash/stash pop before and after
  --cleanup: string                              # how to strip spaces and #comments from message
  --commit                                       # perform a commit if the merge succeeds (default)
  --continue                                     # continue the current in-progress merge
  --edit(-e)                                     # edit message before committing
  --ff                                           # allow fast-forward (default)
  --ff-only                                      # abort if fast-forward is not possible
  --file(-F): string                             # read message from file
  --gpg-sign(-S): string                         # GPG sign commit
  --log: number                                  # add (at most <n>) entries from shortlog to merge commit message
  --message(-m): string                          # merge commit message (for a non-fast-forward merge)
  --no-verify                                    # bypass pre-merge-commit and commit-msg hooks
  --overwrite-ignore                             # update ignored files (default)
  --progress                                     # force progress reporting
  --quiet(-q)                                    # be more quiet
  --quit                                         # --abort but leave index and working tree alone
  --rerere-autoupdate                            # update the index with reused conflict resolution if possible
  --signoff                                      # add a Signed-off-by trailer
  --squash                                       # create a single commit instead of doing a merge
  --stat                                         # show a diffstat at the end of the merge
  --strategy(-s): string                         # merge strategy to use
  --strategy-option(-X): string                  # string option for selected merge strategy
  --summary                                      # (synonym to --stat)
  --verbose(-v)                                  # be more verbose
  --verify-signatures                            # verify that the named commit has a valid GPG signature
  -n                                             # do not show a diffstat at the end of the merge
]

export extern "git branch" [
  ...targets?: string@"nu-complete git branches" # name of the branch to target
  --abbrev: number                               # use <n> digits to display object names
  --all(-a)                                      # list both remote-tracking and local branches
  --color: string                                # use colored output
  --column: string                               # list branches in columns
  --contains: string                             # print only branches that contain the commit
  --copy(-c)                                     # copy a branch and its reflog
  --create-reflog                                # create the branch's reflog
  --delete(-d)                                   # delete fully merged branch
  --edit-description                             # edit the description for the branch
  --force(-f)                                    # force creation, move/rename, deletion
  --format: string                               # format to use for the output
  --ignore-case(-i)                              # sorting and filtering are case insensitive
  --list(-l)                                     # list branch names
  --merged: string                               # print only branches that are merged
  --move(-m)                                     # move/rename a branch and its reflog
  --no-contains: string                          # print only branches that don't contain the commit
  --no-merged: string                            # print only branches that are not merged
  --points-at: string                            # print only branches of the object
  --quiet(-q)                                    # suppress informational messages
  --remotes(-r)                                  # act on remote-tracking branches
  --set-upstream-to(-u): string                  # change the upstream info
  --show-current                                 # show current branch name
  --sort: string                                 # field name to sort on
  --track(-t)                                    # set up tracking mode (see git-pull(1))
  --unset-upstream                               # unset the upstream info
  --verbose(-v)                                  # show hash and subject, give twice for upstream branch
  -C                                             # copy a branch, even if target exists
  -D                                             # delete branch (even if not merged)
  -M                                             # move/rename a branch, even if target exists
]

export extern "git checkout" [
  ...targets?: string@"nu-complete git all branches" # name of the branch to checkout
  --conflict: string                                 # conflict style (merge or diff3)
  --detach(-d)                                       # detach HEAD at named commit
  --force(-f)                                        # force checkout (throw away local modifications)
  --guess                                            # second guess 'git checkout <no-such-branch>' (default)
  --ignore-other-worktrees                           # do not check if another worktree is holding the given ref
  --ignore-skip-worktree-bits                        # do not limit pathspecs to sparse entries only
  --merge(-m)                                        # perform a 3-way merge with the new branch
  --orphan: string                                   # new unparented branch
  --ours(-2)                                         # checkout our version for unmerged files
  --overlay                                          # use overlay mode (default)
  --overwrite-ignore                                 # update ignored files (default)
  --patch(-p)                                        # select hunks interactively
  --pathspec-from-file: string                       # read pathspec from file
  --progress                                         # force progress reporting
  --quiet(-q)                                        # suppress progress reporting
  --recurse-submodules: string                       # control recursive updating of submodules
  --theirs(-3)                                       # checkout their version for unmerged files
  --track(-t)                                        # set upstream info for new branch
  -B: string                                         # create/reset and checkout a branch
  -b: string                                         # create and checkout a new branch
  -l                                                 # create reflog for new branch
]

export extern "git push" [
  remote?: string@"nu-complete git remotes"   # the name of the remote
  ...refs?: string@"nu-complete git branches" # the branch / refspec
  --all                                       # push all refs
  --atomic                                    # request atomic transaction on remote side
  --delete(-d)                                # delete refs
  --dry-run(-n)                               # dry run
  --exec: string                              # receive pack program
  --follow-tags                               # push missing but relevant tags
  --force(-f)                                 # force updates
  --force-with-lease: string                  # require old value of ref to be at this value
  --ipv4(-4)                                  # use IPv4 addresses only
  --ipv6(-6)                                  # use IPv6 addresses only
  --mirror                                    # mirror all refs
  --no-verify                                 # bypass pre-push hook
  --porcelain                                 # machine-readable output
  --progress                                  # force progress reporting
  --prune                                     # prune locally removed refs
  --push-option(-o): string                   # option to transmit
  --quiet(-q)                                 # be more quiet
  --receive-pack: string                      # receive pack program
  --recurse-submodules: string                # control recursive pushing of submodules
  --repo: string                              # repository
  --set-upstream(-u)                          # set upstream for git pull/status
  --signed: string                            # GPG sign the push
  --tags                                      # push tags (can't be used with --all or --mirror)
  --thin                                      # use thin pack
  --verbose(-v)                               # be more verbose
]
