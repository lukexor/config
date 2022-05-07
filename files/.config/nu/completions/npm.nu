def "nu-complete npm" [] {
  ^npm -l | lines | find 'Run "' | str trim | split column -c ' ' | get column4 | str replace '"' ''
}

def "nu-complete npm scripts" [] {
  open package.json | get scripts | columns
}

export extern "npm" [
  command: string@"nu-complete npm"
  ...args: any
  --version(-v)                                  # display version
  -l                                             # display usage info for all commands
]

export extern "npm run" [
  script?: string@"nu-complete npm scripts"      # script to run
  ...args: any
  --workspace(-w): string                        # run command in target workspace
  --workspaces                                   # run command in all workspaces
  --include-workspace-root                       # include workspace root
  --if-present                                   # don\'t exit with error if script is not defined
  --silent
  --ignore-scripts                               # do not run scripts specified in package.json
  --script-shell: string                         # shell to run scripts in (default "/bin/sh")
]

export extern "npm i" [
  ...packages: any
  --save(-S)
  --no-save
  --save-prod
  --save-dev(-D)
  --save-optional
  --save-peer
  --save-bundle
  --save-exact(-E)
  --global(-g)
  --global-style
  --legacy-bundling
  --omit: string
  --strict-peer-deps
  --no-package-lock
  --foreground-scripts
  --ignore-scripts
  --no-audit
  --no-bin-links
  --no-fund
  --dry-run
  --workspace(-w): string
  --include-workspace-root
]

export extern "npm install" [
  ...packages: any
  --save(-S)
  --no-save
  --save-prod
  --save-dev(-D)
  --save-optional
  --save-peer
  --save-bundle
  --save-exact(-E)
  --global(-g)
  --global-style
  --legacy-bundling
  --omit: string
  --strict-peer-deps
  --no-package-lock
  --foreground-scripts
  --ignore-scripts
  --no-audit
  --no-bin-links
  --no-fund
  --dry-run
  --workspace(-w): string
  --include-workspace-root
]
