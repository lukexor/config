export alias cb = cargo build
export alias cbr = cargo build --release
export alias cc = cargo clippy
export alias cca = cargo clippy --all-targets
export alias cdoc = cargo doc
export alias cdoco = cargo doc --open
export alias cr = cargo run
export alias crd = cargo run --profile dev-opt
export alias crr = cargo run --release
export alias ct = cargo test --workspace --all-targets
export alias cw = cargo watch

# Cargo targets
def cargo-targets [type: string] {
  ^cargo metadata --format-version 1 --offline --no-deps | from json | get packages.targets | flatten | where ($type in $it.kind) | get name
}
# Cargo binaries
def cargo-bins [] { cargo-targets bins }
# Cargo examples
def cargo-examples [] { cargo-targets example }
# Cargo packages
def cargo-packages [] {
  ^cargo metadata --format-version 1 --offline --no-deps | from json | get workspace_members | split column ' ' name version source | get name
}
# Cargo profiles
def cargo-profiles [] {
  let profiles = (open Cargo.toml | get -i profile)
  if ($profiles | is-empty) {
    []
  } else {
    ($profiles | transpose name values | get name)
  }
}
# Cargo features
def cargo-features [] {
  let features = (open Cargo.toml | get -i features)
  if ($features | is-empty) {
    []
  } else {
    ($features | transpose name values | where name !~ "default" | get name)
  }
}
# Cargo commands
def cargo-commands [] {
  ^cargo --list | lines | skip 1 | str join "\n" | from ssv --noheaders | rename name description | get name
}

# Cargo vcs options
def cargo-vcs [] {
  [git, hg, pijul, fossil, none]
}
# Cargo color modes
def cargo-color [] {
  [auto, always, never]
}
# Cargo asm-styles
def asm-styles [] {
  [intel, att]
}
# Cargo build-types
def build-types [] {
  [debug, release]
}
# Cargo outdated format
def outdated-format [] {
  [List, Json]
}

# Run cargo example
export def cre [example: string@cargo-examples] {
  cargo run --example $example
}

# Rust's package manager
export extern "main"  [
  ...args: any
  --version(-V)                         # Print version info and exit
  --list                                # List installed commands
  --explain: number                     # Run `rustc --explain CODE`
  --verbose(-v)                         # Use verbose output. May be specified twice for "very verbose" output
  --quiet(-q)                           # Do not print cargo log messages
  --color: string@cargo-color           # Control when colored output is used
  --frozen                              # Require Cargo.lock and cache are up to date
  --locked                              # Require Cargo.lock is up to date
  --offline                             # Run without accessing the network
  --config: string                      # Override a configuration value
  -Z: any                               # Unstable (nightly-only) flags to Cargo, see 'cargo -Z help' for details
  --help(-h)                            # Print help information
]

# Compile a local package and all of its dependencies
export extern "cargo build" [
  --package(-p): string@cargo-packages  # Build only the specified packages
  --workspace                           # Build all members in the workspace
  --exclude: string@cargo-packages      # Exclude the specified packages
  --lib                                 # Build the package\'s library
  --bin: string@cargo-bins              # Build the specified binary
  --bins                                # Build all binary targets
  --example: string@cargo-examples      # Build the specified example
  --examples                            # Build all example targets
  --test: string                        # Build the specified integration test
  --tests                               # Build all targets in test mode that have the test = true manifest flag set
  --bench: string                       # Build the specified benchmark
  --benches                             # Build all targets in benchmark mode that have the bench = true manifest flag set
  --all-targets                         # Build all targets
  --features: string@cargo-features     # Space or comma separated list of features to activate
  --all-features                        # Activate all available features of all selected packages
  --no-default-features                 # Do not activate the default feature of the selected packages
  --target: string                      # Build for the given architecture.
  --release(-r)                         # Build optimized artifacts with the release profile
  --profile: string@cargo-profiles      # Build with the given profile
  --ignore-rust-version                 # Ignore `rust-version` specification in packages
  --timings: string                     # Output information how long each compilation takes
  --target-dir: path                    # Directory for all generated artifacts and intermediate files
  --out-dir: path                       # Copy final artifacts to this directory
  --verbose(-v)                         # Use verbose output. May be specified twice for "very verbose" output
  --quiet(-q)                           # Do not print cargo log messages
  --color: string@cargo-color           # Control when colored output is used
  --message-format: string              # The output format for diagnostic messages
  --build-plan                          # Outputs a series of JSON messages to stdout that indicate the commands to run the build
  --manifest-path: path                 # Path to the Cargo.toml file
  --frozen                              # Require Cargo.lock and cache are up to date
  --locked                              # Require Cargo.lock is up to date
  --offline                             # Run without accessing the network
  --jobs(-j): number                    # Number of parallel jobs to run
  --future-incompat-report              # Displays a future-incompat report for any future-incompatible warnings
  -Z: any                               # Unstable (nightly-only) flags to Cargo, see 'cargo -Z help' for details
  --help(-h)                            # Print help information
]

