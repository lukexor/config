let version = (if (ls -a |where name =~ jrc | length) > 0 { cat .jrc } { node -v })
let-env SPRING_PROFILES_ACTIVE = "local"
let-env JAVA_HOME = (/usr/libexec/java_home -v $version | str trim)
load-env (venv $nu.env.JAVA_HOME)
