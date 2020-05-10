import raw/[index,cxstring,cxerrorcode]
import macros, sequtils, bitops, std/time_t, system, options, tables, sugar, sets, hashes

const allGlobalOptFlags* = @[
  CXGlobalOpt_None,
  CXGlobalOpt_ThreadBackgroundPriorityForIndexing,
  CXGlobalOpt_ThreadBackgroundPriorityForEditing,
  CXGlobalOpt_ThreadBackgroundPriorityForAll
]

const allCXDiagnosticDisplayOptions* = @[
  CXDiagnostic_DisplaySourceLocation,
  CXDiagnostic_DisplayColumn,
  CXDiagnostic_DisplaySourceRanges,
  CXDiagnostic_DisplayOption,
  CXDiagnostic_DisplayCategoryId,
  CXDiagnostic_DisplayCategoryName
]

const allCXTranslationUnit_Flags* = @([
  CXTranslationUnit_None,
  CXTranslationUnit_DetailedPreprocessingRecord,
  CXTranslationUnit_Incomplete,
  CXTranslationUnit_PrecompiledPreamble,
  CXTranslationUnit_CacheCompletionResults,
  CXTranslationUnit_ForSerialization,
  CXTranslationUnit_CXXChainedPCH,
  CXTranslationUnit_SkipFunctionBodies,
  CXTranslationUnit_IncludeBriefCommentsInCodeCompletion,
  CXTranslationUnit_CreatePreambleOnFirstParse,
  CXTranslationUnit_KeepGoing,
  CXTranslationUnit_SingleFileParse,
  CXTranslationUnit_LimitSkipFunctionBodiesToPreamble,
  CXTranslationUnit_IncludeAttributedTypes,
  CXTranslationUnit_VisitImplicitAttributes,
  CXTranslationUnit_IgnoreNonErrorsFromIncludedFiles,
])

type
  FileUniqueId* = object
    deviceId*: culonglong
    fileId*: culonglong
    modificationTime*: Time
  File* = object
    cxFile*:CXFile
    name*: string
    uniqueId*: Option[FileUniqueId]
    time*: Time
  TUResourceUsage* = object
    cxTUResourceUsage*:CXTUResourceUsage
    entries*: Table[CXTUResourceUsageKind,culonglong]
  TargetInfo* = object
    triple*: string
    pointerWidth*: cint
  TranslationUnit* = object
    cxTranslationUnit*: CXTranslationUnit
    resourceUsage*: TUResourceUsage
    targetInfo*: Option[TargetInfo]
    spelling*: string
  Index* = object
    cxIndex*: CXIndex
    tus*: seq[TranslationUnit]
  FileLocation* = object
    file*: File
    line*: Natural
    column*: Natural
    offset*: Natural
  SourceRangeList* = object
    cxSourceRangeList*: ptr CXSourceRangeList
    ranges*: seq[CXSourceRange]
  DiagnosticCategory* = object
    number*: cuint
    name*: string
    text*: string
  Diagnostic* = object
    severity*: CXDiagnosticSeverity
    location*: CXSourceLocation
    spelling*: string
    option*: (string,string)
    category*: DiagnosticCategory
    fixits*: seq[(string,CXSourceRange)]
    children*: Diagnostics
  Diagnostics* = object
    cxDiagnosticSet*:CXDiagnosticSet
    diagnostics*: seq[Diagnostic]
  PlatformAvailabilityAttribute* = object
    platform*:string
    introduced*:CXVersion
    deprecated*:CXVersion
    obsoleted*:CXVersion
    unavailable*:bool
    message*:string
  PlatformAvailability*  = object
    attributes*: seq[PlatformAvailabilityAttribute]
    alwaysUnavailable*: bool
    alwaysDeprecated*: bool
    unavailableMessage*: string
    deprecatedMessage*: string
  Type* = object
    cxType* : CXType
    spelling*: string
  Cursor* = object
    cxCursor*: CXCursor
    kind*: CXCursorKind
    kindSpelling*: string
    hash*: cuint
    lexicalParent*: Option[CXCursor]
    semanticParent*: Option[CXCursor]
    storageClass*: CXStorageClass
    tls*: CXTLSKind
    language*: CXLanguageKind
    platformAvailability*: Platformavailability
    availability*: CXAvailabilityKind
    visibility*: CXVisibilityKind
    linkage*: CXLinkageKind
    extent*: Option[CXSourceRange]
    location*: Option[CXSourceLocation]
    spelling*: string
    usr*: string
    cursorType*:Type

