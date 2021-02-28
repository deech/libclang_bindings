import unittest

import libclang_bindings/raw/index
import libclang_bindings/porcelain
import bitops, options, os, system, tables


const SandboxIncludeFlags {.strdefine.} = ""
const SandboxLibDir {.strdefine.} = ""
when defined(sandboxStatic):
  if (not SandboxIncludeFlags.len == 0):
    {.passC: "-I" & SandboxIncludeFlags}
  if (not SandboxLibDir.len == 0):
    {.passL: "-L" & SandboxLibDir}
  when defined(macosx):
    {.passL: "-lclang_bundled -lstdc++ -lm -ldl -lpthread -lz".}
  else:
    {.passL: "-lclang_bundled -lstdc++ -lm -ldl -lpthread".}
elif defined(sandbox):
  if (not SandboxIncludeFlags.len == 0):
    {.passC: "-I" & SandboxIncludeFlags}
  if (not SandboxLibDir.len == 0):
    {.passL: "-L" & SandboxLibDir}
  when defined(macosx):
    {.passL: "-lclang -lz3 -lstdc++ -ldl -lpthread".}
  elif defined(linux):
    {.passL: "-lclang -lstdc++ -lm -ldl -lpthread -Wl,-rpath=" & SandboxLibDir.}
else:
  {.passL: "-lclang".}


test "can create index with some global options using raw calls":
  var ip = clang_createIndex(0,0)
  defer:
    clang_disposeIndex(ip)
  clang_CXIndex_setGlobalOptions(ip, bitor(ord(CXGlobalOpt_ThreadBackgroundPriorityForIndexing), ord(CXGlobalOpt_ThreadBackgroundPriorityForEditing)))
  check bitand((cuint)ord(CXGlobalOpt_ThreadBackgroundPriorityForEditing), clang_CXIndex_getGlobalOptions(ip)) == (cuint)ord(CXGlobalOpt_ThreadBackgroundPriorityForEditing)
  check clang_CXIndex_getGlobalOptions(ip) == (cuint)bitor(ord CXGlobalOpt_ThreadBackgroundPriorityForAll,
                                                           bitor(ord CXGlobalOpt_ThreadBackgroundPriorityForIndexing,
                                                                 ord CXGlobalOpt_ThreadBackgroundPriorityForEditing))

{.emit:""" /* INCLUDESECTION */
#include "clang-c/Index.h"
"""}

{.emit:"""
int majorVersion() { return CINDEX_VERSION_MAJOR; }
int minorVersion() { return CINDEX_VERSION_MINOR; }
"""}

test "check ABI version":
  proc majorVersion():cint {.importc.}
  proc minorVersion():cint {.importc.}
  check majorVersion() == 0
  check minorVersion() == 59

test "can create index with some global options using the nicer API":
  var ip = createIndex(false,false)
  ip.globalOpts = @[
    CXGlobalOpt_ThreadBackgroundPriorityForIndexing,
    CXGlobalOpt_ThreadBackgroundPriorityForEditing
  ]
  check ip.globalOpts.len == 3
  check CXGlobalOpt_ThreadBackgroundPriorityForIndexing in ip.globalOpts
  check CXGlobalOpt_ThreadBackgroundPriorityForEditing in ip.globalOpts
  # implied by the presense of the previous options
  check CXGlobalOpt_ThreadBackgroundPriorityForAll in ip.globalOpts

let enumHeader = absolutePath "tests/cpp/Enum.H"
test "can parse an enum":
  var idx = createIndex(false,false)
  let tu = parseTranslationUnit(
    i = idx,
    sourceFileName = some enumHeader,
    commandLineArguments = @[],
    options = @[CXTranslationUnit_None]
  )
  check (isSome tu)
  let cx = getCursor(tu.get)
  check (isSome cx)
  var enumTable = newTable[string,clonglong]()
  proc visitor(c:Cursor,_:Option[Cursor]) =
    if c.kind == CXCursor_EnumConstantDecl:
      enumTable.add(c.spelling, clang_getEnumConstantDeclValue(c.cxCursor))
  discard cx.get.visitChildren(visitor)
  let expected : type(enumTable) = {"RED": 10.clonglong, "GREEN": 40.clonglong, "BLUE": 50.clonglong}.newTable
  check expected == enumTable
