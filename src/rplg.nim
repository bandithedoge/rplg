import repology, strformat, strutils, terminal, os, osproc, re, tables


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

import parsetoml

proc install(pkgList: seq[string]): void =
  let config = parseFile(os.getConfigDir() & "rplg.toml")
  for pkg in pkgList:
    var repoExists: bool

    var conf_repos = newOrderedTable[string, string]()
    for package in getProject(pkg).packages:
      for repo_conf in getElems(config["repos"]):
        for str in getElems(repo_conf["name"]):
          if match(package.repo, re(getStr(str))):
            conf_repos[package.repo] = getStr(repo_conf["command"])

      if conf_repos.hasKey(package.repo):
        stdout.styledWrite(&"Executing command \"{conf_repos[package.repo]} {package.name}\"\n")
        let cmd = execShellCmd(conf_repos[package.repo] & " " & package.name)
        if cmd == 0:
          stdout.styledWrite(fgGreen, &"Package \"{pkg}\" installed\n")
          repoExists = true
        else:
          stdout.styledWrite(fgRed, &"Package \"{pkg}\" not installed\n")
        break
      else:
        repoExists = false

    if repoExists == false:
      stdout.styledWrite(fgRed, &"No configured repository for package \"{pkg}\" found\n")

import cligen
const pkg_list_help = { "pkgList": "package" }.toTable()
dispatchMulti([project, help = pkg_list_help, doc = "View information for project"],
              [search, help = pkg_list_help, doc = "Search for a project"],
              [install, help = pkg_list_help, doc = "Install a package"]
              )