proc `=destroy`*(ds: var Diagnostics) =
  clang_disposeDiagnosticSet(ds.cxDiagnosticSet)
proc `=destroy`*(i:var Index) =
  ## clang_disposeIndex
  for t in i.tus:
    clang_disposeCXTUResourceUsage(t.resourceUsage.cxTUResourceUsage)
    clang_disposeTranslationUnit(t.cxTranslationUnit)
  clang_disposeIndex(i.cxIndex)
proc `=destroy`*(ranges: var SourceRangeList) =
  if  not (isNil (ranges.cxSourceRangeList)): clang_disposeSourceRangeList(ranges.cxSourceRangeList)
proc hash*(c:Cursor):Hash =
  c.hash.int
proc breakupFlags[T:enum](options:cuint,members:seq[T]):seq[T] =
  if options == 0:
    @[low(T)]
  else:
    members[1..^1].filterIt(bitand((cuint)it,options) == (cuint)it)

proc combineFlags[T:enum](options:seq[T]):cuint =
  for o in options:
    result = bitor(result,(cuint)ord(o))

proc toNimString*(cxString: CXString):string =
  result = $clang_getCString(cxString)
  clang_disposeString(cxString)

proc toNimStrings*(cxStringSet: ptr CXStringSet): seq[string] =
  if (isNil cxStringSet):
    result = @[]
  else:
    let cxStrings: seq[CXString] = toSeq(cxStringSet[].Strings.toOpenArray(0,cxStringSet[].Count-1))
    result = cxStrings.mapIt($ clang_getCString(it))
    clang_disposeStringSet cxStringSet

proc createIndex*(excludeDeclarationsFromPCH: bool, displayDiagnostics: bool): Index =
  ## clang_createIndex(
  Index(cxIndex:clang_createIndex(excludeDeclarationsFromPCH.ord.cint, displayDiagnostics.ord.cint))

proc `globalOpts=`*(i:Index,opts:seq[CXGlobalOptFlags]) =
  ## clang_CXIndex_setGlobalOptions
  clang_CXIndex_setGlobalOptions(i.cxIndex,combineFlags(opts))

proc globalOpts*(i:Index):seq[CXGlobalOptFlags] =
  ## clang_CXIndex_getGlobalOptions
  breakupFlags clang_CXIndex_getGlobalOptions(i.cxIndex),allGlobalOptFlags

proc isMultipleIncludeGuarded*(tu: TranslationUnit, file: File):bool =
  ## clang_isFileMultipleIncludeGuarded
  clang_isFileMultipleIncludeGuarded(tu.cxTranslationUnit,file.cxFile) == 0

proc uniqueId(f:CXFile): Option[FileUniqueId] =
  ## clang_getFileUniqueID
  var p : CXFileUniqueId
  let res = clang_getFileUniqueID(f,p)
  if res == 0:
    result = some(FileUniqueId(deviceId: (addr p)[0], fileId: (addr p)[1], modificationTime: (Time)((addr p)[2])))

proc name(f:CXFile):string =
  ## clang_getFileName
  ## clang_File_tryGetRealPathName
  result = clang_File_tryGetRealPathName(f).toNimString
  if result.len == 0:
    result = clang_getFileName(f).toNimString

proc time(f:CXFile):Time =
  ## clang_getFileTime
  clang_getFileTime(f)

proc fillOutFile(f:CXFile):File =
  File(
    cxFile:f,
    name: f.name(),
    time: f.time(),
    uniqueId: f.uniqueId()
  )

proc getFile*(tu: TranslationUnit, fileName: string): Option[File] =
  ## clang_getFile
  let res = clang_getFile(tu.cxTranslationUnit, $fileName)
  if (not (isNil cast[pointer](res))):
    result = some(fillOutFile(res))

proc nullLocation*():CXSourceLocation =
  clang_getNullLocation()

proc `==`*(s1:CXSourceLocation,s2:CXSourceLocation):bool =
  clang_equalLocations(s1,s2) != 0

proc `==`*(r1:CXSourceRange,r2:CXSourceRange):bool =
  clang_equalRanges(r1,r2) != 0

