import puppy, json, strformat, strutils

type Project* = object
  repo*: string
  subrepo*: string
  name*: string
  version*: string
  status*: string

const api = "https://repology.org/api/v1"
var apiString: string

proc getApi(arg1: string, arg2: string): JsonNode =
  apiString = &"{api}/{arg1}/{arg2}"
  return parseJson(fetch(apiString))

proc getProject*(arg: string): seq[Project] =
  var packageResponseFinal: seq[Project]

  for package in getApi("project", arg):
    var packageResponse: Project

    packageResponse.repo= getStr(package["repo"])
    packageResponse.version = getStr(package["version"])
    packageResponse.status = getStr(package["status"])
    packageResponse.subrepo = getStr(package{"subrepo"})

    if package{"srcname"} != nil:
      packageResponse.name = getStr(package["srcname"])
    else:
      packageResponse.name = getStr(package["name"])

    case packageResponse.repo
    of "winget":
      packageResponse.name = replace(packageResponse.name, "/", ".")
    of "wikidata":
      continue

    packageResponseFinal.add(packageResponse)

  return packageResponseFinal