# Check a local package and all of its dependencies for errors
export extern "cargo check" [
  --package(-p): string@cargo-packages  # Check only the specified packages
  --workspace                           # Check all members in the workspace
  --exclude: string@cargo-packages      # Exclude the specified packages
  --lib                                 # Check the package\'s library
  --bin: string@cargo-bins              # Check the specified binary
  --example: string@cargo-examples      # Check the specified example
  --examples                            # Check all example targets
  --test: string                        # Check the specified integration test
  --tests                               # Check all targets in test mode that have the test = true manifest flag set
  --bench: string                       # Check the specified benchmark
  --benches                             # Check all targets in benchmark mode that have the bench = true manifest flag set
  --all-targets                         # Check all targets
  --features: string@cargo-features     # Space or comma separated list of features to activate
  --all-features                        # Activate all available features
  --no-default-features                 # Do not activate the `default` feature
  --target: string                      # Check for the given architecture
  --release(-r)                         # Check optimized artifacts with the release profile
  --profile: string@cargo-profiles      # Check with the given profile
  --ignore-rust-version                 # Ignore `rust-version` specification in packages
  --timings: string                     # Output information how long each compilation takes
  --target-dir: path                    # Directory for all generated artifacts and intermediate files
  --verbose(-v)                         # Use verbose output. May be specified twice for "very verbose" output
  --quiet(-q)                           # Do not print cargo log messages
  --color: string@cargo-color           # Control when colored output is used
  --message-format: string              # The output format for diagnostic messages
  --manifest-path: path                 # Path to the Cargo.toml file
  --frozen                              # Require Cargo.lock and cache are up to date
  --locked                              # Require Cargo.lock is up to date
  --offline                             # Run without accessing the network
  --jobs(-j): number                    # Number of parallel jobs to run
  --keep-going                          # Build as many crates in the dependency graph as possible
  --future-incompat-report              # Displays a future-incompat report for any future-incompatible warnings
  -Z: any                               # Unstable (nightly-only) flags to Cargo, see 'cargo -Z help' for details
  --help(-h)                            # Print help information
]

# Remove artifacts that cargo has generated in the past
export extern "cargo clean" [
  --package(-p): string@cargo-packages  # Clean only the specified packages
  --doc                                 # Remove only the doc directory in the target directory
  --release                             # Remove all artifacts in the release directory
  --profile                             # Remove all artifacts in the directory with the given profile name
  --target-dir: path                    # Directory for all generated artifacts and intermediate files
  --target: string                      # Clean for the given architecture
  --verbose(-v)                         # Use verbose output. May be specified twice for "very verbose" output
  --quiet(-q)                           # Do not print cargo log messages
  --color: string@cargo-color           # Control when colored output is used
  --message-format: string              # The output format for diagnostic messages
  --manifest-path: path                 # Path to the Cargo.toml file
  --frozen                              # Require Cargo.lock and cache are up to date
  --locked                              # Require Cargo.lock is up to date
  --offline                             # Run without accessing the network
  -Z: any                               # Unstable (nightly-only) flags to Cargo, see 'cargo -Z help' for details
  --help(-h)                            # Print help information
]

# Build a package's documentation
export extern "cargo doc" [
  --open                                # Open the docs in a browser after building them
  --no-deps                             # Do not build documentation for dependencie
  --document-private-items              # Include non-public items in the documentation
  --package(-p): string@cargo-packages  # Document only the specified packages
  --workspace                           # Document all members in the workspace
  --exclude: string@cargo-packages      # Exclude the specified packages
  --lib: string                         # Document the package\'s library
  --bin: string@cargo-bins              # Document the specified binary
  --bins                                # Document all binary targets
  --example: string@cargo-examples      # Document the specified example
  --examples                            # Document all example targets
  --features: string@cargo-features     # Space or comma separated list of features to activate
  --all-features                        # Activate all available features of all selected packages
  --no-default-features                 # Do not activate the default feature of the selected packages
  --target: string                      # Document for the given architecture
  --release(-r)                         # Document optimized artifacts with the release profile
  --profile: string@cargo-profiles      # Document with the given profile
  --ignore-rust-version                 # Ignore `rust-version` specification in packages
  --timings: string                     # Output information how long each compilation takes
  --target-dir: path                    # Directory for all generated artifacts and intermediate files
  --verbose(-v)                         # Use verbose output. May be specified twice for "very verbose" output
  --quiet(-q)                           # Do not print cargo log messages
  --color: string@cargo-color           # Control when colored output is used
  --message-format: string              # The output format for diagnostic messages
  --manifest-path: path                 # Path to the Cargo.toml file
  --frozen                              # Require Cargo.lock and cache are up to date
  --locked                              # Require Cargo.lock is up to date
  --offline                             # Run without accessing the network
  --jobs(-j): number                    # Number of parallel jobs to run
  --keep-going                          # Build as many crates in the dependency graph as possible
  -Z: any                               # Unstable (nightly-only) flags to Cargo, see 'cargo -Z help' for details
  --help(-h)                            # Print help information
]

