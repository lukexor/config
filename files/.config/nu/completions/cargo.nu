def "nu-comp cargo bins" [] {
  let $bins = (ls src | where name =~ bin | each { |f| ls -s $f.name } | flatten | where name =~ .rs || type == dir)
  if ($bins | length) > 0 {
    echo $bins | update name { |file| $file.name | str replace ".rs" "" } | get name
  }
}

def "nu-comp cargo examples" [] {
  let $examples = (ls | where name =~ examples | each { |f| ls -s $f.name } | flatten | where name =~ .rs || type == dir)
  if ($examples | length) > 0 {
    echo $examples | update name { |file| $file.name | str replace ".rs" "" } | get name
  }
}

def "nu-comp cargo profiles" [] {
  open Cargo.toml | get profile | transpose | get column0
}

def "nu-comp cargo features" [] {
  open Cargo.toml | get features | transpose | get column0
}

export extern "cargo run" [
  ...args: any                                   # arguments
  --bin: string@"nu-comp cargo bins"             # Name of the bin target to run
  --example: string@"nu-comp cargo examples"     # Name of the example target to run
  --quiet(-q)                                    # Do not print cargo log messages
  --package(-p): string                          # Package with the target to run
  --jobs(-j): number                             # Number of parallel jobs, defaults to # of CPUs
  --release                                      # Build artifacts in release mode, with optimizations
  --profile: string@"nu-comp cargo profiles"     # Build artifacts with the specified profile
  --features: string@"nu-comp cargo features"    # Space or comma separated list of features to activate
  --all-features                                 # Activate all available features
  --no-default-features                          # Do not activate the `default` feature
  --target: string                               # Build for the target triple
  --target-dir: path                             # Directory for all generated artifacts
  --manifest-path: path                          # Path to Cargo.toml
  --message-format: string                       # Error format
  --unit-graph                                   # Output build graph in JSON (unstable)
  --ignore-rust-version                          # Ignore `rust-version` specification in packages
  --verbose(-v)                                  # Use verbose output (-vv very verbose/build.rs output)
  --color: string                                # Coloring: auto, always, never
  --frozen                                       # Require Cargo.lock and cache are up to date
  --locked                                       # Require Cargo.lock is up to date
  --offline                                      # Run without accessing the network
  --config: string                               # Override a configuration value (unstable)
  -Z: string                                     # Unstable (nightly-only) flags to Cargo, see 'cargo -Z help' for details
  --help(-h)                                     # Prints help information
]
