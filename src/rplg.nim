import json, repology, strformat, strutils

proc info(pkgList: seq[string]): int =
  for pkg in pkgList:
    # the api always returns an array of packages even when there's just one
    for package in getApi("project", pkg):
      var repo, name: string
      repo = getStr(package["repo"])

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

      echo fmt"{repo}/{name}"

import cligen
dispatchMulti([info, help = { "pkgList": "List of packages" }])