# Create a new cargo package at <path>
export extern "cargo new" [
  path: path                            # The directory that will contain the project
  --bin                                 # Create a package with a binary target (src/main.rs) (default)
  --lib                                 # Create a package with a library target (src/lib.rs)
  --edition: number                     # Specify the Rust edition to use (default: 2021)
  --name: string                        # Set the package name. Defaults to the directory name.
  --vcs: string@cargo-vcs               # Initialize a new VCS repository for the given version control system
  --registry: string                    # Name of the registry to use
  --verbose(-v)                         # Use verbose output. May be specified twice for "very verbose" output
  --quiet(-q)                           # Do not print cargo log messages
  --color: string@cargo-color           # Control when colored output is used
  -Z: any                               # Unstable (nightly-only) flags to Cargo, see 'cargo -Z help' for details
  --help(-h)                            # Print help information
]

# Create a new cargo package in an existing directory
export extern "cargo init" [
  path: path                            # The directory that will contain the project
  --bin                                 # Create a package with a binary target (src/main.rs) (default)
  --lib                                 # Create a package with a library target (src/lib.rs)
  --edition: number                     # Specify the Rust edition to use (default: 2021)
  --name: string                        # Set the package name. Defaults to the directory name.
  --vcs: string@cargo-vcs               # Initialize a new VCS repository for the given version control system
  --registry: string                    # Name of the registry to use
  --verbose(-v)                         # Use verbose output. May be specified twice for "very verbose" output
  --quiet(-q)                           # Do not print cargo log messages
  --color: string@cargo-color           # Control when colored output is used
  -Z: any                               # Unstable (nightly-only) flags to Cargo, see 'cargo -Z help' for details
  --help(-h)                            # Print help information
]

# Run a binary or example of the local package
export extern "cargo run" [
  ...args: any                          # Arguments to be passed to your program
  --bin: string@cargo-bins              # Name of the bin target to run
  --example: string@cargo-examples      # Name of the example target to run
  --quiet(-q)                           # Do not print cargo log messages
  --package(-p): string@cargo-packages  # Package with the target to run
  --jobs(-j): number                    # Number of parallel jobs, defaults to # of CPUs
  --release                             # Build artifacts in release mode, with optimizations
  --profile: string@cargo-profiles      # Build artifacts with the specified profile
  --features: string@cargo-features     # Space or comma separated list of features to activate
  --all-features                        # Activate all available features
  --no-default-features                 # Do not activate the `default` feature
  --target: string                      # Build for the target triple
  --target-dir: path                    # Directory for all generated artifacts
  --manifest-path: path                 # Path to Cargo.toml
  --message-format: string              # Error format
  --unit-graph                          # Output build graph in JSON (unstable)
  --ignore-rust-version                 # Ignore `rust-version` specification in packages
  --verbose(-v)                         # Use verbose output (-vv very verbose/build.rs output)
  --color: string@cargo-color           # Control when colored output is used
  --frozen                              # Require Cargo.lock and cache are up to date
  --locked                              # Require Cargo.lock is up to date
  --offline                             # Run without accessing the network
  --config: string                      # Override a configuration value (unstable)
  -Z: any                               # Unstable (nightly-only) flags to Cargo, see 'cargo -Z help' for details
  --help(-h)                            # Prints help information
]

