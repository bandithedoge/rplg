import puppy, json, strformat

const api = "https://repology.org/api/v1"
var apiString: string

proc getApi*(arg1: string, arg2: string): JsonNode =
  apiString = &"{api}/{arg1}/{arg2}"
  return parseJson(fetch(apiString))