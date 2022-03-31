def "nu-complete npm" [] {
  ^npm -l | lines | find 'Run "' | str trim | split column -c ' ' | get column4 | str find-replace '"' ''
}

def "nu-complete npm scripts" [] {
  open package.json | get scripts | columns
}

export extern "npm" [
  command: string@"nu-complete npm"
]

export extern "npm run" [
  script?: string@"nu-complete npm scripts"      # script to run
  --workspace(-w): string                        # run command in target workspace
  --workspaces                                   # run command in all workspaces
  --include-workspace-root                       # include workspace root
  --if-present                                   # don\'t exit with error if script is not defined
  --silent
  --ignore-scripts                               # do not run scripts specified in package.json
  --script-shell: string                         # shell to run scripts in (default "/bin/sh")
]