# Watches over your Cargo project’s source
export extern "cargo watch" [
  ...args: any                          # Full command to run. -x and -s will be ignored!
  --ignore-nothing                      # Ignore nothing, not even target/ and .git/
  --no-gitignore                        # Don’t use .gitignore files
  --debug                               # Show debug output
  --help(-h)                            # Display this message
  --use-shell                           # Use a different shell. E.g. --use-shell=bash
  --features                            # List of features passed to cargo invocations
  --ignore(-i)                          # Ignore a glob/gitignore-style pattern
  --postpone                            # Postpone first run until a file changes
  --no-ignore                           # Don’t use .ignore files
  --why                                 # Show paths that changed
  --clear(-c)                           # Clear the screen before each run
  --delay(-d)                           # File updates debounce delay in seconds [default: 0.5]
  --version(-V)                         # Display version information
  --watch-when-idle                     # Ignore events emitted while the commands run. Will become default behaviour in 8.0.
  --exec(-x)                            # Cargo command(s) to execute on changes [default: check]
  --shell(-s)                           # Shell command(s) to execute on changes
  --watch(-w)                           # Watch specific file(s) or folder(s) [default: .]
  --workdir(-C)                         # Change working directory before running command [default: crate root]
  --poll                                # Force use of polling for file changes
  --notify(-N)                          # Send a desktop notification when watchexec notices a change (experimental, behaviour may
  --no-restart                          # Don’t restart command while it’s still running
  --quiet(-q)                           # Suppress output from cargo-watch itself
]

# Execute all unit and integration tests and build examples of a local package
export extern "cargo test" [
  test_arg_seperator?: string
  ...args: any                          # Arguments to be passed to the tests
  --no-run                              # Compile, but don\'t run tests
  --no-fail-fast                        # Run all tests regardless of failure
  --package(-p): string@cargo-packages  # Test only the specified packages
  --workspace                           # Test all members in the workspace
  --exclude: string@cargo-packages      # Exclude the specified packages
  --lib                                 # Test the package\'s library
  --bin: string@cargo-bins              # Test only the specified binary
  --bins                                # Test all binaries
  --example: string@cargo-examples      # Test only the specified example
  --examples                            # Test all examples
  --test: string                        # Test the specified integration test
  --tests                               # Test all targets in test mode that have the test = true manifest flag set
  --bench: string                       # Test the specified benchmark
  --benches                             # Test all targets in benchmark mode that have the bench = true manifest flag set
  --all-targets                         # Test all targets
  --doc                                 # Test ONLY the library\'s documentation
  --features: string@cargo-features     # Space or comma separated list of features to activate
  --all-features                        # Activate all available features of all selected packages
  --no-default-features                 # Do not activate the default feature of the selected packages
  --target: string                      # Test for the given architecture
  --release(-r)                         # Test optimized artifacts with the release profile
  --profile: string@cargo-profiles      # Test with the given profile
  --ignore-rust-version                 # Ignore `rust-version` specification in packages
  --timings: string                     # Output information how long each compilation takes
  --target-dir: path                    # Directory for all generated artifacts and intermediate files
  --verbose(-v)                         # Use verbose output. May be specified twice for "very verbose" output
  --quiet(-q)                           # Do not print cargo log messages
  --color: string@cargo-color           # Control when colored output is used
  --message-format: string              # The output format for diagnostic messages
  --manifest-path: path                 # Path to the Cargo.toml file
  --frozen                              # Require Cargo.lock and cache are up to date
  --locked                              # Require Cargo.lock is up to date
  --offline                             # Run without accessing the network
  --jobs(-j): number                    # Number of parallel jobs to run
  --keep-going                          # Build as many crates in the dependency graph as possible
  --future-incompat-report              # Displays a future-incompat report for any future-incompatible warnings
  -Z: any                               # Unstable (nightly-only) flags to Cargo, see 'cargo -Z help' for details
  --help(-h)                            # Prints help information
]

# Execute all benchmarks of a local package
export extern "cargo bench" [
  bench_option_seperator?: string
  ...options: any                       # Options to be passed to the benchmarks
  --no-run                              # Compile, but don\'t run benchmarks
  --no-fail-fast                        # Run all benchmarks regardless of failure
  --package(-p): string@cargo-packages  # Benchmark only the specified packages
  --workspace                           # Benchmark all members in the workspace
  --exclude: string@cargo-packages      # Exclude the specified packages
  --lib                                 # Benchmark the package\'s library
  --bin: string@cargo-bins              # Benchmark only the specified binary
  --bins                                # Benchmark all binary targets
  --example: string@cargo-examples      # Benchmark only the specified example
  --examples                            # Benchmark all example targets
  --test: string                        # Benchmark the specified integration test
  --tests                               # Benchmark all targets in test mode that have the test = true
  --bench: string                       # Benchmark the specified benchmark
  --benches                             # Benchmark all targets in benchmark mode that have the bench = true manifest flag set
  --all-targets                         # Benchmark all targets
  --features: string@cargo-features     # Space or comma separated list of features to activate
  --all-features                        # Activate all available features of all selected packages
  --no-default-features                 # Do not activate the default feature of the selected packages
  --target: string                      # Benchmark for the given architecture
  --profile: string@cargo-profiles      # Build artifacts with the specified profile
  --ignore-rust-version                 # Ignore `rust-version` specification in packages
  --timings: string                     # Output information how long each compilation takes
  --target-dir: path                    # Directory for all generated artifacts and intermediate files
  --verbose(-v)                         # Use verbose output. May be specified twice for "very verbose" output
  --quiet(-q)                           # Do not print cargo log messages
  --color: string@cargo-color           # Control when colored output is used
  --message-format: string              # The output format for diagnostic messages
  --build-plan                          # Outputs a series of JSON messages to stdout that indicate the commands to run the build
  --manifest-path: path                 # Path to the Cargo.toml file
  --frozen                              # Require Cargo.lock and cache are up to date
  --locked                              # Require Cargo.lock is up to date
  --offline                             # Run without accessing the network
  --jobs(-j): number                    # Number of parallel jobs to run
  --keep-going                          # Build as many crates in the dependency graph as possible
  -Z: any                               # Unstable (nightly-only) flags to Cargo, see 'cargo -Z help' for details
  --help(-h)                            # Print help information
]