proc `==`*(c1:Cursor, c2:Cursor): bool =
  clang_equalCursors(c1.cxCursor, c2.cxCursor) != 0

proc getLocation*(tu:TranslationUnit, fl:FileLocation): CXSourceLocation =
  ## clang_getLocation
  clang_getLocation(tu.cxTranslationUnit,fl.file.cxFile,(cuint)fl.line,(cuint)fl.column)

proc getLocationForOffset*(tu: TranslationUnit, f: File, offset: Natural):CXSourceLocation =
  ## clang_getLocationForOffset
  clang_getLocationForOffset(tu.cxTranslationUnit,f.cxFile,(cuint)offset)

proc isInSystemHeader*(l:CXSourceLocation):bool =
  ## clang_Location_isInSystemHeader
  clang_Location_isInSystemHeader(l) != 0

proc isFromMainFile*(l: CXSourceLocation):bool =
  ## clang_Location_isFromMainFile
  clang_Location_isFromMainFile(l) != 0

proc isNull*(r:CXSourceRange):bool =
  clang_Range_isNull(r) != 0

proc isNull*(c:CXCursor): bool =
  clang_Cursor_isNull(c) != 0

proc isNull*(l:CXSourceLocation): bool =
  l == clang_getNullLocation()

template extractLocation(l:untyped, f:untyped): untyped  =
  var file : CXFile
  var line : cuint
  var column : cuint
  var offset : cuint
  f(l,file,line,column,offset)
  if not (isNil file):
    result = some(FileLocation(file: fillOutFile(file),
                               line: (Natural)line,
                               column: (Natural)column,
                               offset: (Natural)offset))

proc getExpansionLocation*(l:CXSourceLocation):Option[FileLocation] =
  extractLocation(l, clang_getExpansionLocation)
proc getInstantiationLocation*(l:CXSourceLocation):Option[FileLocation] =
  extractLocation(l, clang_getInstantiationLocation)
proc getSpellingLocation*(l:CXSourceLocation):Option[FileLocation] =
  extractLocation(l, clang_getSpellingLocation)
proc getFileLocation*(l:CXSourceLocation):Option[FileLocation] =
  extractLocation(l, clang_getFileLocation)
proc getRangeStart*(r:CXSourceRange):CXSourceLocation =
  clang_getRangeStart(r)
proc getRangeEnd*(r:CXSourceRange):CXSourceLocation =
  clang_getRangeEnd(r)

proc rangelistToSeq(p: ptr CXSourceRangeList):SourceRangeList =
  if not (isNil p):
    result = SourceRangeList(ranges: @(toOpenArray(p[].ranges,0,p[].count.int)), cxSourceRangeList: p)

proc getSkippedRanges*(tu:TranslationUnit, f:File):SourceRangeList =
  clang_getSkippedRanges(tu.cxTranslationUnit,f.cxFile).rangeListToSeq

proc getAllSkippedRanges*(tu:TranslationUnit):SourceRangeList =
  clang_getAllSkippedRanges(tu.cxTranslationUnit).rangeListToSeq

proc getDiagnosticsHelper[T:CXTranslationUnit|CXDiagnostic](diagnosticContainer: T):Diagnostics

proc fillOutDiagnostic(d:CXDiagnostic):Diagnostic =
  var fixits : seq[(string,CXSourceRange)]
  for f in 0..clang_getDiagnosticNumFixIts(d)-1:
    var srPtr : CXSourceRange
    let fixString = clang_getDiagnosticFixIt(d,(cuint)f,srPtr).toNimString
    fixits.add((fixString, srPtr))
  let dc =
    block:
      let dcnumber = clang_getDiagnosticCategory(d)
      DiagnosticCategory(
        number: dcnumber,
        name: clang_getDiagnosticCategoryName(dcnumber).toNimString,
        text: clang_getDiagnosticCategoryText(d).toNimString
      )
  var disableOptPtr : CXString
  let opt = clang_getDiagnosticOption(d,disableOptPtr)
  Diagnostic(
    severity: clang_getDiagnosticSeverity(d),
    location: clang_getDiagnosticLocation(d),
    option: (opt.toNimString, disableOptPtr.toNimString),
    category: dc,
    fixits: fixits,
    children: getDiagnosticsHelper(d)
  )

