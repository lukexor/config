# Yarn modes
def yarn-modes [] {
  [skip-build, update-lockfile]
}

# Yarn binaries
def yarn-bins [] {
  ^yarn bin --json | lines | each { |it| $it | from json } | $in.name
}

# Yarn configurations
def yarn-config [] {
  ^yarn config --json | lines | each { |it| $it | from json } | $in.key
}

# Yarn packages
def yarn-packages [] {
  let package_json = (open package.json)
  let deps = ($package_json | get dependencies | columns)
  let dev_deps = ($package_json | get devDependencies | columns)
  $deps | append $dev_deps
}

# Yarn scripts
def yarn-scripts [] {
    let scripts = (open package.json | get scripts | columns)
    let binaries = (yarn bin --json | lines | each { |it| $it | from json} | get name)
    $scripts | append $binaries
}

# Install dependencies.
export extern "main" [
]

# Add dependencies to the project.
export extern "yarn add" [
  package: string@yarn-packages # Package to add
  --json                        # Format the output as an NDJSON stream
  --exact(-E)                   # Don\'t use any semver modifier on the resolved range
  --tilde(-T)                   # Use the ~ semver modifier on the resolved range
  --caret(-C)                   # Use the ^ semver modifier on the resolved range
  --dev(-D)                     # Add a package as a dev dependency
  --peer(-P)                    # Add a package as a peer dependency
  --optional(-O)                # Add / upgrade a package to an optional regular / peer dependency
  --prefer-dev                  # Add / upgrade a package to a dev dependency
  --interactive(-i)             # Reuse the specified package from other workspaces in the project
  --cached                      # Reuse the highest version already used somewhere within the project
  --mode: string@yarn-modes     # Change what artifacts installs generate
]

# Get the path to a binary script.
export extern "yarn bin" [
  binary?: string@yarn-bins     # Binary to print path for
  --json                        # Format the output as an NDJSON stream
  --verbose(-v)                 # Print both the binary name and the locator of the package that provides the binary
]

# Read a configuration settings.
export extern "yarn config get" [
  name: string@yarn-config      # Config to get
  --json                        # Format the output as an NDJSON stream
  --no-redacted                 # Don\'t redact secrets (such as tokens) from the output
]

# Change a configuration settings.
export extern "yarn config set" [
  name: string@yarn-config      # Config to set
  value: string                 # Value to set
  --json                        # Set complex configuration settings to JSON values
  --home(-H)                    # Update the home configuration instead of the project configuration
]

# Unset a configuration settings.
export extern "yarn config unset" [
  name: string@yarn-config      # Config to unset
  --home(-H)                    # Update the home configuration instead of the project configuration
]

# Display the current configuration.
export extern "yarn config" [
  --verbose(-v)                 # Print the setting description on top of the regular key/value information
  --json                        # Format the output as an NDJSON stream
  --why                         # Print the reason why a setting is set a particular way
]

# See information related to packages.
export extern "yarn info" [
  package: string@yarn-packages
  --all(-A)                     # Print versions of a package from the whole project
  --recursive(-R)               # Print information for all packages, including transitive dependencies
  --extra(-X): string           # An array of requests of extra data provided by plugins
  --cache                       # Print information about the cache entry of a package (path, size, checksum)
  --dependents                  # Print all dependents for each matching package
  --manifest                    # Print data obtained by looking at the package archive (license, homepage, ...)
  --name-only                   # Only print the name for the matching packages
  --virtuals                    # Print each instance of the virtual packages
  --json                        # Format the output as an NDJSON stream
]

# Install the project dependencies.
export extern "yarn install" [
  --json                        # Format the output as an NDJSON stream
  --immutable                   # Abort with an error exit code if the lockfile was to be modified
  --immutable-cache             # Abort with an error exit code if the cache folder was to be modified
  --check-cache                 # Always refetch the packages and ensure that their checksums are consistent
  --inline-builds               # Verbosely print the output of the build steps of dependencies
  --mode: string@yarn-modes     # Change what artifacts installs generate
]

# Generate a tarball from the active workspace.
export extern "yarn pack" [
  --install-if-needed           # Run a priliminary yarn install if the package contains build scripts
  --dry-run(-n)                 # Print the file paths without actually generating the package archive
  --json                        # Format the output as an NDJSON stream
  --out(-o): string             # Create the archive at the specified path
]

# Rebuild the project's native packages
export extern "yarn rebuild" [
  ...packages: string@yarn-packages
]

# Remove a dependency from the project.
export extern "yarn remove" [
  --all(-A)                     # Apply the operation to all workspaces from the current project
  --mode: string@yarn-modes     # The mode to use when removing the dependency
]

# Run a script defined in the package.json.
export extern "yarn run" [
  script: string@yarn-scripts   # Script to run
  --inspect                     # forwarded to the underlying node process
  --inspect-brk                 # forwarded to the underlying node process
  --top-level(-T)               # Check the root workspace for scripts and/or binaries instead of the current one
  --binaries-only(-B)           # Ignore any user defined scripts and only check for binaries
]

# Open the search interface. NOTE: requires the interactive-tools plugin to be installed.
export extern "yarn search" []

# Lock the Yarn version used by the project.
export extern "yarn set version" [
  version: string               # Version to set
  --only-if-needed              # Only lock the yarn version if it isn\'t already locked
]

# Upgrade dependencies across the project.
export extern "yarn up" [
 --interactive(-i)              # Offer various choices, depending on the detected upgrade paths
 --exact(-E)                    # Don\'t use any semver modifier on the resolved range
 --tilde(-T)                    # Use the ~ semver modifier on the resolved range
 --caret(-C)                    # Use the ^ semver modifier on the resolved range
 --recursive(-R)                # Resolve again ALL resolutions for those packages
 --mode: string@yarn-modes      # Change what artifacts installs generate
]

# Display the reason why a package is needed.
export extern "yarn why" [
  package: string@yarn-packages # Package to query
  --recursive(-R)               # List, for each workspace, what are all the paths that lead to the dependency
  --json                        # Format the output as an NDJSON stream
  --peers                       # Also print the peer dependencies that match the specified name
]