# Update dependencies as recorded in the local lock file
export extern "cargo update" [
  --package(-p): string@cargo-packages  # Update only the specified packages
  --aggressive                          # Dependencies of the specified packages are forced to update as well
  --precise: any                        # Allows you to specify a specific version number to set the package to
  --workspace(-w)                       # Attempt to update only packages defined in the workspace
  --dry-run                             # Displays what would be updated but doesn\'t write the lockfile
  --verbose(-v)                         # Use verbose output. May be specified twice for "very verbose" output
  --quiet(-q)                           # Do not print cargo log messages
  --color: string@cargo-color           # Control when colored output is used
  --manifest-path: path                 # Path to the Cargo.toml file
  --frozen                              # Require Cargo.lock and cache are up to date
  --locked                              # Require Cargo.lock is up to date
  --offline                             # Run without accessing the network
  -Z: any                               # Unstable (nightly-only) flags to Cargo, see 'cargo -Z help' for details
  --help(-h)                            # Prints help information
]

# Add dependencies to a Cargo.toml manifest file
export extern "cargo add" [
  ...deps: any
  --no-default-features                 # Disable the default features
  --default-features                    # Re-enable the default features
  --features(-F): string@cargo-features # Space or comma separated list of features to activate
  --optional                            # Mark the dependency as optional
  --verbose(-v)                         # Use verbose output (-vv very verbose/build.rs output)
  --no-optional                         # Mark the dependency as required
  --color: string@cargo-color           # Coloring: auto, always, never
  --rename: string                      # Rename the dependency
  --frozen                              # Require Cargo.lock and cache are up to date
  --manifest-path: path                 # Path to Cargo.toml
  --locked                              # Require Cargo.lock is up to date
  --package(-p): string@cargo-packages  # Package to modify
  --offline                             # Run without accessing the network
  --quiet(-q)                           # Do not print cargo log messages
  --config: string                      # Override a configuration value
  --dry-run                             # Don\'t actually write the manifest
  -Z: any                               # Unstable (nightly-only) flags to Cargo, see 'cargo -Z help' for details
  --help(-h)                            # Print help information
  --path: path                          # Filesystem path to local crate to add
  --git: string                         # Git repository location
  --branch: string                      # Git branch to download the crate from
  --tag: string                         # Git tag to download the crate from
  --rev: string                         # Git reference to download the crate from
  --registry: string                    # Package registry for this dependency
  --dev                                 # Add as development dependency
  --build                               # Add as build dependency
  --target: string                      # Add as dependency to the given target platform
]

# Search packages in crates.io
export extern "cargo search" [
  query: string                         # The thing to search
  --limit: number                       # Limit the number of results. (default: 10, max: 100)
  --index: string                       # The URL of the registry index to use
  --registry: string                    # Name of the registry to use
  --verbose(-v)                         # Use verbose output. May be specified twice for "very verbose" output
  --quiet(-q)                           # Do not print cargo log messages
  --color: string@cargo-color           # Control when colored output is used
  --help(-h)                            # Prints help information
  -Z: any                               # Unstable (nightly-only) flags to Cargo, see 'cargo -Z help' for details
]

