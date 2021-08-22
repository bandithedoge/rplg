import repology, strformat, strutils

proc project(pkgList: seq[string]): int =
  for pkg in pkgList:
    for project in getProject(pkg):
      echo fmt"{project.repo}/{project.name} ({project.version})"

import cligen
dispatchMulti([project, help = { "pkgList": "List of packages" }])