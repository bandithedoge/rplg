import puppy, json, strformat, strutils

type Status* = enum
  newest, devel, unique, outdated, legacy, rolling, noscheme, incorrect, untrusted, ignored, vulnerable

type Package* = object
  repo*: string
  subrepo*: string
  name*: string
  version*: string
  status*: Status

type Project* = object
  packages*: seq[Package]
  name*: string
  version*: string

const api = "https://repology.org/api/v1"
var apiString: string

proc getApi(arg1: string, arg2: string): JsonNode =
  apiString = &"{api}/{arg1}/{arg2}"
  return parseJson(fetch(apiString))

proc parseProject(arg: JsonNode): Project =
  var packageResponseFinal: Project

  for package in arg:
    var packageResponse: Package

    packageResponse.repo = getStr(package["repo"])
    packageResponse.version = getStr(package["version"])
    packageResponse.status = parseEnum[Status]getStr(package["status"])
    packageResponse.subrepo = getStr(package{"subrepo"})

    if package{"srcname"} != nil:
      packageResponse.name = getStr(package["srcname"])
    else:
      packageResponse.name = getStr(package["name"])

    case packageResponse.repo
    of "winget":
      packageResponse.name = replace(packageResponse.name, "/", ".")
    of "wikidata", "distrowatch":
      continue

    packageResponseFinal.packages.add(packageResponse)

  return packageResponseFinal

proc getProject*(arg: string): Project =
  var projectResponse: Project
  projectResponse = parseProject(getApi("project", arg))
  projectResponse.name = arg
  return projectResponse


proc getProjects*(arg: string): seq[Project] =
  var searchResponse: seq[Project]

  for result in keys(getApi("projects", &"?search={arg}")):
    searchResponse.add(getProject(result))

  return searchResponse