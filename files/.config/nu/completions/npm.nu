# Npm commands
def npm-commands [] {
  ^npm -l | lines | find 'Run "' | str trim | split column -c ' ' | get column4 | str replace '"' ''
}

# Npm scripts
def npm-scripts [] {
  open package.json | get scripts | columns
}

# Node package manager
export extern "npm" [
  command: string@npm-commands # command to execute
  ...args: any
  -l                           # display usage info for all commands
  --version(-v)                # display version
  --help(-h)                   # help
]

# List installed packages
export extern "npm ls" [
  ...args: any
  --all(-a)
  --json
  --long(-l)
  --parseable(-p)
  --global(-g)
  --depth: number
  --omit: string
  --help(-h)                   # help
]

# Run package script
export extern "npm run" [
  script?: string@npm-scripts  # script to run
  ...args: any
  --workspace(-w): string      # run command in target workspace
  --workspaces                 # run command in all workspaces
  --include-workspace-root     # include workspace root
  --if-present                 # don\'t exit with error if script is not defined
  --silent
  --ignore-scripts             # do not run scripts specified in package.json
  --script-shell: string       # shell to run scripts in (default "/bin/sh")
  --help(-h)                   # help
]

# Install a package
export extern "npm i" [
  ...packages: any
  --legacy-peer-deps
  --force(-f)
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
  --help(-h)                   # help
]

# Install a package
export extern "npm install" [
  ...packages: any
  --legacy-peer-deps
  --force(-f)
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
  --help(-h)                   # help
]
