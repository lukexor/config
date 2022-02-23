def "nu-complete npm scripts" [] {
  open package.json | get scripts | transpose | get column0
}

extern "npm run" [
  script?: string@"nu-complete npm scripts"       # script to run
  --workspace(-w): string                        # run command in target workspace
  --workspaces                                   # run command in all workspaces
  --include-workspace-root                       # include workspace root
  --if-present                                   # don\'t exit with error if script is not defined
  --silent
  --ignore-scripts                               # do not run scripts specified in package.json
  --script-shell: string                         # shell to run scripts in (default "/bin/sh")
]