# Upload a package to the registry
export extern "cargo publish" [
  --dry-run                             # Perform all checks without uploading
  --token: any                          # API token to use when authenticating
  --no-verify                           # Don\'t verify the contents by building them
  --allow-dirty                         # Allow working directories with uncommitted VCS changes to be packaged
  --index: string                       # The URL of the registry index to use
  --registry: string                    # Name of the registry to publish to
  --package(-p): string@cargo-packages  # The package to publish
  --target: string                      # Publish for the given architecture
  --target-dir: path                    # Directory for all generated artifacts and intermediate files
  --features: string@cargo-features     # Space or comma separated list of features to activate
  --all-features                        # Activate all available features of all selected packages
  --no-default-features                 # Do not activate the default feature of the selected packages
  --verbose(-v)                         # Use verbose output. May be specified twice for "very verbose" output
  --quiet(-q)                           # Do not print cargo log messages
  --color: string@cargo-color           # Control when colored output is used
  --manifest-path: path                 # Path to the Cargo.toml file
  --frozen                              # Require Cargo.lock and cache are up to date
  --locked                              # Require Cargo.lock is up to date
  --offline                             # Run without accessing the network
  --help(-h)                            # Prints help information
  -Z: any                               # Unstable (nightly-only) flags to Cargo, see 'cargo -Z help' for details
  --jobs(-j): number                    # Number of parallel jobs to run
  --keep-going                          # Build as many crates in the dependency graph as possible
]

# Install a Rust binary. Default location is $HOME/.cargo/bin
export extern "cargo install" [
  crate?: string                        # The crate to install
  --version: string                     # Specify a version to install
  --vers: string                        # Specify a version to install
  --git: string                         # Git URL to install the specified crate from
  --branch: string                      # Branch to use when installing from git
  --tag: string                         # Tag to use when installing from git
  --rev: string                         # Specific commit to use when installing from git
  --path: path                          # Filesystem path to local crate to install
  --list                                # List all installed packages and their versions
  --force(-f)                           # Force overwriting existing crates or binaries
  --no-track                            # Don\'t keep track of this package
  --bin: string@cargo-bins              # Install only the specified binary
  --bins                                # Install all binaries
  --example: string@cargo-examples      # Install only the specified example
  --examples                            # Install all examples
  --root: path                          # Directory to install packages into
  --registry: string                    # Name of the registry to use
  --index: string                       # The URL of the registry index to use
  --features: string@cargo-features     # Space or comma separated list of features to activate
  --all-features                        # Activate all available features of all selected packages
  --no-default-features                 # Do not activate the default feature of the selected packages
  --target: string                      # Install for the given architecture
  --target-dir: path                    # Directory for all generated artifacts and intermediate files
  --debug                               # Build with the dev profile instead the release profile
  --profile: string@cargo-profiles      # Build artifacts with the specified profile
  --timings: string                     # Output information how long each compilation takes
  --frozen                              # Require Cargo.lock and cache are up to date
  --locked                              # Require Cargo.lock is up to date
  --offline                             # Run without accessing the network
  --jobs(-j): number                    # Number of parallel jobs to run
  --verbose(-v)                         # Use verbose output. May be specified twice for "very verbose" output
  --quiet(-q)                           # Do not print cargo log messages
  --color: string@cargo-color           # Control when colored output is used
  --message-format: string              # The output format for diagnostic messages
  -Z: any                               # Unstable (nightly-only) flags to Cargo, see 'cargo -Z help' for details
  -h, --help                            # Print help information
]

# Remove a Rust binary
export extern "cargo uninstall" [
  package?: string@cargo-packages       # Package to uninstall
  --package(-p): string@cargo-packages  # Package to uninstall
  --bin: string@cargo-bins              # Only uninstall the binary name
  --root: path                          # Directory to uninstall packages from
  --verbose(-v)                         # Use verbose output. May be specified twice for "very verbose" output
  --quiet(-q)                           # Do not print cargo log messages
  --color: string@cargo-color           # Control when colored output is used
  -Z: any                               # Unstable (nightly-only) flags to Cargo, see 'cargo -Z help' for details
  -h, --help                            # Print help information
]

# Output the resolved dependencies of a package, the concrete used versions including overrides, in
# machine-readable format
export extern "cargo metadata"  [
  --no-deps                             # Output information only about the workspace members and don\'t fetch dependencies
  --format-version: number              # Specify the version of the output format to use. Currently 1 is the only possible value
  --filter-platform: string             # This filters the resolve output to only include dependencies for the iven target triple
  --features: string@cargo-features     # Space or comma separated list of features to activate
  --all-features                        # Activate all available features of all selected packages
  --no-default-features                 # Do not activate the default feature of the selected packages
  --verbose(-v)                         # Use verbose output. May be specified twice for "very verbose" output
  --quiet(-q)                           # Do not print cargo log messages
  --color: string@cargo-color           # Control when colored output is used
  --manifest-path: path                 # Path to the Cargo.toml file
  --frozen                              # Require Cargo.lock and cache are up to date
  --locked                              # Require Cargo.lock is up to date
  --offline                             # Run without accessing the network
  --help(-h)                            # Prints help information
  -Z: any                               # Unstable (nightly-only) flags to Cargo, see 'cargo -Z help' for details
]