proc getDiagnosticsHelper[T:CXTranslationUnit|CXDiagnostic](diagnosticContainer: T):Diagnostics =
  when T is CXTranslationUnit:
    let ds = clang_getDiagnosticSetFromTU(diagnosticContainer)
  else:
    let ds = clang_getChildDiagnostics(diagnosticContainer)
  let count = clang_getNumDiagnosticsInSet(ds)
  result.cxDiagnosticSet = ds
  if count > 0.cuint:
    for i in 0.cuint ..< count:
      let d = clang_getDiagnosticInSet(ds,i)
      result.diagnostics.add(fillOutDiagnostic(d))

proc getDiagnostics*(tu:TranslationUnit):Diagnostics =
  getDiagnosticsHelper(tu.cxTranslationUnit)

proc getTUResourceUsage(tu : TranslationUnit):TUResourceUsage =
  var ru = clang_getCXTUResourceUsage(tu.cxTranslationUnit)
  let entries = @(toOpenArray(cast [ptr UncheckedArray[CXTUResourceUsageEntry]](ru.entries), 0, (int)ru.numEntries-1))
  var table : Table[CXTUResourceUsageKind, culonglong]
  for e in entries:
    table.add(e.kind,e.amount)
  result = TUResourceUsage(
    cxTUResourceUsage : ru,
    entries: table
  )

proc fillOutTranslationUnit(tu: var TranslationUnit) =
  tu.resourceUsage = getTUResourceUsage(tu)
  tu.spelling = clang_getTranslationUnitSpelling(tu.cxTranslationUnit).toNimString()
  tu.targetInfo =
      clang_getTranslationUnitTargetInfo(tu.cxTranslationUnit).option.map((ti: CXTargetInfo) => (
        defer: ti.clang_TargetInfo_dispose;
        result = TargetInfo(triple: clang_TargetInfo_getTriple(ti).toNimString,
                            pointerWidth: ti.clang_TargetInfo_getPointerWidth);))

proc createTranslationUnitFromSourceFile*(i: var Index, sourceFilename: Option[string], commandLineArguments:seq[string]): Option[TranslationUnit] =
  var cliPtr = cast[ptr cstring](allocCStringArray commandLineArguments)
  var sfPtr = sourceFilename.get("").cstring
  let tu = clang_createTranslationUnitFromSourceFile(i.cxIndex,sfPtr,(cint)commandLineArguments.len,cliPtr,(cuint)0,nil)
  if tu.pointer != nil:
    let res = TranslationUnit(cxTranslationUnit:tu)
    i.tus.add(res)
    result = some(res)

proc parseTranslationUnit*(i: var Index, sourceFilename: Option[string], commandLineArguments:seq[string], options:seq[CXTranslationUnit_Flags]): Option[TranslationUnit] =
  var cliPtr = allocCStringArray commandLineArguments
  var sfPtr = sourceFilename.get("").cstring
  var unsavedPtr : ptr CXUnsavedFile
  var tx : CXTranslationUnit
  let res : CXErrorCode = clang_parseTranslationUnit2(i.cxIndex,sfPtr,cliPtr,(cint)commandLineArguments.len,unsavedPtr,(cuint)0,combineFlags(options),tx)
  case res
  of CXError_Success:
    var tu = TranslationUnit(cxTranslationUnit:tx)
    fillOutTranslationUnit(tu)
    i.tus.add(tu)
    result = some(tu)
  else:
    result = none(TranslationUnit)

proc reparseTranslationUnit*(tu: TranslationUnit, options:seq[CXTranslationUnit_Flags]): TranslationUnit  =
  var newTu = tu
  let res = clang_reparseTranslationUnit(newTu.cxTranslationUnit,(cuint)0,nil,combineFlags(options))
  case res
  of CXError_Success: newTu.fillOutTranslationUnit
  else: raise newException(Defect, "Could not parse translation unit: " & $res)

proc toCXSome*(c: CXCursor): Option[CXCursor] =
  if not (isNull c): result = some c

proc toCXSome*(r: CXSourceRange): Option[CXSourceRange] =
  if not (isNull r): result = some r

proc toCXSome*(l: CXSourceLocation): Option[CXSourceLocation] =
  if not (isNull l): result = some l

