import strformat, parseOpt,os,htmlparser,xmltree,sequtils,xmltree,strtabs,httpclient

proc linkscraper(url: string, search: string): string =
  var client = newHttpClient()
  let
    xmlNodes = client.getContent(url).parseHtml
    matches = xmlNodes.findAll("a").filterIt(it.innerText == search).mapIt(it.attrs["href"])
  if (matches.len == 0):
    ""
  else:
    matches[0]

proc main() =
  var file, search: string
  var p = initOptParser(os.commandLineParams())
  for kind, key, val in p.getOpt():
    case kind
    of cmdLongOption:
      case key
      of "file": file = val
      of "search": search = val
      else: discard
    else: discard
  let
    url = fmt "https://clang.llvm.org/doxygen/{file}_8h.html"
    link = linkscraper(url,search)
  echo fmt "https://clang.llvm.org/doxygen/{link}"

main()
