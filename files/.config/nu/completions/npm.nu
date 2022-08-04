def "nu-comp npm" [] {
  ^npm -l | lines | find 'Run "' | str trim | split column -c ' ' | get column4 | str replace '"' ''
}

def "nu-comp npm scripts" [] {
  open package.json | get scripts | columns
}

export extern "npm" [
  command: string@"nu-comp npm"
  ...args: any
  --help(-h)                                     # help
  --version(-v)                                  # display version
  -l                                             # display usage info for all commands
]

export extern "npm ls" [
  ...args: any
  --help(-h)                                     # help
  --all(-a)
  --json
  --long(-l)
  --parseable(-p)
  --global(-g)
  --depth: number
  --omit: string
]

export extern "npm run" [
  script?: string@"nu-comp npm scripts"          # script to run
  ...args: any
  --help(-h)                                     # help
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
  --legacy-peer-deps
  --force(-f)
  --help(-h)                                     # help
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
  --help(-h)                                     # help
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
