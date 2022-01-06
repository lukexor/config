let-env PATH = ($nu.env | default VENV_OLD_PATH $nu.path | get VENV_OLD_PATH)
let-env VIRTUAL_ENV = $nothing
let-env VENV_OLD_PATH = $nothing
