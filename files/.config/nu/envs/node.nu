let version = (if (ls -a |where name =~ nvmrc | length) > 0 { build-string "v" (cat .nvmrc) } { node -v })
load-env (venv (build-string $nu.env.HOME "/.nvm/versions/node/" $version))
