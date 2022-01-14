let version = (if (ls -a |where name =~ nvmrc | length) > 0 { build-string "v" (cat .nvmrc | str trim) } { node -v | str trim})
load-env (venv (build-string $nu.env.HOME "/.nvm/versions/node/" $version))
