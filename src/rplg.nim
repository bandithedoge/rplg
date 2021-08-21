import json, repology, strformat, strutils

proc info(pkgList: seq[string]): int =
  for pkg in pkgList:
    # the api always returns an array of packages even when there's just one
    for package in getApi("project", pkg):
      var repo, name, version: string
      repo = getStr(package["repo"])
      version = getStr(package["version"])

      if package{"subrepo"} != nil:
        repo.add('/')
        repo.add(getStr(package["subrepo"]))

      if package{"srcname"} != nil:
        name = getStr(package["srcname"])
      else:
        name = getStr(package["name"])

      case repo
      of "winget":
        name = replace(name, "/", ".")
      of "wikidata":
        continue

      echo fmt"{repo}/{name} ({version})"

import cligen
dispatchMulti([info, help = { "pkgList": "List of packages" }])