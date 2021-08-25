# Package
version       = "0.1.0"
author        = "bandithedoge"
description   = "CLI for browsing Repology"
license       = "GPLv3"
srcDir        = "src"
bin           = @["rplg"]
binDir        = "bin"

# Dependencies
requires "nim >= 1.4.8"
requires "puppy"
requires "cligen"
requires "parsetoml"
requires "climenu"

# Tasks
task build, "Development build":
    exec "nim -o:bin/rplg c src/rplg.nim"

task release, "Release build":
    exec "nim -o:bin/rplg -d:release c src/rplg.nim"