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
requires "harpoon"
requires "cligen"
requires "parsetoml"

# Tasks
task debug, "Development build":
    exec "nim c src/rplg.nim"

task release, "Release build":
    exec "nim -d:release c src/rplg.nim"