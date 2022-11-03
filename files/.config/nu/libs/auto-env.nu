export-env {
    let-env VIRTUAL_ENV = ""
    let-env config = ($env.config | upsert hooks.env_change.PWD (build-hooks))
}

export def-env dotenv-on-enter [] {
  def-env parse-env [file: path] {
      if ($file | path exists) {
          open $file | lines | parse "{name}={value}" | transpose -i -r -d
      } else {
          {}
      }
  }

  load-env (parse-env .env)
  load-env (parse-env .env.local)
  load-env {
      VIRTUAL_ENV: $env.PWD
  }
}

def build-hooks [] {
    let on_enter = '
        let _env = $env
        overlay use dotenv
        cd ($_env.PWD)
        dotenv-on-enter
    '

    let on_exit = '
        overlay hide dotenv --keep-env [PWD] --keep-custom
    '

    let hooks = [
        { condition: {|_, after| entered-dotenv $after }
          code: $'($on_enter)' }
        { condition: {|_, after| swapped-dotenv $after }
          code: $'($on_exit)($on_enter)' }
        { condition: {|_, after| exited-dotenv $after }
          code: $'($on_exit)' }
    ]

    $hooks
}

def dotenv-active [] {
    "dotenv" in (overlay list)
}

def has-dotenv [] {
    let envs = (ls .* | where name =~ '\.env' | length)
    $envs > 0
}

def entered-dotenv [path: path] {
    (if not (has-dotenv) {
        false
    } else {
        not (dotenv-active)
    })
}

def swapped-dotenv [path: path] {
    (if (not (dotenv-active)) or (not (has-dotenv)) {
        false
    } else {
        $env.VIRTUAL_ENV != $path
    })
}

def exited-dotenv [path: path] {
    (if not (dotenv-active) {
        false
    } else {
        not (has-dotenv)
    })
}
