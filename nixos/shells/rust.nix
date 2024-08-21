with (import <nixpkgs> {
  overlays = [
    (import (fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz"))
  ];
}); mkShell {
  buildInputs = [
    # (rust-bin.stable.latest.default.override {
    #   extensions = [
    #     "rust-analyzer"
    #     "rust-src" # for rust-analyzer
    #   ];
    # })
    (rust-bin.selectLatestNightlyWith (toolchain: toolchain.default.override {
      extensions = [
        "rust-analyzer"
        "rust-src" # for rust-analyzer
      ];
      targets = ["wasm32-unknown-unknown"];
    }))
  ];
}
