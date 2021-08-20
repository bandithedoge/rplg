import json, repology, strformat, strutils

proc info(pkgName: seq[string]): int =
  for package in getApi("project", pkgName.join()):
    var repo, name: string

    repo = getStr(package["repo"])
    if package{"subrepo"} != nil:
      repo.add("/")
      repo.add(getStr(package["subrepo"]))

    if package{"srcname"} != nil:
      name = getStr(package["srcname"])
    else:
      name = getStr(package["name"])

    echo fmt"{repo}/{name}"

import cligen
dispatchMulti([info, help = { "pkgName": "Name of the package" }])