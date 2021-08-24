import repology, strformat, strutils, terminal, os, osproc


proc project(pkgList: seq[string]): void =
  for pkg in pkgList:
    stdout.styledWrite(styleUnderscore, &"{pkg}:\n")
    for project in getProject(pkg).packages:
      stdout.write("\t")
      stdout.styledWrite(styleBright, project.repo)
      if project.subrepo != "":
        stdout.styledWrite(styleDim, &"/{project.subrepo}")
      stdout.write(&"/{project.name}")

      var versionColor: ForegroundColor = fgDefault
      var versionStyle: Style

      case project.status
      of newest:
        versionColor = fgGreen
      of devel:
        versionColor = fgCyan
      of unique:
        versionColor = fgBlue
      of outdated:
        versionColor = fgRed
      of legacy:
        versionColor = fgYellow
        versionStyle = styleBright
      of rolling:
        versionColor = fgWhite
        versionStyle = styleBright
      of noscheme:
        versionColor = fgMagenta
      of incorrect:
        versionColor = fgYellow
      of untrusted:
        versionStyle = styleDim
      of ignored:
        versionStyle = styleStrikethrough
      of vulnerable:
        versionColor = fgGreen
        versionStyle = styleBright

      stdout.styledWrite(versionStyle, versionColor, &" ({project.version})")
      if project.status == vulnerable:
        stdout.styledWrite(styleBright, fgRed, "!")
      stdout.write("\n")

proc search(pkgList: seq[string]): void =
  for pkg in pkgList:
    stdout.styledWrite(styleUnderscore, &"Search results for \"{pkg}\":\n")
    for project in getProjects(pkg):
      stdout.write("\t")
      stdout.styledWrite(styleBright, &"{project.name}: ")
      stdout.write(project.packages.len())
      stdout.write("\n")

import parsecfg

proc install(pkgList: seq[string]): void =
  let config = loadConfig(os.getConfigDir() & "rplg.ini")

  for pkg in pkgList:
    for package in getProject(pkg).packages:
      let command = config.getSectionValue("Repos", package.repo)
      if command != "":
        let errC = execCmd(command & package.name)
        break


import cligen
dispatchMulti([project, help = { "pkgList": "List of packages", }],
              [search],
              [install]
              )