# Show Man page for a Cargo command
export extern "cargo help" [
  subcommand: string@cargo-commands
  --color: string@cargo-color           # Control when colored output is used
  --config: string                      # Override a configuration value
  --frozen                              # Require Cargo.lock and cache are up to date
  --locked                              # Require Cargo.lock is up to date
  --offline                             # Run without accessing the network
  --verbose(-v)                         # Use verbose output. May be specified twice for "very verbose" output
  -Z: any                               # Unstable (nightly-only) flags to Cargo, see 'cargo -Z help' for details
]

# Checks a package to catch common mistakes and improve your Rust code.
export extern "cargo clippy" [
  --all-targets                         # Build all targets
  --no-deps                             # Run Clippy only on the given crate, without linting the dependencies
  --fix                                 # Automatically apply lint suggestions. This flag implies `--no-deps`
  --version(-V)                         # Prints version information
  --help(-h)                            # Prints help information
]

# This utility formats all bin and lib files of the current crate using rustfmt.
extern "cargo fmt" [
  ...args: any                          # rustfmt options
  --check                               # Run rustfmt in check mode
  --manifest-path                       # Specify path to Cargo.toml
  --all                                 # Format all packages, and also their local path-based dependencies
  --message-format                      # Specify message-format: short|json|human
  --package(-p)                         # Specify package to format
  --help(-h)                            # Print help information
  --quiet(-q)                           # No output printed to stdout
  --verbose(-v)                         # Use verbose output
  --version                             # Print rustfmt version and exit
]

# Shows the assembly generated for a Rust function.
export extern "cargo asm" [
  ...args: any
  --comments                            # Print assembly comments.
  --debug-info                          # Generates assembly with debugging information even if that\'s not required.
  --debug-mode                          # Prints output useful for debugging.
  --directives                          # Print assembly directives.
  --json                                # Serialize asm AST to json (ignores most other options).
  --lib                                 # Builds only the lib target.
  --no-color                            # Disable colored output.
  --no-default-features                 # Disables all cargo features when building the project.
  --rust                                # Print interleaved Rust code.
  --version(-V)                         # Prints version information
  --target: string                      # Build for the target triple.
  --asm-styles: string@asm-styles       # Assembly style: intel, att. [default: intel]
  --build-types: string@build-types     # Build type: debug, release. [default: release]
  --features: string                    # cargo --features
  --manifest-path: path                 # Runs cargo-asm in a different path.
  --help(-h)                            # Prints help information
]

# Find out what takes most of the space in your executable
export extern "cargo bloat" [
  ...args: any
  --version(-V)                         # Prints version information
  --lib                                 # Build only this package\'s library
  --bin: string@cargo-bins              # Build only the specified binary
  --example: string@cargo-examples      # Build only the specified example
  --test: string                        # Build only the specified test target
  --package(-p): string@cargo-packages  # Package to build
  --release                             # Build artifacts in release mode, with optimizations
  --jobs(-j): number                    # Number of parallel jobs, defaults to # of CPUs
  --features: string@cargo-features     # Space-separated list of features to activate
  --all-features                        # Activate all available features
  --no-default-features                 # Do not activate the `default` feature
  --profile: string@cargo-profiles      # Build with the given profile.
  --target: string                      # Build for the target triple
  --target-dir: path                    # Directory for all generated artifacts
  --frozen                              # Require Cargo.lock and cache are up to date
  --locked                              # Require Cargo.lock is up to date
  --crates                              # Per crate bloatedness
  --time                                # Per crate build time. Will run `cargo clean` first
  --filter: string                      # Filter functions by crate
  --split-std                           # Split the 'std' crate to original crates like core, alloc, etc.
  --symbols-section: string             # Use custom symbols section (ELF-only) [default: .text]
  --no-relative-size                    # Hide 'File' and '.text' columns
  --full-fn                             # Print full function name with hash values
  --wide(-w)                            # Do not trim long function names
  --message-format                      # Output format [default: table] [possible values: table, json]
  -n: number                            # Number of lines to show, 0 to show all [default: 20]
  -Z: string                            # Unstable (nightly-only) flags to Cargo, see 'cargo -Z help' for details
  --help(-h)                            # Prints help information
]

