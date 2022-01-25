let-env PATH = if (env | any? name == VENV_OLD_PATH) { $env.VENV_OLD_PATH } else { $env.PATH }
hide VIRTUAL_ENV
hide VENV_OLD_PATH
