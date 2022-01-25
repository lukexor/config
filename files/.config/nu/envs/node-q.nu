let version = (if (ls -a | where name == .nvmrc | length) > 0 { build-string "v" (cat .nvmrc | str trim) } else { node -v | str trim})
load-env (venv ($nu.home-path | join path .nvm/versions/node | join path $version))