# Show the result of macro expansion
export extern "cargo expand" [
  ...args: any
  --features: string@cargo-features     # Space-separated list of features to activate
  --all-features                        # Activate all available features
  --no-default-features                 # Do not activate the `default` feature
  --lib                                 # Expand only this package\'s library
  --bin: string@cargo-bins              # Expand only the specified binary
  --example: string@cargo-examples      # Expand only the specified example
  --test: string                        # Expand only the specified test target
  --tests                               # Include tests when expanding the lib or bin
  --bench: string                       # Expand only the specified bench target
  --target: string                      # Target triple which compiles will be for
  --target-dir: path                    # Directory for all generated artifacts
  --manifest-path: path                 # Path to Cargo.toml
  --package(-p)                         # Package to expand
  --release                             # Build artifacts in release mode, with optimizations
  --profile: string@cargo-profiles      # Build artifacts with the specified profile
  --jobs(-j): number                    # Number of parallel jobs, defaults to # of CPUs
  --verbose                             # Print command lines as they are executed
  --color: string@cargo-color           # Coloring: auto, always, never
  --frozen                              # Require Cargo.lock and cache are up to date
  --locked                              # Require Cargo.lock is up to date
  --offline                             # Run without accessing the network
  --ugly                                # Do not attempt to run rustfmt
  --theme: string                       # Select syntax highlighting theme
  --themes                              # Print available syntax highlighting theme names
  --version(-V)                         # Print version information
  -Z: any                               # Unstable (nightly-only) flags to Cargo
  --help(-h)                            # Print help information
]

# A cargo subcommand for generating flamegraphs, using inferno
export extern "cargo flamegraph" [
  ...args: any
  --bin(-b): string@cargo-bins          # Binary to run
  --bench: string                       # Benchmark to run
  --cmd(-c): string                     # Custom command for invoking perf/dtrace
  --deterministic                       # Colors are selected such that the color of a function does not change between runs
  --dev                                 # Build with the dev profile
  --example: string@cargo-examples      # Example to run
  --features(-f): string@cargo-features # Build features to enable
  --freq(-F): number                    # Sampling frequency
  --flamechart                          # Produce a flame chart (sort by time, do not merge stacks)
  --inverted(-i)                        # Plot the flame graph up-side-down
  --image-width: number                 # Image width in pixels
  --manifest-path: path                 # Path to Cargo.toml
  --min-width: number                   # Omit functions smaller than <FLOAT> pixels [default: 0.01]
  --no-default-features                 # Disable default features
  --no-inline                           # Disable inlining for perf script because of performance issues
  --notes: string                       # Set embedded notes in SVG
  --output(-o): path                    # Output file [default: flamegraph.svg]
  --open                                # Open the output .svg file with default program
  --package(-p): string@cargo-packages  # package with the binary to run
  --palette: string                     # Color palette [possible values: hot, mem, io, red, green, blue, aqua, yellow, purple,
                                        # orange, wakeup, java, perl, js, rust]
  --reverse                             # Generate stack-reversed flame graph
  --root                                # Run with root privileges (using `sudo`)
  --skip-after: string                  # Cut off stack frames below <FUNCTION>; may be repeated
  --test: string                        # Test binary to run (currently profiles the test harness and all tests in the binary)
  --unit-test: string                   # Crate target to unit test, <unit-test> may be omitted if crate only has one target
                                        # (currently profiles the test harness and all tests in the binary; test selection can be
                                        # passed as trailing arguments after `--` as separator)
  --verbose(-v)                         # Print extra output to help debug problems
  --version(-V)                         # Print version information
  --help(-h)                            # Print help information
]

# Displays information about project dependency versions
export extern "cargo outdated" [
    ...args: any
    --aggresssive(-a)                   # Ignores channels for latest updates
    --color: string@cargo-color         # Output coloring [default: auto]  [possible values: Auto, Never, Always]
    --depth(-d): number                 # How deep in the dependency chain to search (Defaults to all dependencies when
    --exclude(-x): string               # Dependencies to exclude from building (comma separated or one per '--exclude' argument)
    --exit-code: number                 # The exit code to return on new versions found [default: 0]
    --features: string@cargo-features   # Space-separated list of features
    --format: string@outdated-format    # Output formatting [default: list]  [possible values: List, Json]
    --ignore(-i): string                # Dependencies to not print in the output (comma separated or one per '--ignore' argument)
    --ignore-external-rel(-e)           # Ignore relative dependencies external to workspace and check root dependencies
    --manifest-path(-m): path           # Path to the Cargo.toml file to use (Defaults to Cargo.toml in project root)
    --offline(-o)                       # Run without accessing the network (useful for testing w/ local registries)
    --packages(-p): string              # Packages to inspect for updates (comma separated or one per '--packages' argument)
    --quiet(-q)                         # Suppresses warnings
    --root(-r): string                  # Package to treat as the root package
    --root-deps-only(-R)                # Only check root dependencies (Equivalent to --depth=1)
    --version(-V)                       # Prints version information
    --verbose(-v)                       # Use verbose output
    --workspace(-w)                     # Checks updates for all workspace members rather than only the root package
    --help(-h)                          # Prints help information
]
