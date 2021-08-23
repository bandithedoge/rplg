import repology, strformat, strutils, terminal

proc project(pkgList: seq[string]): void =
  for pkg in pkgList:
    stdout.styledWrite(styleUnderscore, &"{pkg}:")
    for project in getProject(pkg).packages:
      stdout.write("\n\t")
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

proc search(pkgList:seq[string]): void =
  for pkg in pkgList:
    stdout.styledWrite(styleUnderscore, &"Search results for \"{pkg}\":")
    for project in getProjects(pkg):
      stdout.write("\n\t")
      stdout.styledWrite(styleBright, &"{project.name}: ")
      stdout.write(project.packages.len())

import cligen
dispatchMulti([project, help = { "pkgList": "List of packages", }],
              [search]
              )