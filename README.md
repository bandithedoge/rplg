# rplg

CLI browser and package installer for Repology.

```
Usage:
  rplg {SUBCMD}  [sub-command options & parameters]
where {SUBCMD} is one of:
  help     print comprehensive or per-cmd help
  project  View information for project
  search   Search for a project
  install  Install a package

rplg {-h|--help} or with no args at all prints this message.
rplg --help-syntax gives general cligen syntax help.
Run "rplg {help SUBCMD|SUBCMD --help}" to see help for just SUBCMD.
Run "rplg help" to get *comprehensive* help.
```

# Installation

```sh
nimble install https://github.com/bandithedoge/rplg
```

```sh
# soon! :)
rplg install rplg
```

# Configuration

The configuration is a TOML file placed at `$XDG_CONFIG_HOME/rplg.toml` (usually `~/.config/rplg.toml`)
Here is an example configuration file showing rplg's features:

```toml
# Configure each package manager as an entry in the "repos" array.
# Repo names are the same as in Repology's API. They are shown in the output of "rplg project".
# For now the "install" command uses whatever is at the top of the configuration.
[[repos]]
# Repo names must be in an array, even when there is just one.
name = ["aur$", "arch", "artix"]
# No need to add a space after the command.
command = "paru -S"

[[repos]]
name = ["ubuntu_*"] # Yes, it supports regex patterns.
command = "apt install"
```

# Building

```sh
git clone https://github.com/bandithedoge/rplg
cd rplg

# development build
nimble build

# release build
nimble release
```

# TODO

- [x] Move API response handling to separate function
- [x] Install command
  - [ ] Repo picker
- [ ] Nicer output
    - [ ] Group by repo
    - [ ] Group versions