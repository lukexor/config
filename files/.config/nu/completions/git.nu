def "nu-comp git branches" [] {
  ^git branch | lines | each { |line| $line | str replace '\* ' "" | str trim }
}

def "nu-comp git all branches" [] {
  ^git branch -a | lines | wrap name | where name !~ HEAD | get name | each { |line| $line | str replace '\* ' "" | | str replace "remotes/origin/" "" | str trim } | uniq
}

def "nu-comp git remotes" [] {
  ^git remote | lines | each { |line| $line | str trim }
}

def "nu-comp git files" [] {
  ^git ls-files | lines
}

def "nu-comp files" [] {
  ^ls
}

def "nu-comp cleanup mode" [] {
  [strip whitespace verbatim scissors default]
}

def "nu-comp merge strategies" [] {
  [ort recursive resolve octopus ours subtree]
}

def "nu-comp merge strategy-options" [] {
  [ours theirs ignore-space-change ignore-all-space ignore-space-at-eol
  ignore-cr-at-eol renormalize no-renormalize find-renames rename-threshold
  subtree patience diff-algorithm no-renames]
}

export extern "git merge" [
  ...commits: string@"nu-comp git all branches"     # name of the branch to merge
  -n                                                # do not show a diffstat at the end of the merge
  --stat                                            # show a diffstat at the end of the merge
  --summary                                         # (synonym to --stat)
  --log: number                                     # add (at most <n>) entries from shortlog to merge commit message
  --squash                                          # create a single commit instead of doing a merge
  --commit                                          # perform a commit if the merge succeeds (default)
  --no-commit                                       # perform the merge and stop just before creating the merge commit
  --edit(-e)                                        # edit message before committing
  --no-edit                                         # accept the auto-generated message
  --cleanup: string@"nu-comp cleanup mode"          # how to strip spaces and #comments from message
  --ff                                              # allow fast-forward (default)
  --ff-only                                         # abort if fast-forward is not possible
  --rerere-autoupdate                               # update the index with reused conflict resolution if possible
  --verify-signatures                               # verify that the named commit has a valid GPG signature
  --strategy(-s): string@"nu-comp merge strategies" # merge strategy to use
  --strategy-option(-X): string@"nu-comp merge strategy-options" # option for selected merge strategy
  --message(-m): string                             # merge commit message (for a non-fast-forward merge)
  --file(-F): string@"nu-comp files"                # read message from file
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

export extern "git branch" [
  branch_or_old: string@"nu-comp git branches"   # name of the branch to target or old branch
  new_branch: string@"nu-comp git branches"      # name of the new branch
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
  --help(-h)                                     # help
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
  ...branch: string@"nu-comp git all branches"       # name of the branch to checkout
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
  remote: string@"nu-comp git remotes"        # the name of the remote
  ...refs: string@"nu-comp git branches"      # the branch / refspec
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
