let
  rust_overlay = import (builtins.fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz");
  pkgs = import <nixpkgs> { overlays = [rust_overlay]; };
  rustVersion = "latest";
  rust = pkgs.rust-bin.selectLatestNightlyWith (toolchain: toolchain.default.override {
    extensions = [
      "rust-src" # for rust-analyzer
      "rust-analyzer"
    ];
    targets = [ "wasm32-unknown-unknown" ];
  });
in pkgs.mkShell {
  buildInputs = [
    rust
  ] ++ (with pkgs; [
    # Include any other packages
  ]);
  shellHook = ''
    exec fish
  '';
  RUST_BACKTRACE = 1;
}
