let-env PATH = (if ($nu.env | get VENV_OLD_PATH) == "" { $nu.env.PATH } { $nu.env.VENV_OLD_PATH })
let-env VIRTUAL_ENV = ""
let-env VENV_OLD_PATH = ""
