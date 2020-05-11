import os, strformat
import libclang_nim_bundler/bundle

let staticTest = paramStr(3) == "static"
bundle.build()
for t in 4 .. paramCount():
  let test = paramStr(t)
  if staticTest:
    exec(fmt"nim c -d:sandboxStatic -d:sandboxIncludeFlags={bundle.includePath} -d:sandboxLibDir={bundle.libraryPath} {test}")
    when defined(macosx):
      bundle.macosLibZ3Adjustment test
  else:
    exec(fmt"nim c -d:sandbox -d:sandboxIncludeFlags={bundle.includePath} -d:sandboxLibDir={bundle.libraryPath} {test}")
  exec test
  rmFile test
