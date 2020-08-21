#!/usr/bin/python

import platform, os, sys, getopt, subprocess

# Update these files as needed
DOTFILES = [
  'agignore',
  'bash_profile',
  'bashrc',
  'ctags',
  'editrc',
  'gitconfig',
  'gitignore',
  'inputrc',
  'jsbeautifyrc',
  'jshintrc',
  'perlcriticrc',
  'perltidyrc',
  'proverc',
  'rgignore',
  'tmux.conf',
  'uncrustify.cfg',
  'vim',
  'vimrc',
  'xinitrc',
]
LINKS = [
  'bin',
]
PACKAGES = [
  'ag',
  'bash',
  'cmake',
  'coreutils',
  'ctags',
  'dos2unix',
  'git',
  'hexedit',
  'mysql',
  'node',
  'nvm',
  'openssl',
  'postgresql',
  'python',
  'python3',
  'readline',
  'ruby',
  'sdl2',
  'sdl2_gfx',
  'sdl2_image',
  'sdl2_mixer',
  'sdl2_ttf',
  'the_silver_searcher',
  'sqlite',
  'tmux',
  'tree',
  'vim',
  'wget',
  'yarn',
]
COMMANDS = [
  'vim +PlugUpgrade +PlugInstall +qall',
  'curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path',
  '$HOME/.cargo/bin/cargo install ripgrep',
  '$HOME/.cargo/bin/cargo install cargo-add',
  '$HOME/.cargo/bin/cargo install cargo-asm',
  '$HOME/.cargo/bin/cargo install cargo-expand',
  '$HOME/.cargo/bin/cargo install cargo-count',
  '$HOME/.cargo/bin/cargo install cargo-fmt',
  '$HOME/.cargo/bin/cargo install cargo-generate',
  '$HOME/.cargo/bin/cargo install cargo-outdated',
  '$HOME/.cargo/bin/cargo install cargo-readme',
  '$HOME/.cargo/bin/cargo install cargo-tree',
  '$HOME/.cargo/bin/cargo install cargo-watch',
  '$HOME/.cargo/bin/cargo install wasm-pack',
  '$HOME/.cargo/bin/rustup component add clippy-preview',
  '$HOME/.cargo/bin/rustup component add rls-preview',
  '$HOME/.cargo/bin/rustup component add rust-analysis',
  '$HOME/.cargo/bin/rustup component add rust-src',
]


# Should not need to edit below this line
#----------------------------------------------

def usage():
  print """usage: setup.py [-h | --help] [-v | --verbose]
                [-d | --dryrun] [-f | --force]
                [-s | --sync] [-i | --install] [-c | --commands]
"""

def getOptions(argv):
  try:
    opts, args = getopt.getopt(argv, "hvdfsic",
        ["help", "verbose", "dryrun", "force", "sync", "install", "commands"])
  except getopt.GetoptError as err:
    print str(err)
    usage()
    sys.exit(2)

  options = {
    'verbose': False,
    'dryrun': False,
    'force': False,
    'sync': False,
    'install': False,
    'commands': False,
    'system': platform.system(),
    'HOME': os.environ.get('HOME'),
  }

  if options['system'] == 'Linux':
    dist = platform.dist()
    if dist[0].lower() == 'ubuntu':
      options['system'] = 'Debian'
    elif dist[0].lower() == 'centos':
      options['system'] = 'Redhat'

  for o, a in opts:
    if o in ("-v", "--verbose"): options['verbose'] = True
    elif o in ("-d", "--dryrun"): options['dryrun'] = True
    elif o in ("-f", "--force"): options['force'] = True
    elif o in ("-s", "--sync"): options['sync'] = True
    elif o in ("-i", "--install"): options['install'] = True
    elif o in ("-c", "--commands"): options['commands'] = True
    elif o in ("-h", "--help"):
      usage()
      sys.exit()
    else:
      assert False, "unhandled option"

  if (not options['sync']
      and not options['install']
      and not options['commands']):
    options['sync'] = True
    options['install'] = True
    options['commands'] = True

  return options

def rename(src, dst, opts):
  if opts['verbose']:
    print("Linking '%s' to '%s'" % (src, dst))
  if not opts['dryrun']:
    if os.path.exists(dst) or os.path.islink(dst):
      if opts['force']:
        if os.path.exists(dst) and not os.path.islink(dst):
          rename = "%s.old" % dst
          if opts.verbose:
            print("Renamed '%s' to '%s'" % (dst, rename))
          os.rename(dst, rename)
        else:
          os.unlink(dst)
      else:
        print("Skipping '%s' as it already exists. Use --force to link anyway" % dst)
        return
    os.symlink(src, dst)

def link(opts):
  if not opts['sync']: return
  rootPath = os.path.dirname(os.path.realpath(__file__))

  # Link dotfiles
  for f in DOTFILES:
    src = "%s/%s" % (rootPath, f)
    dst = "%s/.%s" % (opts['HOME'], f)
    rename(src, dst, opts)

  # Link regular files
  for f in LINKS:
    src = "%s/%s" % (rootPath, f)
    dst = "%s/%s" % (opts['HOME'], f)
    rename(src, dst, opts)

def install(opts):
  if not opts['install']: return

  if opts['system'] == 'Darwin':
    print("Installing xcode");
    shellResult = subprocess.call('xcode-select --install', shell=True)
    if shellResult:
      print("Error installing xcode or it's already installed")

    print("Checking homebrew installation")
    brewNotInstalled = subprocess.call('which brew', shell=True)
    if brewNotInstalled:
      print("Installing homebrew");
      shellResult = subprocess.call('/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"', shell=True)
      if shellResult:
          print("Error installing homebrew")
          return

    print("Updating homebrew installation")
    shellResult = subprocess.call('brew update', shell=True)
    if shellResult:
        print("Error updating homebrew")
        return

  for package in PACKAGES:
    if opts['verbose']:
      print("Installing '%s'" % package)

    shellResult = 0
    if opts['system'] == 'Darwin':
      shellResult = subprocess.call('brew ls --versions "%s" > /dev/null' % package, shell=True)
      if shellResult:
        shellResult = subprocess.call('HOMEBREW_NO_AUTO_UPDATE=1 brew install "%s"' % package, shell=True)
      else:
        shellResult = subprocess.call('HOMEBREW_NO_AUTO_UPDATE=1 brew upgrade "%s"' % package, shell=True)
    elif opts['system'] == 'Debian':
      shellResult - subprocess.call('sudo apt install -y "%s"' % package, shell=True)
    elif opts['system'] == 'Redhat':
      shellResult - subprocess.call('sudo yum install -y "%s"' % package, shell=True)
    if shellResult:
      print("Error installing '%s'" % package)

def commands(opts):
  if not opts['commands']: return

  # Run commands
  for c in COMMANDS:
    if opts['verbose']:
      print("Running '%s'" % c)
    result = subprocess.call(c, shell=True)
    if result:
      print("Error running '%s'" %c)


def main(argv):
  options = getOptions(argv)

  if options['HOME'] == None:
    print("$HOME must be defined to setup symlinks.")
    sys.exit(1)

  link(options)
  install(options)
  commands(options)

  print("Setup Complete")


if __name__ == "__main__":
  main(sys.argv[1:])
