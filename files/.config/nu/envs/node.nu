let version = (if (ls -a | any? name == .nvmrc) { build-string "v" (cat .nvmrc | str trim) } { node -v | str trim})
load-env (venv ([$nu.home-dir .nvm/versions/node $version] | path join))