proc fillOutPlatformAvailability*(c: CXCursor): PlatformAvailability =
  var always_unavailable : cint
  var always_deprecated : cint
  var unavailable_message : CXString
  var deprecated_message : CXString
  var availability : ptr UncheckedArray[CXPlatformAvailability]
  let size = clang_getCursorPlatformAvailability(
    c,always_deprecated,deprecated_message,always_unavailable,unavailable_message,availability,(cint)1
  )
  var attrs : seq[PlatformAvailabilityAttribute]
  for i in 0 ..< size:
    attrs.add PlatformAvailabilityAttribute(
      platform: availability[i].Platform.toNimString(),
      introduced: availability[i].Introduced,
      deprecated: availability[i].Deprecated,
      obsoleted: availability[i].Obsoleted,
      unavailable: availability[i].Unavailable != 0,
      message: availability[i].Message.toNimString(),
    )
  result = PlatformAvailability(
    attributes: attrs,
    alwaysUnavailable: always_unavailable != 0,
    alwaysDeprecated: always_deprecated != 0,
    unavailableMessage: unavailable_message.toNimString(),
    deprecatedMessage: deprecated_message.toNimString()
  )

proc fillOutCursor*(c : CXCursor): Option[Cursor] =
  if not (isNull c):
    let t = clang_getCursorType c
    let cursorType =  Type(
      cxType: t,
      spelling: (clang_getTypeSpelling t).toNimString
    )
    result  = some Cursor(
      cxCursor: c,
      kind: clang_getCursorKind c,
      kindSpelling: clang_getCursorKindSpelling(clang_getCursorKind c).toNimString,
      hash: clang_hashCursor c,
      lexicalParent : toCXSome(clang_getCursorLexicalParent c),
      semanticParent: toCXSome(clang_getCursorSemanticParent c),
      storageClass: clang_Cursor_getStorageClass c,
      tls: clang_getCursorTLSKind c,
      language: clang_getCursorLanguage c,
      platformAvailability: fillOutPlatformAvailability c,
      availability: clang_getCursorAvailability c,
      visibility: clang_getCursorVisibility c,
      linkage: clang_getCursorLinkage c,
      extent: toCXSome(clang_getCursorExtent c),
      location: toCXSome(clang_getCursorLocation c),
      spelling: clang_getCursorSpelling(c).toNimString,
      usr: (clang_getCursorUSR c).toNimString,
      cursorType: cursorType
    )

proc getCursor*(tu: TranslationUnit):Option[Cursor] =
  fillOutCursor clang_getTranslationUnitCursor(tu.cxTranslationUnit)
proc getCursor*(ctu: TranslationUnit, csl: CXSourceLocation): Option[Cursor] =
  fillOutCursor clang_getCursor(ctu.cxTranslationUnit,csl)
proc getCursorLocation*(c: Cursor): Option[CXSourceLocation] =
  toCXSome clang_getCursorLocation(c.cxCursor)
proc getOverriddenCursors*(c: Cursor):seq[Cursor] =
  var cursorPtrs : ptr UncheckedArray[CXCursor]
  var numCursors : cuint
  clang_getOverriddenCursors(c.cxCursor,cursorPtrs,numCursors)
  if numCursors != 0:
    for i in 0 ..< numCursors:
      let cursorO = fillOutCursor(cursorPtrs[i])
      if (isSome cursorO):
        result.add cursorO.get
proc visitChildren*(cursor:Cursor, f: proc (cursor:Cursor,parent:Option[Cursor])):bool =
  proc makeVisitor(cursor,parent:CXCursor):CXChildVisitResult =
    result = CXChildVisit_Recurse
    let curr: Option[Cursor] = fillOutCursor cursor
    let p: Option[Cursor] = fillOutCursor parent
    if isSome curr: f(curr.get, p)
  result = 0.cuint == clang_visitChildren(
    cursor.cxCursor,
    cast[CXCursorVisitor](rawProc makeVisitor),
    rawEnv makeVisitor
  )
proc enumConstant*(c:Cursor):clonglong =
  clang_getEnumConstantDeclValue(c.cxCursor)

proc parseFile*(file: string, visitor: proc (cursor:Cursor,parent:Option[Cursor]))  =
  var idx = createIndex(false,false)
  parseTranslationUnit(
    i = idx,
    sourceFileName = some file,
    commandLineArguments = @[],
    options = @[CXTranslationUnit_None]
  ).map((tu : TranslationUnit) => tu.getCursor.map((c: Cursor) => (discard c.visitChildren(visitor))))
