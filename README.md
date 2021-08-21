# rplg

Heavily WIP CLI browser for repology.org. Currently only outputs a list of repositories a package is present in.

```
Usage:
  rplg {SUBCMD}  [sub-command options & parameters]
where {SUBCMD} is one of:
  help  print comprehensive or per-cmd help
  info  

rplg {-h|--help} or with no args at all prints this message.
rplg --help-syntax gives general cligen syntax help.
Run "rplg {help SUBCMD|SUBCMD --help}" to see help for just SUBCMD.
Run "rplg help" to get *comprehensive* help.
```

# Installation

```sh
git clone https://github.com/bandithedoge/rplg
cd rplg
nimble install
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

- [ ] Move API response handling to separate function
- [ ] Install command
- [ ] Nicer output
    - [ ] Group by repo
    - [ ] Group versions