def "nu-complete git branches" [] {
  ^git branch | lines | each { |line| $line | str find-replace '\* ' "" | str trim }
}

def "nu-complete git all branches" [] {
  ^git branch -a | lines | each { |line| $line | str find-replace '\* ' "" | str trim }
}

def "nu-complete git remotes" [] {
  ^git remote | lines | each { |line| $line | str trim }
}

def "nu-complete git files" [] {
  ^git ls-files | lines
}

export extern "git merge" [
  branch?: string@"nu-complete git all branches"# name of the branch to merge
  -n                                            # do not show a diffstat at the end of the merge
  --stat                                        # show a diffstat at the end of the merge
  --summary                                     # (synonym to --stat)
  --log: number                                 # add (at most <n>) entries from shortlog to merge commit message
  --squash                                      # create a single commit instead of doing a merge
  --commit                                      # perform a commit if the merge succeeds (default)
  --edit(-e)                                    # edit message before committing
  --cleanup: string                             # how to strip spaces and #comments from message
  --ff                                          # allow fast-forward (default)
  --ff-only                                     # abort if fast-forward is not possible
  --rerere-autoupdate                           # update the index with reused conflict resolution if possible
  --verify-signatures                           # verify that the named commit has a valid GPG signature
  --strategy(-s): string                        # merge strategy to use
  --strategy-option(-X): string                 # string option for selected merge strategy
  --message(-m): string                         # merge commit message (for a non-fast-forward merge)
  --file(-F): string                            # read message from file
  --verbose(-v)                                 # be more verbose
  --quiet(-q)                                   # be more quiet
  --abort                                       # abort the current in-progress merge
  --quit                                        # --abort but leave index and working tree alone
  --continue                                    # continue the current in-progress merge
  --allow-unrelated-histories                   # allow merging unrelated histories
  --progress                                    # force progress reporting
  --gpg-sign(-S): string                        # GPG sign commit
  --autostash                                   # automatically stash/stash pop before and after
  --overwrite-ignore                            # update ignored files (default)
  --signoff                                     # add a Signed-off-by trailer
  --no-verify                                   # bypass pre-merge-commit and commit-msg hooks
]

export extern "git branch" [
  branch?: string@"nu-complete git branches"  # name of the branch to target
  new-branch?: string                         # name of the new branch
  --verbose(-v)                               # show hash and subject, give twice for upstream branch
  --quiet(-q)                                 # suppress informational messages
  --track(-t)                                 # set up tracking mode (see git-pull(1))
  --set-upstream-to(-u): string               # change the upstream info
  --unset-upstream                            # unset the upstream info
  --color: string                             # use colored output
  --remotes(-r)                               # act on remote-tracking branches
  --contains: string                          # print only branches that contain the commit
  --no-contains: string                       # print only branches that don't contain the commit
  --abbrev: number                            # use <n> digits to display object names
  --all(-a)                                   # list both remote-tracking and local branches
  --delete(-d)                                # delete fully merged branch
  -D                                          # delete branch (even if not merged)
  --move(-m)                                  # move/rename a branch and its reflog
  -M                                          # move/rename a branch, even if target exists
  --copy(-c)                                  # copy a branch and its reflog
  -C                                          # copy a branch, even if target exists
  --list(-l)                                  # list branch names
  --show-current                              # show current branch name
  --create-reflog                             # create the branch's reflog
  --edit-description                          # edit the description for the branch
  --force(-f)                                 # force creation, move/rename, deletion
  --merged: string                            # print only branches that are merged
  --no-merged: string                         # print only branches that are not merged
  --column: string                            # list branches in columns
  --sort: string                              # field name to sort on
  --points-at: string                         # print only branches of the object
  --ignore-case(-i)                           # sorting and filtering are case insensitive
  --format: string                            # format to use for the output
]

export extern "git checkout" [
  branch?: string@"nu-complete git all branches"# name of the branch to checkout
  file?: string                                 # name of the file to checkout
  -b: string                                    # create and checkout a new branch
  -B: string                                    # create/reset and checkout a branch
  -l                                            # create reflog for new branch
  --guess                                       # second guess 'git checkout <no-such-branch>' (default)
  --overlay                                     # use overlay mode (default)
  --quiet(-q)                                   # suppress progress reporting
  --recurse-submodules: string                  # control recursive updating of submodules
  --progress                                    # force progress reporting
  --merge(-m)                                   # perform a 3-way merge with the new branch
  --conflict: string                            # conflict style (merge or diff3)
  --detach(-d)                                  # detach HEAD at named commit
  --track(-t)                                   # set upstream info for new branch
  --force(-f)                                   # force checkout (throw away local modifications)
  --orphan: string                              # new unparented branch
  --overwrite-ignore                            # update ignored files (default)
  --ignore-other-worktrees                      # do not check if another worktree is holding the given ref
  --ours(-2)                                    # checkout our version for unmerged files
  --theirs(-3)                                  # checkout their version for unmerged files
  --patch(-p)                                   # select hunks interactively
  --ignore-skip-worktree-bits                   # do not limit pathspecs to sparse entries only
  --pathspec-from-file: string                  # read pathspec from file
]

export extern "git push" [
  remote?: string@"nu-complete git remotes",  # the name of the remote
  refspec?: string@"nu-complete git branches" # the branch / refspec
  --verbose(-v)                               # be more verbose
  --quiet(-q)                                 # be more quiet
  --repo: string                              # repository
  --all                                       # push all refs
  --mirror                                    # mirror all refs
  --delete(-d)                                # delete refs
  --tags                                      # push tags (can't be used with --all or --mirror)
  --dry-run(-n)                               # dry run
  --porcelain                                 # machine-readable output
  --force(-f)                                 # force updates
  --force-with-lease: string                  # require old value of ref to be at this value
  --recurse-submodules: string                # control recursive pushing of submodules
  --thin                                      # use thin pack
  --receive-pack: string                      # receive pack program
  --exec: string                              # receive pack program
  --set-upstream(-u)                          # set upstream for git pull/status
  --progress                                  # force progress reporting
  --prune                                     # prune locally removed refs
  --no-verify                                 # bypass pre-push hook
  --follow-tags                               # push missing but relevant tags
  --signed: string                            # GPG sign the push
  --atomic                                    # request atomic transaction on remote side
  --push-option(-o): string                   # option to transmit
  --ipv4(-4)                                  # use IPv4 addresses only
  --ipv6(-6)                                  # use IPv6 addresses only
]
