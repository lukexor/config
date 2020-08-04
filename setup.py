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
  'ctags',
  'dos2unix',
  'git',
  'hexedit',
  'mysql',
  'node',
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
  'yarn',
]
COMMANDS = [
  'vim +PlugUpgrade +PlugInstall +qall',
  'curl https://sh.rustup.rs -sSf | sh',
  'cargo install ripgrep',
  'cargo install cargo-add',
  'cargo install cargo-asm',
  'cargo install cargo-expand',
  'cargo install cargo-count',
  'cargo install cargo-fmt',
  'cargo install cargo-generate',
  'cargo install cargo-outdated',
  'cargo install cargo-readme',
  'cargo install cargo-tree',
  'cargo install cargo-watch',
  'cargo install wasm-pack',
  'rustup component add clippy-preview',
  'rustup component add rls-preview',
  'rustup component add rust-analysis',
  'rustup component add rust-src',
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

def sync(opts):
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
    shellResult = subprocess.call('brew update', shell=True)
    if shellResult:
        print("Error updating brew")

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

  sync(options)
  install(options)
  commands(options)

  print("Setup Complete")


if __name__ == "__main__":
  main(sys.argv[1:])
