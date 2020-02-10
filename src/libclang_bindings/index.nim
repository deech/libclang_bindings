import dll
import std/time_t,bitops
from system import csize_t
import cxerrorcode
import cxstring

type
  CXUnsavedFile* {. final .} = object
    ## https://clang.llvm.org/doxygen/structCXUnsavedFile.html
    Filename*: cstring
    Contents*: cstring
    Length*: clong

{.push importc,header:"clang-c/Index.h"}
type
  CXIndex* = distinct pointer
    ## https://clang.llvm.org/doxygen/group__CINDEX.html#gae039c2574bfd75774ca7a9a3e55910cb
  CXTargetInfo* {.importc.} = ptr object
    ## https://clang.llvm.org/doxygen/group__CINDEX.html#ga6b47552ab8c5d81387070a9b197cd3e2
  CXTranslationUnit* = ptr object
    ## https://clang.llvm.org/doxygen/group__CINDEX.html#gacdb7815736ca709ce9a5e1ec2b7e16ac
  CXClientData* = distinct pointer
    ## https://clang.llvm.org/doxygen/group__CINDEX.html#gacfa40c3de26d228c0d898403c2c21612
  CXAvailabilityKind* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX.html#gada331ea0195e952c8f181ecf15e83d71
    CXAvailability_Available,
    CXAvailability_NotAvailable,
    CXAvailability_NotAccessible
  CXVersion* {.final, .} = object
    ## https://clang.llvm.org/doxygen/structCXVersion.html
    Major*: cint
    Minor*: cint
    Subminor*: cint
  CXCursor_ExceptionSpecificationKind* = enum
    ## https://clang.llvm.org/doxygen/structCXCursor.html
    CXCursor_ExceptionSpecificationKind_None,
    CXCursor_ExceptionSpecificationKind_DynamicNone,
    CXCursor_ExceptionSpecificationKind_Dynamic,
    CXCursor_ExceptionSpecificationKind_MSAny,
    CXCursor_ExceptionSpecificationKind_BasicNoexcept,
    CXCursor_ExceptionSpecificationKind_ComputedNoexcept,
    CXCursor_ExceptionSpecificationKind_Unevaluated,
    CXCursor_ExceptionSpecificationKind_Uninstantiated,
    CXCursor_ExceptionSpecificationKind_Unparsed,
  CXGlobalOptFlags* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX.html#ga1b451634928d6bcc961bf72a40e4d035
    CXGlobalOpt_None = 0x0,
    CXGlobalOpt_ThreadBackgroundPriorityForIndexing = 0x1,
    CXGlobalOpt_ThreadBackgroundPriorityForEditing = 0x2,
    CXGlobalOpt_ThreadBackgroundPriorityForAll = bitor(0x1,0x2)
      ## CXGlobalOpt_ThreadBackgroundPriorityForIndexing | CXGlobalOpt_ThreadBackgroundPriorityForEditing
  CXFile* = distinct pointer
    ## https://clang.llvm.org/doxygen/group__CINDEX__FILES.html#gacfcea9c1239c916597e2e5b3e109215a
  CXFileUniqueID* = array[3,culonglong]
    ## https://clang.llvm.org/doxygen/structCXFileUniqueID.html
  CXSourceLocation* {.final.} = object
    ## https://clang.llvm.org/doxygen/structCXSourceLocation.html
    ptr_data*: array[2,pointer]
    int_data*: cuint
  CXSourceRange* {.final.} = object
    ## https://clang.llvm.org/doxygen/structCXSourceRange.html
    ptr_data*: array[2,pointer]
    begin_int_data*: cuint
    end_int_data*: cuint
  CXSourceRangeList* {.final.} = object
    ## https://clang.llvm.org/doxygen/structCXSourceRangeList.html
    ranges*: ptr CXSourceRange
    count*: cuint
  CXDiagnosticSeverity* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX__DIAG.html#gabff210a02d448bf64e8aee79b2241370
    CXDiagnostic_Ignored = 0,
    CXDiagnostic_Note    = 1,
    CXDiagnostic_Warning = 2,
    CXDiagnostic_Error   = 3,
    CXDiagnostic_Fatal   = 4
  CXDiagnostic* {.final.} = distinct pointer
    ## https://clang.llvm.org/doxygen/group__CINDEX__DIAG.html#ga44bb8aba7c40590ad25d1763c4fbff7f
  CXDiagnosticSet* {.final.} = distinct pointer
    ## https://clang.llvm.org/doxygen/group__CINDEX__DIAG.html#ga38dfc0ae45b55bf7fd577eed9148e244
  CXLoadDiag_Error* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX__DIAG.html#gafccf4d49329805ac24e6dc005aafc848
    CXLoadDiag_None = 0,
    CXLoadDiag_Unknown = 1,
    CXLoadDiag_CannotLoad = 2,
    CXLoadDiag_InvalidFile = 3
  CXDiagnosticDisplayOptions* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX__DIAG.html#ga0545c7c3ef36a397c44d142b0385b8d1
    CXDiagnostic_DisplaySourceLocation = 0x01,
    CXDiagnostic_DisplayColumn = 0x02,
    CXDiagnostic_DisplaySourceRanges = 0x04,
    CXDiagnostic_DisplayOption = 0x08,
    CXDiagnostic_DisplayCategoryId = 0x10,
    CXDiagnostic_DisplayCategoryName = 0x20
  CXTranslationUnit_Flags* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX__TRANSLATION__UNIT.html#gab1e4965c1ebe8e41d71e90203a723fe9
    CXTranslationUnit_None = 0x0,
    CXTranslationUnit_DetailedPreprocessingRecord = 0x01,
    CXTranslationUnit_Incomplete = 0x02,
    CXTranslationUnit_PrecompiledPreamble = 0x04,
    CXTranslationUnit_CacheCompletionResults = 0x08,
    CXTranslationUnit_ForSerialization = 0x10,
    CXTranslationUnit_CXXChainedPCH = 0x20,
    CXTranslationUnit_SkipFunctionBodies = 0x40,
    CXTranslationUnit_IncludeBriefCommentsInCodeCompletion = 0x80,
    CXTranslationUnit_CreatePreambleOnFirstParse = 0x100,
    CXTranslationUnit_KeepGoing = 0x200,
    CXTranslationUnit_SingleFileParse = 0x400,
    CXTranslationUnit_LimitSkipFunctionBodiesToPreamble = 0x800,
    CXTranslationUnit_IncludeAttributedTypes = 0x1000,
    CXTranslationUnit_VisitImplicitAttributes = 0x2000,
    CXTranslationUnit_IgnoreNonErrorsFromIncludedFiles = 0x4000
  CXSaveTranslationUnit_Flags* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX__TRANSLATION__UNIT.html#ga4c8b0a3c559d14f80f78aba8c185e711
    CXSaveTranslationUnit_None = 0x0
  CXSaveError* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX__TRANSLATION__UNIT.html#ga7016a2cf0a256f239a8887d1251d5c23
    CXSaveError_None = 0,
    CXSaveError_Unknown = 1,
    CXSaveError_TranslationErrors = 2,
    CXSaveError_InvalidTU = 3
  CXReparse_Flags* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX__TRANSLATION__UNIT.html#gabbc92e66e3a3b22de7ead07cf01678b9
    CXReparse_None = 0x0
  CXTUResourceUsageKind* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX__TRANSLATION__UNIT.html#ga13810240df7c205de04daac58f956396
    CXTUResourceUsage_AST = 1,
    CXTUResourceUsage_Identifiers = 2,
    CXTUResourceUsage_Selectors = 3,
    CXTUResourceUsage_GlobalCompletionResults = 4,
    CXTUResourceUsage_SourceManagerContentCache = 5,
    CXTUResourceUsage_AST_SideTables = 6,
    CXTUResourceUsage_SourceManager_Membuffer_Malloc = 7,
    CXTUResourceUsage_SourceManager_Membuffer_MMap = 8,
    CXTUResourceUsage_ExternalASTSource_Membuffer_Malloc = 9,
    CXTUResourceUsage_ExternalASTSource_Membuffer_MMap = 10,
    CXTUResourceUsage_Preprocessor = 11,
    CXTUResourceUsage_PreprocessingRecord = 12,
    CXTUResourceUsage_SourceManager_DataStructures = 13,
    CXTUResourceUsage_Preprocessor_HeaderSearch = 14,
  CXTUResourceUsageEntry* {.final.} = object
    ## https://clang.llvm.org/doxygen/structCXTUResourceUsageEntry.html
    kind*: CXTUResourceUsageKind
    amount*: culong
  CXTUResourceUsage* {.final, importc, header: "clang-c/Index.h".} = object
    ## https://clang.llvm.org/doxygen/structCXTUResourceUsage.html
    data*: pointer
    numEntries*:cuint
    entries*: ptr CXTUResourceUsageEntry
  CXCursorKind* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX.html#gaaccc432245b4cd9f2d470913f9ef0013
    CXCursor_UnexposedDecl                 = 1,
    CXCursor_StructDecl                    = 2,
    CXCursor_UnionDecl                     = 3,
    CXCursor_ClassDecl                     = 4,
    CXCursor_EnumDecl                      = 5,
    CXCursor_FieldDecl                     = 6,
    CXCursor_EnumConstantDecl              = 7,
    CXCursor_FunctionDecl                  = 8,
    CXCursor_VarDecl                       = 9,
    CXCursor_ParmDecl                      = 10,
    CXCursor_ObjCInterfaceDecl             = 11,
    CXCursor_ObjCCategoryDecl              = 12,
    CXCursor_ObjCProtocolDecl              = 13,
    CXCursor_ObjCPropertyDecl              = 14,
    CXCursor_ObjCIvarDecl                  = 15,
    CXCursor_ObjCInstanceMethodDecl        = 16,
    CXCursor_ObjCClassMethodDecl           = 17,
    CXCursor_ObjCImplementationDecl        = 18,
    CXCursor_ObjCCategoryImplDecl          = 19,
    CXCursor_TypedefDecl                   = 20,
    CXCursor_CXXMethod                     = 21,
    CXCursor_Namespace                     = 22,
    CXCursor_LinkageSpec                   = 23,
    CXCursor_Constructor                   = 24,
    CXCursor_Destructor                    = 25,
    CXCursor_ConversionFunction            = 26,
    CXCursor_TemplateTypeParameter         = 27,
    CXCursor_NonTypeTemplateParameter      = 28,
    CXCursor_TemplateTemplateParameter     = 29,
    CXCursor_FunctionTemplate              = 30,
    CXCursor_ClassTemplate                 = 31,
    CXCursor_ClassTemplatePartialSpecialization = 32,
    CXCursor_NamespaceAlias                = 33,
    CXCursor_UsingDirective                = 34,
    CXCursor_UsingDeclaration              = 35,
    CXCursor_TypeAliasDecl                 = 36,
    CXCursor_ObjCSynthesizeDecl            = 37,
    CXCursor_ObjCDynamicDecl               = 38,
    CXCursor_CXXAccessSpecifier            = 39,
    CXCursor_FirstRef                      = 40,
    CXCursor_ObjCProtocolRef               = 41,
    CXCursor_ObjCClassRef                  = 42,
    CXCursor_TypeRef                       = 43,
    CXCursor_CXXBaseSpecifier              = 44,
    CXCursor_TemplateRef                   = 45,
    CXCursor_NamespaceRef                  = 46,
    CXCursor_MemberRef                     = 47,
    CXCursor_LabelRef                      = 48,
    CXCursor_OverloadedDeclRef             = 49,
    CXCursor_VariableRef                   = 50,
    CXCursor_FirstInvalid                  = 70,
    CXCursor_NoDeclFound                   = 71,
    CXCursor_NotImplemented                = 72,
    CXCursor_InvalidCode                   = 73,
    CXCursor_FirstExpr                     = 100,
    CXCursor_DeclRefExpr                   = 101,
    CXCursor_MemberRefExpr                 = 102,
    CXCursor_CallExpr                      = 103,
    CXCursor_ObjCMessageExpr               = 104,
    CXCursor_BlockExpr                     = 105,
    CXCursor_IntegerLiteral                = 106,
    CXCursor_FloatingLiteral               = 107,
    CXCursor_ImaginaryLiteral              = 108,
    CXCursor_StringLiteral                 = 109,
    CXCursor_CharacterLiteral              = 110,
    CXCursor_ParenExpr                     = 111,
    CXCursor_UnaryOperator                 = 112,
    CXCursor_ArraySubscriptExpr            = 113,
    CXCursor_BinaryOperator                = 114,
    CXCursor_CompoundAssignOperator        = 115,
    CXCursor_ConditionalOperator           = 116,
    CXCursor_CStyleCastExpr                = 117,
    CXCursor_CompoundLiteralExpr           = 118,
    CXCursor_InitListExpr                  = 119,
    CXCursor_AddrLabelExpr                 = 120,
    CXCursor_StmtExpr                      = 121,
    CXCursor_GenericSelectionExpr          = 122,
    CXCursor_GNUNullExpr                   = 123,
    CXCursor_CXXStaticCastExpr             = 124,
    CXCursor_CXXDynamicCastExpr            = 125,
    CXCursor_CXXReinterpretCastExpr        = 126,
    CXCursor_CXXConstCastExpr              = 127,
    CXCursor_CXXFunctionalCastExpr         = 128,
    CXCursor_CXXTypeidExpr                 = 129,
    CXCursor_CXXBoolLiteralExpr            = 130,
    CXCursor_CXXNullPtrLiteralExpr         = 131,
    CXCursor_CXXThisExpr                   = 132,
    CXCursor_CXXThrowExpr                  = 133,
    CXCursor_CXXNewExpr                    = 134,
    CXCursor_CXXDeleteExpr                 = 135,
    CXCursor_UnaryExpr                     = 136,
    CXCursor_ObjCStringLiteral             = 137,
    CXCursor_ObjCEncodeExpr                = 138,
    CXCursor_ObjCSelectorExpr              = 139,
    CXCursor_ObjCProtocolExpr              = 140,
    CXCursor_ObjCBridgedCastExpr           = 141,
    CXCursor_PackExpansionExpr             = 142,
    CXCursor_SizeOfPackExpr                = 143,
    CXCursor_LambdaExpr                    = 144,
    CXCursor_ObjCBoolLiteralExpr           = 145,
    CXCursor_ObjCSelfExpr                  = 146,
    CXCursor_OMPArraySectionExpr           = 147,
    CXCursor_ObjCAvailabilityCheckExpr     = 148,
    CXCursor_FixedPointLiteral             = 149,
    CXCursor_FirstStmt                     = 200,
    CXCursor_LabelStmt                     = 201,
    CXCursor_CompoundStmt                  = 202,
    CXCursor_CaseStmt                      = 203,
    CXCursor_DefaultStmt                   = 204,
    CXCursor_IfStmt                        = 205,
    CXCursor_SwitchStmt                    = 206,
    CXCursor_WhileStmt                     = 207,
    CXCursor_DoStmt                        = 208,
    CXCursor_ForStmt                       = 209,
    CXCursor_GotoStmt                      = 210,
    CXCursor_IndirectGotoStmt              = 211,
    CXCursor_ContinueStmt                  = 212,
    CXCursor_BreakStmt                     = 213,
    CXCursor_ReturnStmt                    = 214,
    CXCursor_GCCAsmStmt                    = 215,
    CXCursor_ObjCAtTryStmt                 = 216,
    CXCursor_ObjCAtCatchStmt               = 217,
    CXCursor_ObjCAtFinallyStmt             = 218,
    CXCursor_ObjCAtThrowStmt               = 219,
    CXCursor_ObjCAtSynchronizedStmt        = 220,
    CXCursor_ObjCAutoreleasePoolStmt       = 221,
    CXCursor_ObjCForCollectionStmt         = 222,
    CXCursor_CXXCatchStmt                  = 223,
    CXCursor_CXXTryStmt                    = 224,
    CXCursor_CXXForRangeStmt               = 225,
    CXCursor_SEHTryStmt                    = 226,
    CXCursor_SEHExceptStmt                 = 227,
    CXCursor_SEHFinallyStmt                = 228,
    CXCursor_MSAsmStmt                     = 229,
    CXCursor_NullStmt                      = 230,
    CXCursor_DeclStmt                      = 231,
    CXCursor_OMPParallelDirective          = 232,
    CXCursor_OMPSimdDirective              = 233,
    CXCursor_OMPForDirective               = 234,
    CXCursor_OMPSectionsDirective          = 235,
    CXCursor_OMPSectionDirective           = 236,
    CXCursor_OMPSingleDirective            = 237,
    CXCursor_OMPParallelForDirective       = 238,
    CXCursor_OMPParallelSectionsDirective  = 239,
    CXCursor_OMPTaskDirective              = 240,
    CXCursor_OMPMasterDirective            = 241,
    CXCursor_OMPCriticalDirective          = 242,
    CXCursor_OMPTaskyieldDirective         = 243,
    CXCursor_OMPBarrierDirective           = 244,
    CXCursor_OMPTaskwaitDirective          = 245,
    CXCursor_OMPFlushDirective             = 246,
    CXCursor_SEHLeaveStmt                  = 247,
    CXCursor_OMPOrderedDirective           = 248,
    CXCursor_OMPAtomicDirective            = 249,
    CXCursor_OMPForSimdDirective           = 250,
    CXCursor_OMPParallelForSimdDirective   = 251,
    CXCursor_OMPTargetDirective            = 252,
    CXCursor_OMPTeamsDirective             = 253,
    CXCursor_OMPTaskgroupDirective         = 254,
    CXCursor_OMPCancellationPointDirective = 255,
    CXCursor_OMPCancelDirective            = 256,
    CXCursor_OMPTargetDataDirective        = 257,
    CXCursor_OMPTaskLoopDirective          = 258,
    CXCursor_OMPTaskLoopSimdDirective      = 259,
    CXCursor_OMPDistributeDirective        = 260,
    CXCursor_OMPTargetEnterDataDirective   = 261,
    CXCursor_OMPTargetExitDataDirective    = 262,
    CXCursor_OMPTargetParallelDirective    = 263,
    CXCursor_OMPTargetParallelForDirective = 264,
    CXCursor_OMPTargetUpdateDirective      = 265,
    CXCursor_OMPDistributeParallelForDirective = 266,
    CXCursor_OMPDistributeParallelForSimdDirective = 267,
    CXCursor_OMPDistributeSimdDirective = 268,
    CXCursor_OMPTargetParallelForSimdDirective = 269,
    CXCursor_OMPTargetSimdDirective = 270,
    CXCursor_OMPTeamsDistributeDirective = 271,
    CXCursor_OMPTeamsDistributeSimdDirective = 272,
    CXCursor_OMPTeamsDistributeParallelForSimdDirective = 273,
    CXCursor_OMPTeamsDistributeParallelForDirective = 274,
    CXCursor_OMPTargetTeamsDirective = 275,
    CXCursor_OMPTargetTeamsDistributeDirective = 276,
    CXCursor_OMPTargetTeamsDistributeParallelForDirective = 277,
    CXCursor_OMPTargetTeamsDistributeParallelForSimdDirective = 278,
    CXCursor_OMPTargetTeamsDistributeSimdDirective = 279,
    CXCursor_BuiltinBitCastExpr = 280,
    CXCursor_TranslationUnit               = 300,
    CXCursor_FirstAttr                     = 400,
    CXCursor_IBActionAttr                  = 401,
    CXCursor_IBOutletAttr                  = 402,
    CXCursor_IBOutletCollectionAttr        = 403,
    CXCursor_CXXFinalAttr                  = 404,
    CXCursor_CXXOverrideAttr               = 405,
    CXCursor_AnnotateAttr                  = 406,
    CXCursor_AsmLabelAttr                  = 407,
    CXCursor_PackedAttr                    = 408,
    CXCursor_PureAttr                      = 409,
    CXCursor_ConstAttr                     = 410,
    CXCursor_NoDuplicateAttr               = 411,
    CXCursor_CUDAConstantAttr              = 412,
    CXCursor_CUDADeviceAttr                = 413,
    CXCursor_CUDAGlobalAttr                = 414,
    CXCursor_CUDAHostAttr                  = 415,
    CXCursor_CUDASharedAttr                = 416,
    CXCursor_VisibilityAttr                = 417,
    CXCursor_DLLExport                     = 418,
    CXCursor_DLLImport                     = 419,
    CXCursor_NSReturnsRetained             = 420,
    CXCursor_NSReturnsNotRetained          = 421,
    CXCursor_NSReturnsAutoreleased         = 422,
    CXCursor_NSConsumesSelf                = 423,
    CXCursor_NSConsumed                    = 424,
    CXCursor_ObjCException                 = 425,
    CXCursor_ObjCNSObject                  = 426,
    CXCursor_ObjCIndependentClass          = 427,
    CXCursor_ObjCPreciseLifetime           = 428,
    CXCursor_ObjCReturnsInnerPointer       = 429,
    CXCursor_ObjCRequiresSuper             = 430,
    CXCursor_ObjCRootClass                 = 431,
    CXCursor_ObjCSubclassingRestricted     = 432,
    CXCursor_ObjCExplicitProtocolImpl      = 433,
    CXCursor_ObjCDesignatedInitializer     = 434,
    CXCursor_ObjCRuntimeVisible            = 435,
    CXCursor_ObjCBoxable                   = 436,
    CXCursor_FlagEnum                      = 437,
    CXCursor_ConvergentAttr                = 438,
    CXCursor_WarnUnusedAttr                = 439,
    CXCursor_WarnUnusedResultAttr          = 440,
    CXCursor_AlignedAttr                   = 441,
    CXCursor_PreprocessingDirective        = 500,
    CXCursor_MacroDefinition               = 501,
    CXCursor_MacroExpansion                = 502,
    CXCursor_InclusionDirective            = 503,
    CXCursor_ModuleImportDecl              = 600,
    CXCursor_TypeAliasTemplateDecl         = 601,
    CXCursor_StaticAssert                  = 602,
    CXCursor_FriendDecl                    = 603,
    CXCursor_OverloadCandidate             = 700
  CXCursor* {.final.} = object
    ## https://clang.llvm.org/doxygen/structCXCursor.html
    kind*: CXCursorKind
    xdata*: cint
    data*: array[3,pointer]
  CXLinkageKind* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__MANIP.html#gace57c68a7a11b0967b184a7ef9fbeb9e
    CXLinkage_Invalid,
    CXLinkage_NoLinkage,
    CXLinkage_Internal,
    CXLinkage_UniqueExternal,
    CXLinkage_External
  CXVisibilityKind* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__MANIP.html#gaf92fafb489ab66529aceab51818994cb
    CXVisibility_Invalid,
    CXVisibility_Hidden,
    CXVisibility_Protected,
    CXVisibility_Default
  CXPlatformAvailability* {.final.} = object
    ## https://clang.llvm.org/doxygen/structCXPlatformAvailability.html
    Platform*:CXString
    Introduced*:CXVersion
    Deprecated*:CXVersion
    Obsoleted*:CXVersion
    Unavailable*:cint
    Message*:CXString
  CXLanguageKind* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__MANIP.html#ga3abfddcec8a46e7156f37de661af3c14
    CXLanguage_Invalid = 0,
    CXLanguage_C,
    CXLanguage_ObjC,
    CXLanguage_CPlusPlus
  CXTLSKind = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__MANIP.html#ga4e9aabb46d683642ef49f542be4f1257
    CXTLS_None = 0,
    CXTLS_Dynamic,
    CXTLS_Static
  CXCursorSet* = distinct pointer
    ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__MANIP.html#gacca741976831fc313f80970cbf88307d
  CXTypeKind* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#gaad39de597b13a18882c21860f92b095a
    CXType_Invalid = 0,
    CXType_Unexposed = 1,
    CXType_Void = 2,
    CXType_Bool = 3,
    CXType_Char_U = 4,
    CXType_UChar = 5,
    CXType_Char16 = 6,
    CXType_Char32 = 7,
    CXType_UShort = 8,
    CXType_UInt = 9,
    CXType_ULong = 10,
    CXType_ULongLong = 11,
    CXType_UInt128 = 12,
    CXType_Char_S = 13,
    CXType_SChar = 14,
    CXType_WChar = 15,
    CXType_Short = 16,
    CXType_Int = 17,
    CXType_Long = 18,
    CXType_LongLong = 19,
    CXType_Int128 = 20,
    CXType_Float = 21,
    CXType_Double = 22,
    CXType_LongDouble = 23,
    CXType_NullPtr = 24,
    CXType_Overload = 25,
    CXType_Dependent = 26,
    CXType_ObjCId = 27,
    CXType_ObjCClass = 28,
    CXType_ObjCSel = 29,
    CXType_Float128 = 30,
    CXType_Half = 31,
    CXType_Float16 = 32,
    CXType_ShortAccum = 33,
    CXType_Accum = 34,
    CXType_LongAccum = 35,
    CXType_UShortAccum = 36,
    CXType_UAccum = 37,
    CXType_ULongAccum = 38,
    CXType_Complex = 100,
    CXType_Pointer = 101,
    CXType_BlockPointer = 102,
    CXType_LValueReference = 103,
    CXType_RValueReference = 104,
    CXType_Record = 105,
    CXType_Enum = 106,
    CXType_Typedef = 107,
    CXType_ObjCInterface = 108,
    CXType_ObjCObjectPointer = 109,
    CXType_FunctionNoProto = 110,
    CXType_FunctionProto = 111,
    CXType_ConstantArray = 112,
    CXType_Vector = 113,
    CXType_IncompleteArray = 114,
    CXType_VariableArray = 115,
    CXType_DependentSizedArray = 116,
    CXType_MemberPointer = 117,
    CXType_Auto = 118,
    CXType_Elaborated = 119,
    CXType_Pipe = 120,
    CXType_OCLImage1dRO = 121,
    CXType_OCLImage1dArrayRO = 122,
    CXType_OCLImage1dBufferRO = 123,
    CXType_OCLImage2dRO = 124,
    CXType_OCLImage2dArrayRO = 125,
    CXType_OCLImage2dDepthRO = 126,
    CXType_OCLImage2dArrayDepthRO = 127,
    CXType_OCLImage2dMSAARO = 128,
    CXType_OCLImage2dArrayMSAARO = 129,
    CXType_OCLImage2dMSAADepthRO = 130,
    CXType_OCLImage2dArrayMSAADepthRO = 131,
    CXType_OCLImage3dRO = 132,
    CXType_OCLImage1dWO = 133,
    CXType_OCLImage1dArrayWO = 134,
    CXType_OCLImage1dBufferWO = 135,
    CXType_OCLImage2dWO = 136,
    CXType_OCLImage2dArrayWO = 137,
    CXType_OCLImage2dDepthWO = 138,
    CXType_OCLImage2dArrayDepthWO = 139,
    CXType_OCLImage2dMSAAWO = 140,
    CXType_OCLImage2dArrayMSAAWO = 141,
    CXType_OCLImage2dMSAADepthWO = 142,
    CXType_OCLImage2dArrayMSAADepthWO = 143,
    CXType_OCLImage3dWO = 144,
    CXType_OCLImage1dRW = 145,
    CXType_OCLImage1dArrayRW = 146,
    CXType_OCLImage1dBufferRW = 147,
    CXType_OCLImage2dRW = 148,
    CXType_OCLImage2dArrayRW = 149,
    CXType_OCLImage2dDepthRW = 150,
    CXType_OCLImage2dArrayDepthRW = 151,
    CXType_OCLImage2dMSAARW = 152,
    CXType_OCLImage2dArrayMSAARW = 153,
    CXType_OCLImage2dMSAADepthRW = 154,
    CXType_OCLImage2dArrayMSAADepthRW = 155,
    CXType_OCLImage3dRW = 156,
    CXType_OCLSampler = 157,
    CXType_OCLEvent = 158,
    CXType_OCLQueue = 159,
    CXType_OCLReserveID = 160,
    CXType_ObjCObject = 161,
    CXType_ObjCTypeParam = 162,
    CXType_Attributed = 163,
    CXType_OCLIntelSubgroupAVCMcePayload = 164,
    CXType_OCLIntelSubgroupAVCImePayload = 165,
    CXType_OCLIntelSubgroupAVCRefPayload = 166,
    CXType_OCLIntelSubgroupAVCSicPayload = 167,
    CXType_OCLIntelSubgroupAVCMceResult = 168,
    CXType_OCLIntelSubgroupAVCImeResult = 169,
    CXType_OCLIntelSubgroupAVCRefResult = 170,
    CXType_OCLIntelSubgroupAVCSicResult = 171,
    CXType_OCLIntelSubgroupAVCImeResultSingleRefStreamout = 172,
    CXType_OCLIntelSubgroupAVCImeResultDualRefStreamout = 173,
    CXType_OCLIntelSubgroupAVCImeSingleRefStreamin = 174,
    CXType_OCLIntelSubgroupAVCImeDualRefStreamin = 175,
    CXType_ExtVector = 176
  CXCallingConv* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga4a0e941ec7b4b64bf9eb3d0ed49d55ae
    CXCallingConv_Default = 0,
    CXCallingConv_C = 1,
    CXCallingConv_X86StdCall = 2,
    CXCallingConv_X86FastCall = 3,
    CXCallingConv_X86ThisCall = 4,
    CXCallingConv_X86Pascal = 5,
    CXCallingConv_AAPCS = 6,
    CXCallingConv_AAPCS_VFP = 7,
    CXCallingConv_X86RegCall = 8,
    CXCallingConv_IntelOclBicc = 9,
    CXCallingConv_Win64 = 10,
    CXCallingConv_X86_64SysV = 11,
    CXCallingConv_X86VectorCall = 12,
    CXCallingConv_Swift = 13,
    CXCallingConv_PreserveMost = 14,
    CXCallingConv_PreserveAll = 15,
    CXCallingConv_AArch64VectorCall = 16,
    CXCallingConv_Invalid = 100,
    CXCallingConv_Unexposed = 200
  CXType* {.final.} = object
    ## https://clang.llvm.org/doxygen/structCXType.html
    kind*: CXTypeKind
    data*: array[2,pointer]
  CXTemplateArgumentKind* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#gaf23c39e68c1fc756643583b43ee3e494
    CXTemplateArgumentKind_Null,
    CXTemplateArgumentKind_Type,
    CXTemplateArgumentKind_Declaration,
    CXTemplateArgumentKind_NullPtr,
    CXTemplateArgumentKind_Integral,
    CXTemplateArgumentKind_Template,
    CXTemplateArgumentKind_TemplateExpansion,
    CXTemplateArgumentKind_Expression,
    CXTemplateArgumentKind_Pack,
    CXTemplateArgumentKind_Invalid
  CXTypeNullabilityKind* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga21d6eaa7515baf48f49f71a2a8e06a4b
    CXTypeNullability_NonNull = 0,
    CXTypeNullability_Nullable = 1,
    CXTypeNullability_Unspecified = 2,
    CXTypeNullability_Invalid = 3
  CXTypeLayoutError* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#gaaf1b95e9e7e792a08654563fef7502c1
    CXTypeLayoutError_Undeduced = -6,
    CXTypeLayoutError_InvalidFieldName = -5,
    CXTypeLayoutError_NotConstantSize = -4,
    CXTypeLayoutError_Dependent = -3,
    CXTypeLayoutError_Incomplete = -2,
    CXTypeLayoutError_Invalid = -1
  CXRefQualifierKind* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga28389bbe03a77eded92086f0011d86eb
    CXRefQualifier_None = 0,
    CXRefQualifier_LValue,
    CXRefQualifier_RValue
  CX_CXXAccessSpecifier* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga26763f9b0b167116c047e2ef4f221c5f
    CX_CXXInvalidAccessSpecifier,
    CX_CXXPublic,
    CX_CXXProtected,
    CX_CXXPrivate
  CX_StorageClass* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga03a15eaa53465d7f3ce7d88743241d7e
    CX_SC_Invalid,
    CX_SC_None,
    CX_SC_Extern,
    CX_SC_Static,
    CX_SC_PrivateExtern,
    CX_SC_OpenCLWorkGroupLocal,
    CX_SC_Auto,
    CX_SC_Register
  CXChildVisitResult* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__TRAVERSAL.html#ga99a9058656e696b622fbefaf5207d715
    CXChildVisit_Break,
    CXChildVisit_Continue,
    CXChildVisit_Recurse
  CXCursorVisitor* = proc (cursor: CXCursor,parent:CXCursor,client_data:CXClientData):CXChildVisitResult
  CXPrintingPolicy* = distinct pointer
  CXPrintingPolicyProperty* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__XREF.html#gad5e7ef491a343f4cd8d8d7088c2c32ce
    CXPrintingPolicy_Indentation,
    CXPrintingPolicy_SuppressSpecifiers,
    CXPrintingPolicy_SuppressTagKeyword,
    CXPrintingPolicy_IncludeTagDefinition,
    CXPrintingPolicy_SuppressScope,
    CXPrintingPolicy_SuppressUnwrittenScope,
    CXPrintingPolicy_SuppressInitializers,
    CXPrintingPolicy_ConstantArraySizeAsWritten,
    CXPrintingPolicy_AnonymousTagLocations,
    CXPrintingPolicy_SuppressStrongLifetime,
    CXPrintingPolicy_SuppressLifetimeQualifiers,
    CXPrintingPolicy_SuppressTemplateArgsInCXXConstructors,
    CXPrintingPolicy_Bool,
    CXPrintingPolicy_Restrict,
    CXPrintingPolicy_Alignof,
    CXPrintingPolicy_UnderscoreAlignof,
    CXPrintingPolicy_UseVoidForZeroParams,
    CXPrintingPolicy_TerseOutput,
    CXPrintingPolicy_PolishForDeclaration,
    CXPrintingPolicy_Half,
    CXPrintingPolicy_MSWChar,
    CXPrintingPolicy_IncludeNewlines,
    CXPrintingPolicy_MSVCFormatting,
    CXPrintingPolicy_ConstantsAsWritten,
    CXPrintingPolicy_SuppressImplicitBase,
    CXPrintingPolicy_FullyQualifiedName,
  CXObjCPropertyAttrKind* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__XREF.html#ga7bb83a8c353185d13641f001a4c4b6c7
    CXObjCPropertyAttr_noattr    = 0x00,
    CXObjCPropertyAttr_readonly  = 0x01,
    CXObjCPropertyAttr_getter    = 0x02,
    CXObjCPropertyAttr_assign    = 0x04,
    CXObjCPropertyAttr_readwrite = 0x08,
    CXObjCPropertyAttr_retain    = 0x10,
    CXObjCPropertyAttr_copy      = 0x20,
    CXObjCPropertyAttr_nonatomic = 0x40,
    CXObjCPropertyAttr_setter    = 0x80,
    CXObjCPropertyAttr_atomic    = 0x100,
    CXObjCPropertyAttr_weak      = 0x200,
    CXObjCPropertyAttr_strong    = 0x400,
    CXObjCPropertyAttr_unsafe_unretained = 0x800,
    CXObjCPropertyAttr_class = 0x1000
  CXObjCDeclQualifierKind* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__XREF.html#ga1267244d5761be84f8680e455199bac2
    CXObjCDeclQualifier_None = 0x0,
    CXObjCDeclQualifier_In = 0x1,
    CXObjCDeclQualifier_Inout = 0x2,
    CXObjCDeclQualifier_Out = 0x4,
    CXObjCDeclQualifier_Bycopy = 0x8,
    CXObjCDeclQualifier_Byref = 0x10,
    CXObjCDeclQualifier_Oneway = 0x20
  CXModule* = distinct pointer
    ## https://clang.llvm.org/doxygen/group__CINDEX__MODULE.html#ga8b7b9a4a5faa82fdf95aebdfebc5859c
  CXNameRefFlags* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX__CPP.html#gab9c36c971a7241dccf6a54741b66a5ee
    CXNameRange_WantQualifier = 0x1,
    CXNameRange_WantTemplateArgs = 0x2,
    CXNameRange_WantSinglePiece = 0x4
  CXTokenKind* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX__LEX.html#gaf63e37eee4280e2c039829af24bbc201
    CXToken_Punctuation,
    CXToken_Keyword,
    CXToken_Identifier,
    CXToken_Literal,
    CXToken_Comment
  CXToken* {.final.} = object
    ## https://clang.llvm.org/doxygen/structCXToken.html
    int_data*: array[4,cuint]
    ptr_data*: pointer
  CXCompletionString* = distinct pointer
    ## https://clang.llvm.org/doxygen/group__CINDEX__CODE__COMPLET.html#gafea23a43a60ec3b4f3bedccfbb76883a
  CXCompletionResult* {.final.}= object
    ## https://clang.llvm.org/doxygen/structCXCompletionResult.html
    CursorKind*:CXCursorKind
    CompletionString*:CXCompletionString
  CXCompletionChunkKind* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX__CODE__COMPLET.html#ga82570056548565efdd6fc74e57e75bbd
    CXCompletionChunk_Optional,
    CXCompletionChunk_TypedText,
    CXCompletionChunk_Text,
    CXCompletionChunk_Placeholder,
    CXCompletionChunk_Informative,
    CXCompletionChunk_CurrentParameter,
    CXCompletionChunk_LeftParen,
    CXCompletionChunk_RightParen,
    CXCompletionChunk_LeftBracket,
    CXCompletionChunk_RightBracket,
    CXCompletionChunk_LeftBrace,
    CXCompletionChunk_RightBrace,
    CXCompletionChunk_LeftAngle,
    CXCompletionChunk_RightAngle,
    CXCompletionChunk_Comma,
    CXCompletionChunk_ResultType,
    CXCompletionChunk_Colon,
    CXCompletionChunk_SemiColon,
    CXCompletionChunk_Equal,
    CXCompletionChunk_HorizontalSpace,
    CXCompletionChunk_VerticalSpace
  CXCodeCompleteResults* {.final.} = object
    ## https://clang.llvm.org/doxygen/structCXCodeCompleteResults.html
    Results*: ptr CXCompletionResult
    NumResults*: cuint
  CXCodeComplete_Flags* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX__CODE__COMPLET.html#gaaad70639b9973354626101151db4154b
    CXCodeComplete_IncludeMacros = 0x01,
    CXCodeComplete_IncludeCodePatterns = 0x02,
    CXCodeComplete_IncludeBriefComments = 0x04,
    CXCodeComplete_SkipPreamble = 0x08,
    CXCodeComplete_IncludeCompletionsWithFixIts = 0x10
  CXCompletionContext* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX__CODE__COMPLET.html#ga547e210f2ea6fc1fb4263b0d4d7e8102
    CXCompletionContext_Unexposed = 0,
    CXCompletionContext_AnyType = rotateLeftBits((uint32)1,0),
    CXCompletionContext_AnyValue = rotateLeftBits((uint32)1,1),
    CXCompletionContext_ObjCObjectValue = rotateLeftBits((uint32)1,2),
    CXCompletionContext_ObjCSelectorValue = rotateLeftBits((uint32)1,3),
    CXCompletionContext_CXXClassTypeValue = rotateLeftBits((uint32)1,4),
    CXCompletionContext_DotMemberAccess = rotateLeftBits((uint32)1,5),
    CXCompletionContext_ArrowMemberAccess = rotateLeftBits((uint32)1,6),
    CXCompletionContext_ObjCPropertyAccess = rotateLeftBits((uint32)1,7),
    CXCompletionContext_EnumTag = rotateLeftBits((uint32)1,8),
    CXCompletionContext_UnionTag = rotateLeftBits((uint32)1,9),
    CXCompletionContext_StructTag = rotateLeftBits((uint32)1,10),
    CXCompletionContext_ClassTag = rotateLeftBits((uint32)1,11),
    CXCompletionContext_Namespace = rotateLeftBits((uint32)1,12),
    CXCompletionContext_NestedNameSpecifier = rotateLeftBits((uint32)1,13),
    CXCompletionContext_ObjCInterface = rotateLeftBits((uint32)1,14),
    CXCompletionContext_ObjCProtocol = rotateLeftBits((uint32)1,15),
    CXCompletionContext_ObjCCategory = rotateLeftBits((uint32)1,16),
    CXCompletionContext_ObjCInstanceMessage = rotateLeftBits((uint32)1,17),
    CXCompletionContext_ObjCClassMessage = rotateLeftBits((uint32)1,18),
    CXCompletionContext_ObjCSelectorName = rotateLeftBits((uint32)1,19),
    CXCompletionContext_MacroName = rotateLeftBits((uint32)1,20),
    CXCompletionContext_NaturalLanguage = rotateLeftBits((uint32)1,21),
    CXCompletionContext_IncludedFile = rotateLeftBits((uint32)1,22),
    CXCompletionContext_Unknown = rotateLeftBits((uint32)1,23) - 1
  CXInclusionVisitor* = proc (included_file:CXFile, inclusion_stack:ptr CXSourceLocation, include_len:cuint, client_data:CXClientData)
    ## https://clang.llvm.org/doxygen/group__CINDEX__MISC.html#ga075c50e5cf912f15d902cff864ea7d13
  CXEvalResultKind* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX__MISC.html#ga71ffcbb614704d05b059e7edce9465fe
    CXEval_UnExposed = 0,
    CXEval_Int = 1 ,
    CXEval_Float = 2,
    CXEval_ObjCStrLiteral = 3,
    CXEval_StrLiteral = 4,
    CXEval_CFStr = 5,
    CXEval_Other = 6
  CXEvalResult* = distinct pointer
    ## https://clang.llvm.org/doxygen/group__CINDEX__MISC.html#gaa9270afc68877e1f3b20ce5b343191bc
  CXRemapping* = distinct pointer
    ## https://clang.llvm.org/doxygen/group__CINDEX__REMAPPING.html#ga04be0aca9e36a130cf1dd6fd8cbd4408
  CXVisitorResult* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX__HIGH.html#ga4b763faa98fe78195c06f74745a1e6b4
    CXVisit_Break,
    CXVisit_Continue
  CXCursorAndRangeVisitor* {.final.} = object
    ## https://clang.llvm.org/doxygen/structCXCursorAndRangeVisitor.html
    context*: pointer
    visit*: proc(context:pointer, cursor:CXCursor,sourceRange:CXSourceRange):CXVisitorResult
  CXResult* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX__HIGH.html#ga59185777d9788da5d983cc0c7c8977bf
    CXResult_Success = 0,
    CXResult_Invalid = 1,
    CXResult_VisitBreak = 2
  CXIdxClientFile* = distinct pointer
    ## https://clang.llvm.org/doxygen/group__CINDEX__HIGH.html#ga6fd9c59c0b0a0a21622e5bcfc08156cc
  CXIdxClientEntity* = distinct pointer
    ## https://clang.llvm.org/doxygen/group__CINDEX__HIGH.html#gaaa7374e63b63b3d14af7cf87af386955
  CXIdxClientContainer* = distinct pointer
    ## https://clang.llvm.org/doxygen/group__CINDEX__HIGH.html#ga0dac2cb977094bbd9d13b9d8abed278f
  CXIdxClientASTFile* = distinct pointer
    ## https://clang.llvm.org/doxygen/group__CINDEX__HIGH.html#ga802a69b3db636a25c5d434585fce9cbd
  CXIdxLoc* {.final.} = object
    ## https://clang.llvm.org/doxygen/structCXIdxLoc.html
    ptr_data*: array[2,pointer]
    int_data*:cuint
  CXIdxIncludedFileInfo* {.final.} = object
    ## https://clang.llvm.org/doxygen/structCXIdxIncludedFileInfo.html
    hashLoc*:CXIdxLoc
    filename*: cstring
    file*:CXFile
    isImport*:cint
    isAngled*:cint
    isModuleImport*:cint
  CXIdxImportedASTFileInfo* {.final.} = object
    file*:CXFile
    module*:CXModule
    loc*:CXIdxLoc
    isImplicit*:cint
  CXIdxEntityKind* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX__HIGH.html#gaeabdc51cf762443531dfdd92b0e15b04
    CXIdxEntity_Unexposed     = 0,
    CXIdxEntity_Typedef       = 1,
    CXIdxEntity_Function      = 2,
    CXIdxEntity_Variable      = 3,
    CXIdxEntity_Field         = 4,
    CXIdxEntity_EnumConstant  = 5,
    CXIdxEntity_ObjCClass     = 6,
    CXIdxEntity_ObjCProtocol  = 7,
    CXIdxEntity_ObjCCategory  = 8,
    CXIdxEntity_ObjCInstanceMethod = 9,
    CXIdxEntity_ObjCClassMethod    = 10,
    CXIdxEntity_ObjCProperty  = 11,
    CXIdxEntity_ObjCIvar      = 12,
    CXIdxEntity_Enum          = 13,
    CXIdxEntity_Struct        = 14,
    CXIdxEntity_Union         = 15,
    CXIdxEntity_CXXClass              = 16,
    CXIdxEntity_CXXNamespace          = 17,
    CXIdxEntity_CXXNamespaceAlias     = 18,
    CXIdxEntity_CXXStaticVariable     = 19,
    CXIdxEntity_CXXStaticMethod       = 20,
    CXIdxEntity_CXXInstanceMethod     = 21,
    CXIdxEntity_CXXConstructor        = 22,
    CXIdxEntity_CXXDestructor         = 23,
    CXIdxEntity_CXXConversionFunction = 24,
    CXIdxEntity_CXXTypeAlias          = 25,
    CXIdxEntity_CXXInterface          = 26
  CXIdxEntityLanguage* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX__HIGH.html#ga586068b110ab11094f40eff0b92fc578
    CXIdxEntityLang_None = 0,
    CXIdxEntityLang_C    = 1,
    CXIdxEntityLang_ObjC = 2,
    CXIdxEntityLang_CXX  = 3,
    CXIdxEntityLang_Swift  = 4
  CXIdxEntityCXXTemplateKind* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX__HIGH.html#gaffb304a99b36f147738b3349e7aa22cb
    CXIdxEntity_NonTemplate   = 0,
    CXIdxEntity_Template      = 1,
    CXIdxEntity_TemplatePartialSpecialization = 2,
    CXIdxEntity_TemplateSpecialization = 3
  CXIdxAttrKind* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX__HIGH.html#gacafef874c0a53de1d38805ec7ca9790a
    CXIdxAttr_Unexposed     = 0,
    CXIdxAttr_IBAction      = 1,
    CXIdxAttr_IBOutlet      = 2,
    CXIdxAttr_IBOutletCollection = 3
  CXIdxAttrInfo* {.final.} = object
    ## https://clang.llvm.org/doxygen/structCXIdxAttrInfo.html
    kind*:CXIdxAttrKind
    cursor*:CXCursor
    loc*:CXIdxLoc
  CXIdxEntityInfo* {.final.} = object
    ## https://clang.llvm.org/doxygen/structCXIdxEntityInfo.html
    kind*:CXIdxEntityKind
    templateKind*:CXIdxEntityCXXTemplateKind
    lang*:CXIdxEntityLanguage
    name*:cstring
    USR*:cstring
    cursor*:CXCursor
    attributes*: ptr ptr CXIdxAttrInfo
    numAttributes*:cuint
  CXIdxContainerInfo* {.final.} = object
    ## https://clang.llvm.org/doxygen/structCXIdxContainerInfo.html
    cursor*:CXCursor
  CXIdxIBOutletCollectionAttrInfo* {.final.} = object
    ## https://clang.llvm.org/doxygen/structCXIdxIBOutletCollectionAttrInfo.html
    attrInfo*: ptr CXIdxAttrInfo
    objClass*: ptr CXIdxEntityInfo
    classCursor*:CXCursor
    classLoc*:CXIdxLoc
  CXIdxDeclInfoFlags* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX__HIGH.html#gac2ab581a399019383ada51a95ad4661c
    CXIdxDeclFlag_Skipped = 0x1
  CXIdxDeclInfo* {.final.} = object
    ## https://clang.llvm.org/doxygen/structCXIdxDeclInfo.html
    entityInfo*: ptr CXIdxEntityInfo
    cursor*:CXCursor
    loc*:CXIdxLoc
    semanticContainer*: ptr CXIdxContainerInfo
    lexicalContainer*: ptr CXIdxContainerInfo
    isRedeclaration*:cint
    isDefinition*:cint
    isContainer*:cint
    declAsContainer*: ptr CXIdxContainerInfo
    isImplicit*:cint
    attributes*: ptr ptr CXIdxAttrInfo
    numAttributes*:cuint
    flags*:cuint
  CXIdxObjCContainerKind* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX__HIGH.html#ga3a7b134403ae721de4bb61dbaa35ece0
    CXIdxObjCContainer_ForwardRef = 0,
    CXIdxObjCContainer_Interface = 1,
    CXIdxObjCContainer_Implementation = 2
  CXIdxObjCContainerDeclInfo* {.final.} = object
    ## https://clang.llvm.org/doxygen/structCXIdxObjCContainerDeclInfo.html
    declInfo*: ptr CXIdxDeclInfo
    kind*:CXIdxObjCContainerKind
  CXIdxBaseClassInfo* {.final.} = object
    ## https://clang.llvm.org/doxygen/structCXIdxBaseClassInfo.html
    base*: ptr CXIdxEntityInfo
    cursor*:CXCursor
    loc*:CXIdxLoc
  CXIdxObjCProtocolRefInfo* {.final.} = object
    ## https://clang.llvm.org/doxygen/structCXIdxObjCProtocolRefInfo.html
    protocol*: ptr CXIdxEntityInfo
    cursor*:CXCursor
    loc*:CXIdxLoc
  CXIdxObjCProtocolRefListInfo* {.final.} = object
    ## https://clang.llvm.org/doxygen/structCXIdxObjCProtocolRefListInfo.html
    protocols*: ptr ptr CXIdxObjCProtocolRefInfo
    numProtocols*:cuint
  CXIdxObjCInterfaceDeclInfo* {.final.} = object
    ## https://clang.llvm.org/doxygen/structCXIdxObjCInterfaceDeclInfo.html
    containerInfo*: ptr CXIdxObjCContainerDeclInfo
    superInfo*: ptr CXIdxBaseClassInfo
    protocols*: ptr CXIdxObjCProtocolRefListInfo
  CXIdxObjCCategoryDeclInfo* {.final.} = object
    ## https://clang.llvm.org/doxygen/structCXIdxObjCCategoryDeclInfo.html
    containerInfo*: ptr CXIdxObjCContainerDeclInfo
    objcClass*: ptr CXIdxEntityInfo
    classCursor*:CXCursor
    classLoc*:CXIdxLoc
  CXIdxObjCPropertyDeclInfo* {.final.} = object
    ## https://clang.llvm.org/doxygen/structCXIdxObjCPropertyDeclInfo.html
    declInfo*: ptr CXIdxDeclInfo
    getter*: ptr CXIdxEntityInfo
    setter*: ptr CXIdxEntityInfo
  CXIdxCXXClassDeclInfo* {.final.} = object
    ## https://clang.llvm.org/doxygen/structCXIdxCXXClassDeclInfo.html
    declInfo*: ptr CXIdxDeclInfo
    bases*: ptr ptr CXIdxBaseClassInfo
    numBases*:cuint
  CXIdxEntityRefKind* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX__HIGH.html#ga4158d96205b540d3ef4992cf6689c2aa
    CXIdxEntityRef_Direct = 1,
    CXIdxEntityRef_Implicit = 2
  CXSymbolRole* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX__HIGH.html#ga93461522b51d72d128adfa094a102b50
    CXSymbolRole_None = 0,
    CXSymbolRole_Declaration = rotateLeftBits((uint32)1,0),
    CXSymbolRole_Definition = rotateLeftBits((uint32)1,1),
    CXSymbolRole_Reference = rotateLeftBits((uint32)1,2),
    CXSymbolRole_Read = rotateLeftBits((uint32)1,3),
    CXSymbolRole_Write = rotateLeftBits((uint32)1,4),
    CXSymbolRole_Call = rotateLeftBits((uint32)1,5),
    CXSymbolRole_Dynamic = rotateLeftBits((uint32)1,6),
    CXSymbolRole_AddressOf = rotateLeftBits((uint32)1,7),
    CXSymbolRole_Implicit = rotateLeftBits((uint32)1,8)
  CXIdxEntityRefInfo* {.final.} = object
    ## https://clang.llvm.org/doxygen/structCXIdxEntityRefInfo.html
    kind*:CXIdxEntityRefKind
    cursor*:CXCursor
    loc*:CXIdxLoc
    referencedEntity*: ptr CXIdxEntityInfo
    parentEntity*: ptr CXIdxEntityInfo
    container*: ptr CXIdxContainerInfo
    role*:CXSymbolRole
  IndexerCallbacks* {.final.} = object
    ## https://clang.llvm.org/doxygen/structIndexerCallbacks.html
    abortQuery*: proc (client_data:CXClientData, reserved: pointer):cint
    diagnostic*: proc (client_data:CXClientData, diagnosticSet:CXDiagnosticSet, reserved:pointer)
    enteredMainFile*: proc (client_data:CXClientData, mainFile:CXFile, reserved:pointer):CXIdxClientFile
    ppIncludedFile*: proc (client_data:CXClientData, fileInfo: ptr CXIdxIncludedFileInfo):CXIdxClientFile
    importedASTFile*: proc (client_data:CXClientData, astFileInfo: ptr CXIdxImportedASTFileInfo):CXIdxClientASTFile
    startedTranslationUnit*: proc (client_data:CXClientData, reserved:pointer):CXIdxClientContainer
    indexDeclaration*: proc (client_data:CXClientData, declInfo: ptr CXIdxDeclInfo)
    indexEntityReference*: proc (client_data:CXClientData, entityRefInfo: ptr CXIdxEntityRefInfo)
  CXIndexAction* = distinct pointer
    ## https://clang.llvm.org/doxygen/group__CINDEX__HIGH.html#gac8d30d3e3fb34d887b611e7c6de3afb6
  CXIndexOptFlags* = enum
    ## https://clang.llvm.org/doxygen/group__CINDEX__HIGH.html#ga8c30458ffd9b99a7fcd95a5759c99816
    CXIndexOpt_None = 0x0,
    CXIndexOpt_SuppressRedundantRefs = 0x1,
    CXIndexOpt_IndexFunctionLocalSymbols = 0x2,
    CXIndexOpt_IndexImplicitTemplateInstantiations = 0x4,
    CXIndexOpt_SuppressWarnings = 0x8,
    CXIndexOpt_SkipParsedBodiesInSession = 0x10
  CXFieldVisitor* = proc (C:CXCursor, client_data:CXClientData):CXVisitorResult
    ## https://clang.llvm.org/doxygen/group__CINDEX__HIGH.html#ga5040863c91d7a720a97569cf869f42a4
{.pop.}

const CXTUResourceUsage_MEMORY_IN_BYTES_BEGIN* = CXTUResourceUsage_AST
  ## https://clang.llvm.org/doxygen/group__CINDEX__TRANSLATION__UNIT.html#gga13810240df7c205de04daac58f956396a1ba688242079bafd247953f3b3196b77
const CXTUResourceUsage_MEMORY_IN_BYTES_END* = CXTUResourceUsage_Preprocessor_HeaderSearch
  ## https://clang.llvm.org/doxygen/group__CINDEX__TRANSLATION__UNIT.html#gga13810240df7c205de04daac58f956396a9d86d03c24871d8bdd20e474e8ebff15
const CXTUResourceUsage_First* = CXTUResourceUsage_AST
  ## https://clang.llvm.org/doxygen/group__CINDEX__TRANSLATION__UNIT.html#gga13810240df7c205de04daac58f956396a549b44950f23464d6ee9dd4fa45c7245
const CXTUResourceUsage_Last* = CXTUResourceUsage_Preprocessor_HeaderSearch
  ## https://clang.llvm.org/doxygen/group__CINDEX__TRANSLATION__UNIT.html#gga13810240df7c205de04daac58f956396a2145f6b4e6d66d695e4172e70bbe1ee0
const CXCursor_FirstDecl*                     = CXCursor_UnexposedDecl
  ## https://clang.llvm.org/doxygen/group__CINDEX.html#ggaaccc432245b4cd9f2d470913f9ef0013a5192435d9ee932823c31a86bd032574b
const CXCursor_LastDecl*                      = CXCursor_CXXAccessSpecifier
  ## https://clang.llvm.org/doxygen/group__CINDEX.html#ggaaccc432245b4cd9f2d470913f9ef0013a3dc3a9b791e2d434dbc879e9fa852ace
const CXCursor_LastRef*                       = CXCursor_VariableRef
  ## https://clang.llvm.org/doxygen/group__CINDEX.html#ggaaccc432245b4cd9f2d470913f9ef0013adfd0b911d9a42e638229c1a803f1c7ba
const CXCursor_LastInvalid*                   = CXCursor_InvalidCode
  ## https://clang.llvm.org/doxygen/group__CINDEX.html#ggaaccc432245b4cd9f2d470913f9ef0013a572a19b7f235d46be2570f599b911202
const CXCursor_LastExpr*                      = CXCursor_FixedPointLiteral
  ## https://clang.llvm.org/doxygen/group__CINDEX.html#ggaaccc432245b4cd9f2d470913f9ef0013a0172535b2fa28390a9d49f7caf53f2ce
const CXCursor_AsmStmt*                       = CXCursor_GCCAsmStmt
  ## https://clang.llvm.org/doxygen/group__CINDEX.html#ggaaccc432245b4cd9f2d470913f9ef0013a46a6cb4d6481b333d830c2eca1c7a93f
const CXCursor_LastAttr*                      = CXCursor_AlignedAttr
  ## https://clang.llvm.org/doxygen/group__CINDEX.html#ggaaccc432245b4cd9f2d470913f9ef0013aee5cf383b7f533f28b014dadad15a394
const CXCursor_MacroInstantiation*            = CXCursor_MacroExpansion
  ## https://clang.llvm.org/doxygen/group__CINDEX.html#ggaaccc432245b4cd9f2d470913f9ef0013a422db075330999e974fffb5638022f73
const CXCursor_FirstPreprocessing*            = CXCursor_PreprocessingDirective
  ## https://clang.llvm.org/doxygen/group__CINDEX.html#ggaaccc432245b4cd9f2d470913f9ef0013a3ee9083643028d398afca9cbc3300bfe
const CXCursor_LastPreprocessing*             = CXCursor_InclusionDirective
  ## https://clang.llvm.org/doxygen/group__CINDEX.html#ggaaccc432245b4cd9f2d470913f9ef0013a4e86e6e9b850a51d3689493b5e192546
const CXCursor_FirstExtraDecl*                = CXCursor_ModuleImportDecl
  ## https://clang.llvm.org/doxygen/group__CINDEX.html#ggaaccc432245b4cd9f2d470913f9ef0013ac24a60713913ec819d230f23d126c2c7
const CXCursor_LastExtraDecl*                 = CXCursor_FriendDecl
  ## https://clang.llvm.org/doxygen/group__CINDEX.html#ggaaccc432245b4cd9f2d470913f9ef0013aa632117fcbc9fe3ccf139f7cb09f0bb6
const CXCursor_ObjCSuperClassRef*             = 40
  ## https://clang.llvm.org/doxygen/group__CINDEX.html#ggaaccc432245b4cd9f2d470913f9ef0013a04f9f7847e3a9032ad3f2e0b9beed86b
const CXCursor_InvalidFile*                   = 70
  ## https://clang.llvm.org/doxygen/group__CINDEX.html#ggaaccc432245b4cd9f2d470913f9ef0013aa061321085c08cd5a4c434deb0ee5ae7
const CXCursor_UnexposedExpr*                 = 100
  ## https://clang.llvm.org/doxygen/group__CINDEX.html#ggaaccc432245b4cd9f2d470913f9ef0013aa4cd2c9319493a279d14815173e528a6
const CXCursor_UnexposedStmt*                 = 200
  ## https://clang.llvm.org/doxygen/group__CINDEX.html#ggaaccc432245b4cd9f2d470913f9ef0013a3cd008e10ab67d7f793e3ecc4ce9953b
const CXCursor_LastStmt*                      = CXCursor_BuiltinBitCastExpr
  ## https://clang.llvm.org/doxygen/group__CINDEX.html#ggaaccc432245b4cd9f2d470913f9ef0013a8231feacc8670a62639ad66e9276a038
const CXCursor_UnexposedAttr*                 = 400
  ## https://clang.llvm.org/doxygen/group__CINDEX.html#ggaaccc432245b4cd9f2d470913f9ef0013a56b1a578c3f15052f83d0c316ed1d4bf
const CXType_FirstBuiltin* = CXType_Void
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ggaad39de597b13a18882c21860f92b095aad8de5982722cab5226a8f901baa26b79
const CXType_LastBuiltin* = CXType_ULongAccum
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ggaad39de597b13a18882c21860f92b095aab8ed72ce4b88bd4b5db24994840d33a5
const CXCallingConv_X86_64Win64* = CXCallingConv_Win64
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#gga4a0e941ec7b4b64bf9eb3d0ed49d55aea953765d3cce647ce8c363c5e0fd44aa6
const CXPrintingPolicy_LastProperty* = CXPrintingPolicy_FullyQualifiedName
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__XREF.html#ggad5e7ef491a343f4cd8d8d7088c2c32cea47577b503a3d75d1a81f71e00f5c2e97

{.push importc, dynlib:DLL.}
proc clang_createIndex*(excludeDeclarationsFromPCH, displayDiagnostics: cint): CXIndex
  ## https://clang.llvm.org/doxygen/group__CINDEX.html#ga51eb9b38c18743bf2d824c6230e61f93
proc clang_disposeIndex*(index: CXIndex)
  ## https://clang.llvm.org/doxygen/group__CINDEX.html#ga166ab73b14be73cbdcae14d62dbab22a
proc clang_CXIndex_setGlobalOptions*(index: CXIndex, options: cuint)
  ## https://clang.llvm.org/doxygen/group__CINDEX.html#ga82c320cc4c21dfd64650b3995cb5e7a6
proc clang_CXIndex_getGlobalOptions*(index: CXIndex):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX.html#ga21e96379358f2aedc56890f9a35d4125
proc clang_CXIndex_setInvocationEmissionPathOption*(index: CXIndex, Path: cstring)
  ## https://clang.llvm.org/doxygen/group__CINDEX.html#gadef365184859039d703c4f955f109cb7
proc clang_getFileName*(SFile: CXFile): CXString
  ## https://clang.llvm.org/doxygen/group__CINDEX__FILES.html#ga626ff6335ab1e0a2b8c8823301225690
proc clang_getFileTime*(SFile: CXFile):Time
  ## https://clang.llvm.org/doxygen/group__CINDEX__FILES.html#gac8444d2892e0d24fcf71a9dea8a475cb
proc clang_getFileUniqueID*(file:CXFile, outId: ptr CXFileUniqueID):cint
  ## https://clang.llvm.org/doxygen/group__CINDEX__FILES.html#gafeef0a8288de8c14e95e4d6c249aaf1e
proc clang_isFileMultipleIncludeGuarded*(tu: CXTranslationUnit, file: CXFile):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__FILES.html#ga1969fe907a40d9469ea68c370d0f602a
proc clang_getFile*(tu: CXTranslationUnit, file_name: cstring): CXFile
  ## https://clang.llvm.org/doxygen/group__CINDEX__FILES.html#gaa0554e2ea48ecd217a29314d3cbd2085
proc clang_getFileContents*(tu: CXTranslationUnit, file: CXFile, size: ptr csize_t):cstring
  ## https://clang.llvm.org/doxygen/group__CINDEX__FILES.html#ga37a2396fb032f747f0b8101c7bfb9993
proc clang_File_tryGetRealPathName*(file: CXFile): CXString
  ## https://clang.llvm.org/doxygen/group__CINDEX__FILES.html#ga5a6c556f77fd0b108e383a20dbf534ce
proc clang_getNullLocation*(): CXSourceLocation
  ## https://clang.llvm.org/doxygen/group__CINDEX__LOCATIONS.html#ga79db06b88e567b1da41620fd96c51787
proc clang_equalLocations*(loc1: CXSourceLocation, loc2: CXSourceLocation):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__LOCATIONS.html#gabb1ee8108ded5d3eafa6d059eb473ef8
proc clang_getLocation*(tu: CXTranslationUnit, file: CXFile, line: cuint, column: cuint):CXSourceLocation
  ## https://clang.llvm.org/doxygen/group__CINDEX__LOCATIONS.html#ga86d822034407d60d9e1f36e07cbc0f67
proc clang_getLocationForOffset*(tu: CXTranslationUnit, file: CXFile, offset: cuint):CXSourceLocation
  ## https://clang.llvm.org/doxygen/group__CINDEX__LOCATIONS.html#gab6f5b1cc0761131ccfd1dc8cdca1f6d8
proc clang_Location_isInSystemHeader*(location: CXSourceLocation):cint
  ## https://clang.llvm.org/doxygen/group__CINDEX__LOCATIONS.html#ga6bff8dbc149f24f388d8b960e99222a1
proc clang_Location_isFromMainFile*(location: CXSourceLocation):cint
  ## https://clang.llvm.org/doxygen/group__CINDEX__LOCATIONS.html#gacb4ca7b858d66f0205797ae84cc4e8f2
proc clang_getNullRange*():CXSourceRange
  ## https://clang.llvm.org/doxygen/group__CINDEX__LOCATIONS.html#gafcb849f2f038466f46397d552e736da3
proc clang_getRange*(begin:CXSourceLocation, `end`:CXSourceLocation):CXSourceRange
  ## https://clang.llvm.org/doxygen/group__CINDEX__LOCATIONS.html#ga4e2b6d439f72fdee12c2e4dcf4ff1e2f
proc clang_equalRanges*(range1:CXSourceRange, range2:CXSourceRange):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__LOCATIONS.html#ga07e10740b1e867fe4329c6a2df3f9be7
proc clang_Range_isNull*(range: CXSourceRange):cint
  ## https://clang.llvm.org/doxygen/group__CINDEX__LOCATIONS.html#ga39213a93703e84c0accdba1f618d7fbb
proc clang_getExpansionLocation*(location:CXSourceLocation, file: ptr CXFile, line: ptr cuint, column: ptr cuint, offset: ptr cuint)
  ## https://clang.llvm.org/doxygen/group__CINDEX__LOCATIONS.html#gadee4bea0fa34550663e869f48550eb1f
proc clang_getPresumedLocation*(location: CXSourceLocation, filename: ptr CXString, line: ptr cuint, column: ptr cuint)
  ## https://clang.llvm.org/doxygen/group__CINDEX__LOCATIONS.html#ga03508d9c944feeb3877515a1b08d36f9
proc clang_getInstantiationLocation*(location:CXSourceLocation, file: ptr CXFile, line: ptr cuint, column: ptr cuint, offset: ptr cuint)
  ## https://clang.llvm.org/doxygen/group__CINDEX__LOCATIONS.html#ga112e657eb04c281ca12c6975d489b633
proc clang_getSpellingLocation*(location:CXSourceLocation, file: ptr CXFile, line: ptr cuint, column: ptr cuint, offset: ptr cuint)
  ## https://clang.llvm.org/doxygen/group__CINDEX__LOCATIONS.html#ga01f1a342f7807ea742aedd2c61c46fa0
proc clang_getFileLocation*(location:CXSourceLocation, file: ptr CXFile, line: ptr cuint, column: ptr cuint, offset: ptr cuint)
  ## https://clang.llvm.org/doxygen/group__CINDEX__LOCATIONS.html#gae0ee9ff0ea04f2446832fc12a7fd2ac8
proc clang_getRangeStart*(range:CXSourceRange):CXSourceLocation
  ## https://clang.llvm.org/doxygen/group__CINDEX__LOCATIONS.html#gac2cc034e3965739c41662f6ada7ff248
proc clang_getRangeEnd*(range:CXSourceRange):CXSourceLocation
  ## https://clang.llvm.org/doxygen/group__CINDEX__LOCATIONS.html#gacdb7d3c2b77a06bcc2e83bde3e14c3c0
proc clang_getSkippedRanges*(tu: CXTranslationUnit, file: CXFile): ptr CXSourceRangeList
  ## https://clang.llvm.org/doxygen/group__CINDEX__LOCATIONS.html#gae27bc89151459aeb94e0fb7aa0552d35
proc clang_getAllSkippedRanges*(tu: CXTranslationUnit): ptr CXSourceRangeList
  ## https://clang.llvm.org/doxygen/group__CINDEX__LOCATIONS.html#ga06a114b020fda470476ff5293a66e5e1
proc clang_disposeSourceRangeList*(ranges: ptr CXSourceRangeList)
  ## https://clang.llvm.org/doxygen/group__CINDEX__LOCATIONS.html#ga6305dd3e01bbfa8a999f47bd2cae2506
proc clang_getNumDiagnosticsInSet*(Diags: CXDiagnosticSet):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__DIAG.html#ga44e87e54125e501de0d3bd29161fe26b
proc clang_getDiagnosticInSet*(Diags: CXDiagnosticSet, Index: cuint): CXDiagnostic
  ## https://clang.llvm.org/doxygen/group__CINDEX__DIAG.html#ga997e07d587e02eea7d29874c33c94249
proc clang_loadDiagnostics*(file:cstring, error: ptr CXLoadDiag_Error, errorString: ptr CXString):CXDiagnosticSet
  ## https://clang.llvm.org/doxygen/group__CINDEX__DIAG.html#gaa1e3aff15dc2eb97330533f0c68bd28f
proc clang_disposeDiagnosticSet*(Diags: CXDiagnosticSet)
  ## https://clang.llvm.org/doxygen/group__CINDEX__DIAG.html#ga1a1126b07e4dc0b45b0617f3cc848d57
proc clang_getChildDiagnostics*(D: CXDiagnostic): CXDiagnosticSet
  ## https://clang.llvm.org/doxygen/group__CINDEX__DIAG.html#ga1aa24f925b34bb988dc3ea06ec27dcda
proc clang_getNumDiagnostics*(Unit: CXTranslationUnit):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__DIAG.html#gae9f047b4bbbbb01161478d549b7aab25
proc clang_getDiagnostic*(Unit: CXTranslationUnit, Index: cuint): CXDiagnostic
  ## https://clang.llvm.org/doxygen/group__CINDEX__DIAG.html#ga3f54a79e820c2ac9388611e98029afe5
proc clang_getDiagnosticSetFromTU*(Unit: CXTranslationUnit): CXDiagnosticSet
  ## https://clang.llvm.org/doxygen/group__CINDEX__DIAG.html#gaf786e9688b9a685958e486cb81910924
proc clang_disposeDiagnostic*(Diagnostic: CXDiagnostic)
  ## https://clang.llvm.org/doxygen/group__CINDEX__DIAG.html#ga07061e0ad7665b7c5ee7253cd1bf4a5c
proc clang_formatDiagnostic*(Diagnostic: CXDiagnostic, Options: cuint): CXString
  ## https://clang.llvm.org/doxygen/group__CINDEX__DIAG.html#ga455234ab6de0ca12c9ea36f8874060e8
proc clang_defaultDiagnosticDisplayOptions*():cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__DIAG.html#ga5fcf910792541399efd63c62042ce353
proc clang_getDiagnosticSeverity*(diagnostic: CXDiagnostic): CXDiagnosticSeverity
  ## https://clang.llvm.org/doxygen/group__CINDEX__DIAG.html#gaff14261578eb9a2b02084f0cc6b95f9a
proc clang_getDiagnosticLocation*(diagnostic: CXDiagnostic): CXSourceLocation
  ## https://clang.llvm.org/doxygen/group__CINDEX__DIAG.html#gabfcf70ac15bb3e5ae39ef2c5e07c7428
proc clang_getDiagnosticSpelling*(diagnostic: CXDiagnostic): CXString
  ## https://clang.llvm.org/doxygen/group__CINDEX__DIAG.html#ga34a875e6d06ed4f8d2fc032f850ebbe1
proc clang_getDiagnosticOption*(Diag: CXDiagnostic, Disable: ptr CXString):CXString
  ## https://clang.llvm.org/doxygen/group__CINDEX__DIAG.html#ga69b094e2cca1cd6f452327dc9204a168
proc clang_getDiagnosticCategory*(diag: CXDiagnostic):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__DIAG.html#ga0ec085bd59b8b6c935eab0e53a1f348f
proc clang_getDiagnosticCategoryName*(Category: cuint): CXString
  ## https://clang.llvm.org/doxygen/group__CINDEX__DIAG.html#gaf3d608c7860a57ce6571a3b03b4ead33
proc clang_getDiagnosticCategoryText*(diagnostic: CXDiagnostic): CXString
  ## https://clang.llvm.org/doxygen/group__CINDEX__DIAG.html#ga6950702b6122f1cd74e1a369605a9f54
proc clang_getDiagnosticNumRanges*(diag: CXDiagnostic):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__DIAG.html#ga7acbd761f1113ea657022e5708694924
proc clang_getDiagnosticRange*(Diagnostic: CXDiagnostic, Range: cuint): CXSourceRange
  ## https://clang.llvm.org/doxygen/group__CINDEX__DIAG.html#gabd440f1577374289ffebe73d9f65b294
proc clang_getDiagnosticNumFixIts*(Diagnostic: CXDiagnostic):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__DIAG.html#gafe38dfd661f6ba59df956dfeabece2a2
proc clang_getDiagnosticFixIt*(Diagnostic: CXDiagnostic, FixIt: cuint, ReplacementRange: ptr CXSourceRange): CXString
  ## https://clang.llvm.org/doxygen/group__CINDEX__DIAG.html#gadf990bd68112475c5c07b19c1fe3938a
proc clang_getTranslationUnitSpelling*(CTUnit: CXTranslationUnit): CXString
  ## https://clang.llvm.org/doxygen/group__CINDEX__TRANSLATION__UNIT.html#ga7fb521c65f3aeb15b977d910098ceb0d
proc clang_createTranslationUnitFromSourceFile*(CIdx: CXIndex,
                                                source_filename: cstring,
                                                num_clang_command_line_args: cint,
                                                clang_command_line_args: ptr cstring,
                                                num_unsaved_files: cuint,
                                                unsaved_files: ptr CXUnsavedFile):CXTranslationUnit
  ## https://clang.llvm.org/doxygen/group__CINDEX__TRANSLATION__UNIT.html#gaf45dfbcd2e4d8e9eeab4778f994a74c3
proc clang_createTranslationUnit*(CIdx: CXIndex, ast_filename: cstring): CXTranslationUnit
  ## https://clang.llvm.org/doxygen/group__CINDEX__TRANSLATION__UNIT.html#ga0659baf7f04381286ec54b439760c8f3
proc clang_createTranslationUnit2*(CIdx: CXIndex, ast_filename: cstring, out_TU: ptr CXTranslationUnit): CXErrorCode
  ## https://clang.llvm.org/doxygen/group__CINDEX__TRANSLATION__UNIT.html#ga749a8220b23a06ba2fdcbea06d6bb211
proc clang_defaultEditingTranslationUnitOptions*():cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__TRANSLATION__UNIT.html#ga35cfcf8b5c2c15247e476c4e47c2d37d
proc clang_parseTranslationUnit*(CIdx: CXIndex,
                                 source_filename: cstring,
                                 command_line_args:ptr cstring,
                                 num_command_line_args:cint ,
                                 unsaved_files: ptr CXUnsavedFile,
                                 num_unsaved_files:cuint,
                                 options:cuint): CXTranslationUnit
  ## https://clang.llvm.org/doxygen/group__CINDEX__TRANSLATION__UNIT.html#ga2baf83f8c3299788234c8bce55e4472e
proc clang_parseTranslationUnit2*(CIdx: CXIndex,
                                  source_filename: cstring,
                                  command_line_args:ptr cstring,
                                  num_command_line_args:cint ,
                                  unsaved_files: ptr CXUnsavedFile,
                                  num_unsaved_files:cuint,
                                  options:cuint,
                                  out_TU: ptr CXTranslationUnit): CXErrorCode
  ## https://clang.llvm.org/doxygen/group__CINDEX__TRANSLATION__UNIT.html#ga494de0e725c5ae40cbdea5fa6081027d
proc clang_parseTranslationUnit2FullArgv*(CIdx: CXIndex,
                                          source_filename: cstring,
                                          command_line_args:ptr cstring,
                                          num_command_line_args:cint ,
                                          unsaved_files: ptr CXUnsavedFile,
                                          num_unsaved_files:cuint,
                                          options:cuint,
                                          out_TU: ptr CXTranslationUnit): CXErrorCode
  ## https://clang.llvm.org/doxygen/group__CINDEX__TRANSLATION__UNIT.html#ga1270c19516b75bac85797ebb837c64e1
proc clang_defaultSaveOptions*(TU: CXTranslationUnit):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__TRANSLATION__UNIT.html#ga4cb02bd2ceed0380a761391ba7a69092
proc clang_saveTranslationUnit*(TU: CXTranslationUnit, FileName: cstring , options:cuint):cint
  ## https://clang.llvm.org/doxygen/group__CINDEX__TRANSLATION__UNIT.html#ga3abe9df81f9fef269d737d82720c1d33
proc clang_suspendTranslationUnit*(TU: CXTranslationUnit):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__TRANSLATION__UNIT.html#gad8528b23bd6e1cb42679d06f23ffc194
proc clang_disposeTranslationUnit*(TU: CXTranslationUnit)
  ## https://clang.llvm.org/doxygen/group__CINDEX__TRANSLATION__UNIT.html#gaee753cb0036ca4ab59e48e3dff5f530a
proc clang_defaultReparseOptions*(TU: CXTranslationUnit):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__TRANSLATION__UNIT.html#gacd29e05f33062a81330fc4a8d255921b
proc clang_reparseTranslationUnit*(TU: CXTranslationUnit,
                                   num_unsaved_files:cuint,
                                   unsaved_files: ptr CXUnsavedFile,
                                   options: cuint):CXErrorCode
  ## https://clang.llvm.org/doxygen/group__CINDEX__TRANSLATION__UNIT.html#ga524e76bf2a809d037934d4be51ea448a
proc clang_getTUResourceUsageName*(kind: CXTUResourceUsageKind):cstring
  ## https://clang.llvm.org/doxygen/group__CINDEX__TRANSLATION__UNIT.html#gabfa8cf56068a27a4dc1cc4caa1f178b1
proc clang_getCXTUResourceUsage*(TU: CXTranslationUnit):CXTUResourceUsage
  ## https://clang.llvm.org/doxygen/group__CINDEX__TRANSLATION__UNIT.html#gaacd1a1e9d83aaeec6b800e701b3a53f5
proc clang_disposeCXTUResourceUsage*(usage: CXTUResourceUsage)
  ## https://clang.llvm.org/doxygen/group__CINDEX__TRANSLATION__UNIT.html#gad80475303ab1270d878319ae6d85ef26
proc clang_getTranslationUnitTargetInfo*(CTUnit: CXTranslationUnit):CXTargetInfo
  ## https://clang.llvm.org/doxygen/group__CINDEX__TRANSLATION__UNIT.html#ga1813b53c06775c354f4797a5ec051948
proc clang_TargetInfo_dispose*(Info: CXTargetInfo)
  ## https://clang.llvm.org/doxygen/group__CINDEX__TRANSLATION__UNIT.html#gafb00d82420b0101c185b88338567ffd9
proc clang_TargetInfo_getTriple*(Info: CXTargetInfo):CXString
  ## https://clang.llvm.org/doxygen/group__CINDEX__TRANSLATION__UNIT.html#ga7ae67e3c8baf6a9852900f6529dce2d0
proc clang_TargetInfo_getPointerWidth*(Info: CXTargetInfo):cint
  ## https://clang.llvm.org/doxygen/group__CINDEX__TRANSLATION__UNIT.html#ga52d9492d496f4af2b41cb4ddf317c576
proc clang_getNullCursor*():CXCursor
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__MANIP.html#ga94d81bbf40dff4ac843458d018f3138e
proc clang_getTranslationUnitCursor*(Ctu: CXTranslationUnit): CXCursor
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__MANIP.html#gaec6e69127920785e74e4a517423f4391
proc clang_equalCursors*(cx1: CXCursor, cx2: CXCursor):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__MANIP.html#ga98df58f09878710b983b6f3f60f0cba3
proc clang_Cursor_isNull*(cursor:CXCursor):cint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__MANIP.html#ga91f2a167caa704ee921e94e9397b99d9
proc clang_hashCursor*(cursor: CXCursor):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__MANIP.html#gabf27e0eaee38ae9e7453f55754d4929b
proc clang_getCursorKind*(cursor: CXCursor):CXCursorKind
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__MANIP.html#ga018aaf60362cb751e517d9f8620d490c
proc clang_isDeclaration*(cursor: CXCursorKind):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__MANIP.html#ga660aa4846fce0a54e20073ab6a5465a0
proc clang_isInvalidDeclaration*(cursor:CXCursor):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__MANIP.html#gafb9599d3bb0ba1711d8cda1be5843929
proc clang_isReference*(cursor: CXCursorKind):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__MANIP.html#gaf1bf500b9ada62671b53831d023387ba
proc clang_isExpression*(cursor: CXCursorKind):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__MANIP.html#ga8e537f2f251a92a799d6cc8459614d42
proc clang_isStatement*(cursor: CXCursorKind):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__MANIP.html#ga33c9d1d9cf46a316160f68356608773a
proc clang_isAttribute*(cursor: CXCursorKind):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__MANIP.html#ga204227c8c254c568ef6d577ffcf8d3e5
proc clang_Cursor_hasAttrs*(C:CXCursor):cuint
  ## https://clang.llvm.org/doxygen/
proc clang_isInvalid*(cursor: CXCursorKind):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__MANIP.html#ga86d525c70189f9d04caf5aa59121c384
proc clang_isTranslationUnit*(cursor: CXCursorKind):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__MANIP.html#gaa25633b28eb4799da0952e9beb03799b
proc clang_isPreprocessing*(cursor: CXCursorKind):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__MANIP.html#gab2c617ece02f6e3f41e403b8c7d85bce
proc clang_isUnexposed*(cursor: CXCursorKind):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__MANIP.html#ga838c465c6d1e681d2469eaa5adffcceb
proc clang_getCursorLinkage*(cursor: CXCursor):CXLinkageKind
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__MANIP.html#ga359dae25aa1a71176a5e33f3c7ee1740
proc clang_getCursorVisibility*(cursor:CXCursor):CXVisibilityKind
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__MANIP.html#ga935b442bd6bde168cf354b7629b471d8
proc clang_getCursorAvailability*(cursor:CXCursor):CXAvailabilityKind
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__MANIP.html#gab44e2a565fa40a0e0fc0f130f618a9b5
proc clang_getCursorPlatformAvailability*(cursor:CXCursor,
                                         always_deprecated:ptr cint,
                                         deprecated_message: ptr CXString,
                                         always_unavailable:ptr cint,
                                         unavailable_message: ptr CXString,
                                         availability:ptr CXPlatformAvailability,
                                         availability_size:cint):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__MANIP.html#gaab07659398c4538771d62c81ca5dea69
proc clang_disposeCXPlatformAvailability*(availability: ptr CXPlatformAvailability)
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__MANIP.html#ga1acfac399add40f7240e02f9f5f1a6d9
proc clang_getCursorLanguage*(cursor: CXCursor):CXLanguageKind
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__MANIP.html#ga3729a27620b08e32e331a6c168e707b3
proc clang_getCursorTLSKind*(cursor: CXCursor):CXTLSKind
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__MANIP.html#ga524e1bd046dfb581484ec50e8f22ae7a
proc clang_Cursor_getTranslationUnit*(cursor: CXCursor):CXTranslationUnit
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__MANIP.html#ga529f1504710a41ce358d4e8c3161848d
proc clang_createCXCursorSet*():CXCursorSet
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__MANIP.html#gaf77146bb2008dee2d9a74d56e669945f
proc clang_disposeCXCursorSet*(cset:CXCursorSet)
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__MANIP.html#gaf4178bd9a28549b94c83863a973f5e05
proc clang_CXCursorSet_contains*(cset:CXCursorSet, cursor: CXCursor):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__MANIP.html#ga518db5daf2ca251e4ff983d9f4f7d75d
proc clang_CXCursorSet_insert*(cset:CXCursorSet, cursor: CXCursor):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__MANIP.html#ga172e5a92c77da9609ad80baf08751dd1
proc clang_getCursorSemanticParent*(cursor: CXCursor):CXCursor
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__MANIP.html#gabc327b200d46781cf30cb84d4af3c877
proc clang_getCursorLexicalParent*(cursor: CXCursor):CXCursor
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__MANIP.html#gace7a423874d72b3fdc71d6b0f31830dd
proc clang_getOverriddenCursors*(cursor: CXCursor, overridden: ptr ptr CXCursor, num_overridden: ptr cuint)
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__MANIP.html#gac308b03420c550e00c61153dc63deac8
proc clang_disposeOverriddenCursors*(overridden: ptr CXCursor)
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__MANIP.html#gac8f259af871b3f34ca7150703f8aaaa8
proc clang_getIncludedFile*(cursor: CXCursor):CXFile
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__MANIP.html#gaf61979977343e39f21d6ea0b22167514
proc clang_getCursor*(ctu: CXTranslationUnit, csl: CXSourceLocation):CXCursor
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__SOURCE.html#ga30a9972c7e099ab2735fa6c45e247ec8
proc clang_getCursorLocation*(cursor: CXCursor):CXSourceLocation
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__SOURCE.html#gada3d3cbd3a3e83ff64f992617318dfb1
proc clang_getCursorExtent*(cursor: CXCursor):CXSourceRange
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__SOURCE.html#ga79f6544534ab73c78a8494c4c0bc2840
proc clang_getCursorType*(C:CXCursor):CXType
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#gaae5702661bb1f2f93038051737de20f4
proc clang_getTypeSpelling*(CT:CXType):CXString
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#gac9d37f61bede521d4f42a6553bcbc09f
proc clang_getTypedefDeclUnderlyingType*(C:CXCursor):CXType
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga8de899fc18dc859b6fe3b97309f4fd52
proc clang_getEnumDeclIntegerType*(C:CXCursor):CXType
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga0f5f950bee4e1828b51a41f0eaa951c4
proc clang_getEnumConstantDeclValue*(C:CXCursor):clonglong
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga6b8585818420e7512feb4c9d209b4f4d
proc clang_getEnumConstantDeclUnsignedValue*(C:CXCursor):culonglong
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#gaf7cbd4f2d371dd93e8bc997c951a1aef
proc clang_getFieldDeclBitWidth*(C:CXCursor):cint
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga80bbb872dde5b2f26964081338108f91
proc clang_Cursor_getNumArguments*(C:CXCursor):cint
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga5254f761b57fd78de3ac9c6bfcaa7fed
proc clang_Cursor_getArgument*(C:CXCursor, i:cint):CXCursor
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga673c5529d33eedd0b78aca5ac6fc1d7c
proc clang_Cursor_getNumTemplateArguments*(C:CXCursor):cint
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#gaa34e031c03fafb63accf8f9842a4b948
proc clang_Cursor_getTemplateArgumentKind*(C:CXCursor, I:cuint):CXTemplateArgumentKind
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#gad657c21f57e009899bd6a0ab618ee321
proc clang_Cursor_getTemplateArgumentType*(C:CXCursor, I:cuint):CXType
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#gae3fab0d8906e4531a1b7fbe77b4b4bc1
proc clang_Cursor_getTemplateArgumentValue*(C:CXCursor,I:cuint):clonglong
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga46e363545effaa0794a2ba4bcfae1fe3
proc clang_Cursor_getTemplateArgumentUnsignedValue*(C:CXCursor, I:cuint):culonglong
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga08dac49044448c022457224e73223eb2
proc clang_equalTypes*(A:CXType, B:CXType):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#gac047de2ab0f7e1b1586d8317a658a1d9
proc clang_getCanonicalType*(T:CXType):CXType
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#gaa9815d77adc6823c58be0a0e32010f8c
proc clang_isConstQualifiedType*(T:CXType):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga8c3f8029254d5862bcd595d6c8778e5b
proc clang_Cursor_isMacroFunctionLike*(C:CXCursor):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga0fcb19b77fa3eb1dd531bb8f20f65e6c
proc clang_Cursor_isMacroBuiltin*(C:CXCursor):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#gad5ddc0fd032716a88cddc14558e0d914
proc clang_Cursor_isFunctionInlined*(C:CXCursor):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga963097b9aecabf5dce7554dff18b061d
proc clang_isVolatileQualifiedType*(T:CXType):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#gaac0ac93cded7d1e5c60f539daaed13ec
proc clang_isRestrictQualifiedType*(T:CXType):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga12375c30c12b0c3ede87492605db1d0c
proc clang_getAddressSpace*(T:CXType):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga8e5ee21a20472403231caf15b05348d4
proc clang_getTypedefName*(CT:CXType):CXString
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga7b8e66707c7f27550acfc2daeec527ed
proc clang_getPointeeType*(T:CXType):CXType
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#gaafa3eb34932d8da1358d50ed949ff3ee
proc clang_getTypeDeclaration*(T:CXType):CXCursor
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga0aad74ea93a2f5dea58fd6fc0db8aad4
proc clang_getDeclObjCTypeEncoding*(C:CXCursor):CXString
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga3ab59f0bd04192dbf250f966b1e9fc8f
proc clang_Type_getObjCEncoding*(`type`:CXType):CXString
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga03b6fac5491434832d1a49ba1ebc80be
proc clang_getTypeKindSpelling*(K:CXTypeKind):CXString
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga6bd7b366d998fc67f4178236398d0666
proc clang_getFunctionTypeCallingConv*(T:CXType):CXCallingConv
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#gae3392567fa1e69d3921785723f06ce55
proc clang_getResultType*(T:CXType):CXType
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga39b4850746f39e17c6b8b4eef3154d85
proc clang_getExceptionSpecificationType*(T:CXType):cint
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga97f253ec4fc0bf0326a3dd96cbb6ba9e
proc clang_getNumArgTypes*(T:CXType):cint
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga705e1a4ed7c7595606fc30ed5d2a6b5a
proc clang_getArgType*(T:CXType, i:cuint):CXType
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga67f60ba4831b1bfd90ab0c1c12adab27
proc clang_Type_getObjCObjectBaseType*(T:CXType):CXType
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga4c05a789e0daef8a877160b378305f56
proc clang_Type_getNumObjCProtocolRefs*(T:CXType):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga24b8b6de4de515b1b4beba3307078709
proc clang_Type_getObjCProtocolDecl*(T:CXType, i:cuint):CXCursor
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#gabf1ac26b98a0320443b32a5f88fc299d
proc clang_Type_getNumObjCTypeArgs*(T:CXType):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga8f383e74a66b4bd4afd4ea9c741d8c93
proc clang_Type_getObjCTypeArg*(T:CXType, i:cuint):CXType
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga693ed1a4ba459eb9f31d79c1076f3e01
proc clang_isFunctionTypeVariadic*(T:CXType):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga343b2463b0ed4b259739242cf26c3ae2
proc clang_getCursorResultType*(C:CXCursor):CXType
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga6995a2d6352e7136868574b299005a63
proc clang_getCursorExceptionSpecificationType*(C:CXCursor):cint
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#gae9536e898e50a2d95975d9be0617aaa8
proc clang_isPODType*(T:CXType):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga3e7fdbe3d246ed03298bd074c5b3703e
proc clang_getElementType*(T:CXType):CXType
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#gab35027c8bc48fab25f7698a415c93922
proc clang_getNumElements*(T:CXType):clonglong
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#gac5f636020c388126bec572cb1fb13007
proc clang_getArrayElementType*(T:CXType):CXType
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga718591f4b07d9d4861557a3ed8b29713
proc clang_getArraySize*(T:CXType):clonglong
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga91521260817054f153b5f1295056192d
proc clang_Type_getNamedType*(T:CXType):CXType
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#gac6d90c2acdae77f75d8e8288658da463
proc clang_Type_isTransparentTagTypedef*(T:CXType):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga9ac4ecb0e84f25b9f05d54c67353eba0
proc clang_Type_getNullability*(T:CXType):CXTypeNullabilityKind
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga7dea7999675ffb1edef4881667fa800c
proc clang_Type_getAlignOf*(T:CXType):clonglong
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#gaee56de66c69ab5605fe47e7c52497e31
proc clang_Type_getClassType*(T:CXType):CXType
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga4434129ffc0fb0fc668a593e226d62cc
proc clang_Type_getSizeOf*(T:CXType):clonglong
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga027abe334546e80931905f31399d0a8b
proc clang_Type_getOffsetOf*(T:CXType, S:cstring):clonglong
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#gab543536d5c18efb3e23a1b7903fb494d
proc clang_Type_getModifiedType*(T:CXType):CXType
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga6fc6ec9bfd9baada2d3fd6022d774675
proc clang_Cursor_getOffsetOfField*(C:CXCursor):clonglong
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#gaa7e0f0ec320c645e971168ac39aa0cab
proc clang_Cursor_isAnonymous*(C:CXCursor):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga6e0d2674d126fd43816ce3a80b592373
proc clang_Cursor_isAnonymousRecordDecl*(C:CXCursor):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga59aaf3b8329a35e400ee3735229a8cb6
proc clang_Cursor_isInlineNamespace*(C:CXCursor):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#gafd107ef7b7372e195ecec7ce1ad9a0bd
proc clang_Type_getNumTemplateArguments*(T:CXType):cint
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga13f25981892e38c345d609b56ae1ee9c
proc clang_Type_getTemplateArgumentAsType*(T:CXType, i:cuint):CXType
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga9645640281c8d088982b2133f58edcb3
proc clang_Type_getCXXRefQualifier*(T:CXType):CXRefQualifierKind
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga9eefb424da6ca291285dd50f82006b26
proc clang_Cursor_isBitField*(C:CXCursor):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga750705f6b418b25ca00495b7392c740d
proc clang_isVirtualBase*(C:CXCursor):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga1e3db635bc5615910f9b3a2b02fe87f0
proc clang_getCXXAccessSpecifier*(cursor:CXCursor):CX_CXXAccessSpecifier
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#gab5a250699f7d0ad95810891c7926f83d
proc clang_Cursor_getStorageClass*(cursor:CXCursor):CX_StorageClass
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#ga230c7904f3878469d772f3e464b9c83d
proc clang_getOverloadedDecl*(cursor:CXCursor,index:cint):CXCursor
  ## https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html#gab1c718b939700a6c23adfb9729c9c28f
proc clang_getIBOutletCollectionType*(cursor:CXCursor):CXType
  ## https://clang.llvm.org/doxygen/group__CINDEX__ATTRIBUTES.html#ga93c2c27353ae1a5d56303d09ec8ca1c2
proc clang_visitChildren*(parent:CXCursor, visitor:CXCursorVisitor, client_data:CXClientData):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__TRAVERSAL.html#ga5d0a813d937e1a7dcc35f206ad1f7a91
proc clang_getCursorUSR*(C:CXCursor):CXString
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__XREF.html#ga51679cb755bbd94cc5e9476c685f2df3
proc clang_constructUSR_ObjCClass*(class_name:CXString):CXString
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__XREF.html#ga1ca1d94cdcb4d435c5e2e02d888b8e98
proc clang_constructUSR_ObjCCategory*(class_name:CXString, category_name:CXString):CXString
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__XREF.html#gabeb36e25f86fc061c0367145fab6e291
proc clang_constructUSR_ObjCProtocol*(protocol_name:CXString ):CXString
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__XREF.html#ga69236bf8ac3dadbb553ab6db463ad3d0
proc clang_constructUSR_ObjCIvar*(name:CXString, classUSR:CXString):CXString
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__XREF.html#ga91dcb69a0378fcef6d21ac0be6c0038a
proc clang_constructUSR_ObjCMethod*(name:CXString, isInstanceMethod:cuint, classUSR:CXString):CXString
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__XREF.html#ga8f3065868eb56e24a6467703fa28a054
proc clang_constructUSR_ObjCProperty*(property:CXString, classUSR:CXString):CXString
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__XREF.html#gac19f0c8de7e33a98723b336472e67e0c
proc clang_getCursorSpelling*(C:CXCursor):CXString
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__XREF.html#gaad1c9b2a1c5ef96cebdbc62f1671c763
proc clang_Cursor_getSpellingNameRange*(C:CXCursor, pieceIndex:cuint, options:cuint):CXSourceRange
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__XREF.html#ga251b31de80fd14681edf46f43b0bd03b
proc clang_PrintingPolicy_getProperty*(Policy:CXPrintingPolicy, Property:CXPrintingPolicyProperty):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__XREF.html#ga7855b9fe611cba6b90a189bbfd9722f2
proc clang_PrintingPolicy_setProperty*(Policy:CXPrintingPolicy, Property:CXPrintingPolicyProperty, Value:cuint)
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__XREF.html#gaae4e0acad8c7f603d97988113d01d1fc
proc clang_getCursorPrintingPolicy*(C:CXCursor):CXPrintingPolicy
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__XREF.html#gaae83c013276d1fff6475566a23d9fffd
proc clang_PrintingPolicy_dispose*(Policy:CXPrintingPolicy)
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__XREF.html#ga81b2a9cac2b0ad4da7086c7fd3d4256f
proc clang_getCursorPrettyPrinted*(Cursor:CXCursor, Policy:CXPrintingPolicy):CXString
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__XREF.html#gab9d561cc237ce0d8bfbab80cdd5be216
proc clang_getCursorDisplayName*(C:CXCursor):CXString
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__XREF.html#gac3eba3224d109a956f9ef96fd4fe5c83
proc clang_getCursorReferenced*(C:CXCursor):CXCursor
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__XREF.html#gabf059155921552e19fc2abed5b4ff73a
proc clang_getCursorDefinition*(C:CXCursor):CXCursor
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__XREF.html#gafcfbec461e561bf13f1e8540bbbd655b
proc clang_isCursorDefinition*(C:CXCursor):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__XREF.html#ga6ad05634a73e693217088eaa693f0010
proc clang_getCanonicalCursor*(C:CXCursor):CXCursor
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__XREF.html#gac802826668be9fd40a017523cc7d24fe
proc clang_Cursor_getObjCSelectorIndex*(C:CXCursor):cint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__XREF.html#ga3ea92edf682a5a734e5f4d0c2217f0b8
proc clang_Cursor_isDynamicCall*(C:CXCursor):cint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__XREF.html#gad1e793914af7b7bf286d58a34e90ab6c
proc clang_Cursor_getReceiverType*(C:CXCursor):CXType
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__XREF.html#ga252a679781181d3a6dbd680a215c9594
proc clang_Cursor_getObjCPropertyAttributes*(C:CXCursor, reserved:cuint):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__XREF.html#ga3a964b4c56f8bfb8229a9a08114e2567
proc clang_Cursor_getObjCPropertyGetterName*(C:CXCursor):CXString
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__XREF.html#ga80bf2169b5de20ea41409d3ff92a40b1
proc clang_Cursor_getObjCPropertySetterName*(C:CXCursor):CXString
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__XREF.html#ga1657d0c9bbd4c96b621b21744c7e1d15
proc clang_Cursor_getObjCDeclQualifiers*(C:CXCursor):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__XREF.html#ga551d4dd1d81d7a818b68cf3811546671
proc clang_Cursor_isObjCOptional*(C:CXCursor):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__XREF.html#ga1dcb3b9d9471aebb2167c93b47c018b8
proc clang_Cursor_isVariadic*(C:CXCursor):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__XREF.html#ga3a9a5766db391fa5ca88b347651e5b8e
proc clang_Cursor_isExternalSymbol*(C:CXCursor, language: ptr CXString, definedIn: ptr CXString, isGenerated: ptr cuint):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__XREF.html#gaaf06aa68727ca40f4fa86d235e6fc9e9
proc clang_Cursor_getCommentRange*(C:CXCursor):CXSourceRange
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__XREF.html#gab5e05b0cc042fbd91ecaf1790ece0ecc
proc clang_Cursor_getRawCommentText*(C:CXCursor):CXString
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__XREF.html#ga32905a8b1858e67cf5d28b7ad7150779
proc clang_Cursor_getBriefCommentText*(C:CXCursor):CXString
  ## https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__XREF.html#ga6b5282b915d457d728434c0651ea0b8b
proc clang_Cursor_getMangling*(C:CXCursor):CXString
  ## https://clang.llvm.org/doxygen/group__CINDEX__MANGLE.html#ga5d471df1f0608075193c33753549250a
proc clang_Cursor_getCXXManglings*(C:CXCursor):ptr CXStringSet
  ## https://clang.llvm.org/doxygen/group__CINDEX__MANGLE.html#ga27a071c8adf5c10b09c6b0b0aba54b79
proc clang_Cursor_getObjCManglings*(C:CXCursor):ptr CXStringSet
  ## https://clang.llvm.org/doxygen/group__CINDEX__MANGLE.html#ga256e5baf4ac8725e15d851a165fd69f6
proc clang_Cursor_getModule*(C:CXCursor):CXModule
  ## https://clang.llvm.org/doxygen/group__CINDEX__MODULE.html#gab69ab0bc94760b2c93d63efa8cb6a6dd
proc clang_getModuleForFile*(ctu:CXTranslationUnit, file:CXFile):CXModule
  ## https://clang.llvm.org/doxygen/group__CINDEX__MODULE.html#ga22aa52a86a00c1af80f4858c0d5f00a6
proc clang_Module_getASTFile*(Module:CXModule):CXFile
  ## https://clang.llvm.org/doxygen/group__CINDEX__MODULE.html#gaa5095dd877556655d096d3165e86b0e1
proc clang_Module_getParent*(Module:CXModule):CXModule
  ## https://clang.llvm.org/doxygen/group__CINDEX__MODULE.html#ga62e149a28d71b719b11aefee3d36df53
proc clang_Module_getName*(Module:CXModule):CXString
  ## https://clang.llvm.org/doxygen/group__CINDEX__MODULE.html#ga39896de675e90c4fb2de55e109d376a8
proc clang_Module_getFullName*(Module:CXModule):CXString
  ## https://clang.llvm.org/doxygen/group__CINDEX__MODULE.html#ga09d2da739b4bbac05fa2c1ad6695095a
proc clang_Module_isSystem*(Module:CXModule):cint
  ## https://clang.llvm.org/doxygen/group__CINDEX__MODULE.html#ga1e4ad74c404b5f3bcd30cec4dc12fa34
proc clang_Module_getNumTopLevelHeaders*(ctu:CXTranslationUnit, Module:CXModule):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__MODULE.html#gaee667293d56a18d3e8c17e37ce77cb0d
proc clang_Module_getTopLevelHeader*(ctu:CXTranslationUnit, Module:CXModule, Index:cuint):CXFile
  ## https://clang.llvm.org/doxygen/group__CINDEX__MODULE.html#ga08aa0746251ca2e8eee69c8fe7c15e2b
proc clang_CXXConstructor_isConvertingConstructor*(C:CXCursor):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CPP.html#ga64f60658013fe2cc9f568fe5a5f55d4f
proc clang_CXXConstructor_isCopyConstructor*(C:CXCursor):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CPP.html#ga0c6580828662fd27cb7152e47c1b3e4e
proc clang_CXXConstructor_isDefaultConstructor*(C:CXCursor):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CPP.html#ga4c15c2e3e4dd6258cbf26547dd76229b
proc clang_CXXConstructor_isMoveConstructor*(C:CXCursor):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CPP.html#gaa1cb77ef71cca950b8ec7d1e6666a8a2
proc clang_CXXField_isMutable*(C:CXCursor):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CPP.html#ga139bb12b60cd1ee472c6617f84691463
proc clang_CXXMethod_isDefaulted*(C:CXCursor):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CPP.html#gaa9a2e7ae6d70db44f385ef1a0e49b4e5
proc clang_CXXMethod_isPureVirtual*(C:CXCursor):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CPP.html#ga27e62c66c6dde438a114c4d6f93b5d9d
proc clang_CXXMethod_isStatic*(C:CXCursor):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CPP.html#ga0362e1cf8957f59cc2803456ac2cbc45
proc clang_CXXMethod_isVirtual*(C:CXCursor):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CPP.html#gacd412f761b0622d6ea873f2ab21812e3
proc clang_CXXRecord_isAbstract*(C:CXCursor):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CPP.html#gae09414fefc2bca8547439a438189ff8c
proc clang_EnumDecl_isScoped*(C:CXCursor):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CPP.html#ga9825058fd70b7577057901d56e09fc4d
proc clang_CXXMethod_isConst*(C:CXCursor):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CPP.html#ga89a96f6eaae57508edc968611ac8969e
proc clang_getTemplateCursorKind*(C:CXCursor):CXCursorKind
  ## https://clang.llvm.org/doxygen/group__CINDEX__CPP.html#gafe1f32ddd935c20f0f455d47c05ec5ab
proc clang_getSpecializedCursorTemplate*(C:CXCursor):CXCursor
  ## https://clang.llvm.org/doxygen/group__CINDEX__CPP.html#gad3f78435e7ee316b3d9e704c9d42ec4b
proc clang_getCursorReferenceNameRange*(C:CXCursor, NameFlags:cuint, PieceIndex:cuint):CXSourceRange
  ## https://clang.llvm.org/doxygen/group__CINDEX__CPP.html#ga8a31e7fc22e41643629394caebf4f04c
proc clang_getToken*(TU:CXTranslationUnit, Location:CXSourceLocation):ptr CXToken
  ## https://clang.llvm.org/doxygen/group__CINDEX__LEX.html#ga473c4c17bb2e8ccdb137050dfdca0e6d
proc clang_getTokenKind*(token: CXToken):CXTokenKind
  ## https://clang.llvm.org/doxygen/group__CINDEX__LEX.html#ga83f692a67fe4dbeea779f37c0a3b7f20
proc clang_getTokenSpelling*(TU:CXTranslationUnit,token:CXToken):CXString
  ## https://clang.llvm.org/doxygen/group__CINDEX__LEX.html#ga1033a25c9d2c59bcbdb23020de0bba2c
proc clang_getTokenLocation*(TU:CXTranslationUnit,token:CXToken):CXSourceLocation
  ## https://clang.llvm.org/doxygen/group__CINDEX__LEX.html#ga76a721514acb4cc523e10a6913d88021
proc clang_getTokenExtent*(TU:CXTranslationUnit,token:CXToken):CXSourceRange
  ## https://clang.llvm.org/doxygen/group__CINDEX__LEX.html#ga5acbc0a2a3c01aa44e1c5c5ccc4e328b
proc clang_tokenize*(TU:CXTranslationUnit, Range:CXSourceRange, Tokens: ptr ptr CXToken, NumTokens: ptr cuint)
  ## https://clang.llvm.org/doxygen/group__CINDEX__LEX.html#ga6b315a71102d4f6c95eb68894a3bda8a
proc clang_annotateTokens*(TU:CXTranslationUnit, Tokens: ptr CXToken, NumTokens:cuint, Cursors: ptr CXCursor)
  ## https://clang.llvm.org/doxygen/group__CINDEX__LEX.html#gadc0c15904e61902b73e02700af0863a0
proc clang_disposeTokens*(TU:CXTranslationUnit, Tokens: ptr CXToken, NumTokens:cuint)
  ## https://clang.llvm.org/doxygen/group__CINDEX__LEX.html#gac5266f6b5fee87c433b696437cab0d13
proc clang_getCursorKindSpelling*(Kind:CXCursorKind):CXString
  ## https://clang.llvm.org/doxygen/group__CINDEX__DEBUG.html#ga7a4eecfc1b343568cb9ea447cbde08a8
proc clang_getDefinitionSpellingAndExtent*(CXCursor, startBuf: ptr cstring, endBuf: ptr cstring, startLine: ptr cuint, startColumn: ptr cuint, endLine: ptr cuint, endColumn: ptr cuint)
  ## https://clang.llvm.org/doxygen/group__CINDEX__DEBUG.html#ga707dccd8978d58267923359b5b9a0701
proc clang_enableStackTraces*()
  ## https://clang.llvm.org/doxygen/group__CINDEX__DEBUG.html#ga66eec2931642afdf8b13a81447d5022d
proc clang_executeOnThread*(fn:proc (p:pointer), user_data: pointer, stack_size:cuint)
  ## https://clang.llvm.org/doxygen/group__CINDEX__DEBUG.html#ga80c2e471ea922c1bfda2bdd3438c7cdc
proc clang_getCompletionChunkKind*(completion_string:CXCompletionString, chunk_number:cuint):CXCompletionChunkKind
  ## https://clang.llvm.org/doxygen/group__CINDEX__CODE__COMPLET.html#gac61e18c6d895d85f1476c6091d486091
proc clang_getCompletionChunkText*(completion_string:CXCompletionString, chunk_number:cuint):CXString
  ## https://clang.llvm.org/doxygen/group__CINDEX__CODE__COMPLET.html#ga98d4c869dda8fd4b5386f62d02d6ba0b
proc clang_getCompletionChunkCompletionString*(completion_string:CXCompletionString, chunk_number:cuint):CXCompletionString
  ## https://clang.llvm.org/doxygen/group__CINDEX__CODE__COMPLET.html#ga3063e36e81b3e14809f87bdc841a3a9d
proc clang_getNumCompletionChunks*(completion_string:CXCompletionString):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CODE__COMPLET.html#ga76018aa1a7225268546e4d75dca5dbce
proc clang_getCompletionPriority*(completion_string:CXCompletionString):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CODE__COMPLET.html#ga46e843acdf63d9a7a0c7341a2d222c49
proc clang_getCompletionAvailability*(completion_string:CXCompletionString):CXAvailabilityKind
  ## https://clang.llvm.org/doxygen/group__CINDEX__CODE__COMPLET.html#gacbbded5dd9c27b927ed5080d8b530845
proc clang_getCompletionNumAnnotations*(completion_string:CXCompletionString):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CODE__COMPLET.html#gadce9960ed8d554f497eda0457a3d52f9
proc clang_getCompletionAnnotation*(completion_string:CXCompletionString, annotation_number:cuint):CXString
  ## https://clang.llvm.org/doxygen/group__CINDEX__CODE__COMPLET.html#ga5a6995822b664926ac3d919d69e736ce
proc clang_getCompletionParent*(completion_string:CXCompletionString, kind: ptr CXCursorKind):CXString
  ## https://clang.llvm.org/doxygen/group__CINDEX__CODE__COMPLET.html#ga8afa885ca6547c96baa1369179b3b236
proc clang_getCompletionBriefComment*(completion_string:CXCompletionString):CXString
  ## https://clang.llvm.org/doxygen/group__CINDEX__CODE__COMPLET.html#ga32163145c7f0013e5f2ac7176a8ee0ed
proc clang_getCursorCompletionString*(cursor:CXCursor):CXCompletionString
  ## https://clang.llvm.org/doxygen/group__CINDEX__CODE__COMPLET.html#ga403bcb1ebc70f1ec9e19543d76685f43
proc clang_getCompletionNumFixIts*(results: ptr CXCodeCompleteResults, completion_index:cuint):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CODE__COMPLET.html#ga159a3a3d5d867f5fd31b52843f0681ec
proc clang_getCompletionFixIt*(results: ptr CXCodeCompleteResults, completion_index:cuint, fixit_index:cuint, replacement_range: ptr CXSourceRange):CXString
  ## https://clang.llvm.org/doxygen/group__CINDEX__CODE__COMPLET.html#ga2bbe0ffbc47acda6ae5c51d5441fae07
proc clang_defaultCodeCompleteOptions*():cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CODE__COMPLET.html#gadb669685b9ef1f8ca62b2a044b846ac1
proc clang_codeCompleteAt*(TU:CXTranslationUnit, complete_filename:cstring, complete_line:cuint, complete_column:cuint, unsaved_files: ptr CXUnsavedFile, num_unsaved_files:cuint, options:cuint):ptr CXCodeCompleteResults
  ## https://clang.llvm.org/doxygen/group__CINDEX__CODE__COMPLET.html#ga50fedfa85d8d1517363952f2e10aa3bf
proc clang_sortCodeCompletionResults*(Results: ptr CXCompletionResult, NumResults:cuint)
  ## https://clang.llvm.org/doxygen/group__CINDEX__CODE__COMPLET.html#gaf2625ffd90004cf3202c7f9112eb3fe7
proc clang_disposeCodeCompleteResults*(Results:ptr CXCodeCompleteResults)
  ## https://clang.llvm.org/doxygen/group__CINDEX__CODE__COMPLET.html#ga206cc6ea7be311537bb0fab584ebc6c1
proc clang_codeCompleteGetNumDiagnostics*(Results:ptr CXCodeCompleteResults):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__CODE__COMPLET.html#ga0cce4aff990ed511c1878a23c57e87fa
proc clang_codeCompleteGetDiagnostic*(Results:ptr CXCodeCompleteResults, Index:cuint):CXDiagnostic
  ## https://clang.llvm.org/doxygen/group__CINDEX__CODE__COMPLET.html#gab298febc86d15c50265ff440e6da1913
proc clang_codeCompleteGetContexts*(Results:ptr CXCodeCompleteResults):culonglong
  ## https://clang.llvm.org/doxygen/group__CINDEX__CODE__COMPLET.html#ga76f5354e478002585b6bd3aba1d20582
proc clang_codeCompleteGetContainerKind*(Results:ptr CXCodeCompleteResults, IsIncomplete: ptr cuint):CXCursorKind
  ## https://clang.llvm.org/doxygen/group__CINDEX__CODE__COMPLET.html#ga7a7f0964e4b73192715489125dc9bf7e
proc clang_codeCompleteGetContainerUSR*(Results:ptr CXCodeCompleteResults):CXString
  ## https://clang.llvm.org/doxygen/group__CINDEX__CODE__COMPLET.html#gaf45d7f61268af6ec88c70a6fc69d5818
proc clang_codeCompleteGetObjCSelector*(Results:ptr CXCodeCompleteResults):CXString
  ## https://clang.llvm.org/doxygen/group__CINDEX__CODE__COMPLET.html#gad03e82d61a1e6cdb78538bf61823aa11
proc clang_getClangVersion*():CXString
  ## https://clang.llvm.org/doxygen/group__CINDEX__MISC.html#ga307e960e9dccaf721c0032cd4edd8908
proc clang_toggleCrashRecovery*(isEnabled:cuint)
  ## https://clang.llvm.org/doxygen/group__CINDEX__MISC.html#ga45afc52d275aa0587c69d4b6d2f10bf2
proc clang_getInclusions*(tu:CXTranslationUnit, visitor:CXInclusionVisitor, client_data:CXClientData)
  ## https://clang.llvm.org/doxygen/group__CINDEX__MISC.html#ga4363bd8c203ca2b5dfc23c5765695d60
proc clang_Cursor_Evaluate*(C:CXCursor):CXEvalResult
  ## https://clang.llvm.org/doxygen/group__CINDEX__MISC.html#ga6be809ca82538f4a610d9a5b18a10ccb
proc clang_EvalResult_getKind*(E:CXEvalResult):CXEvalResultKind
  ## https://clang.llvm.org/doxygen/group__CINDEX__MISC.html#gaea912a0620a9c16c1e46fdedf4825955
proc clang_EvalResult_getAsInt*(E:CXEvalResult):cint
  ## https://clang.llvm.org/doxygen/group__CINDEX__MISC.html#ga8abe0404897d93813d98bd07a198caa1
proc clang_EvalResult_getAsLongLong*(E:CXEvalResult):clonglong
  ## https://clang.llvm.org/doxygen/group__CINDEX__MISC.html#ga488b6b6a445be15e80ffe4816b2086c8
proc clang_EvalResult_isUnsignedInt*(E:CXEvalResult):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__MISC.html#gad72ab38051388e5ed607ce5ce890b2ac
proc clang_EvalResult_getAsUnsigned*(E:CXEvalResult):culonglong
  ## https://clang.llvm.org/doxygen/group__CINDEX__MISC.html#ga448569d83b25514da4a15e6623d4bf4e
proc clang_EvalResult_getAsDouble*(E:CXEvalResult):cdouble
  ## https://clang.llvm.org/doxygen/group__CINDEX__MISC.html#ga6d140616208f61e24e18abf806aa68a7
proc clang_EvalResult_dispose*(E:CXEvalResult)
  ## https://clang.llvm.org/doxygen/group__CINDEX__MISC.html#gaee104dfbff3ee6799ddebb417e968d8a
proc clang_getRemappings*(path:cstring):CXRemapping
  ## https://clang.llvm.org/doxygen/group__CINDEX__REMAPPING.html#ga6388687c77b68fb0e83a393a91625c7f
proc clang_getRemappingsFromFileList*(filePaths: ptr cstring, numFiles: cuint):CXRemapping
  ## https://clang.llvm.org/doxygen/group__CINDEX__REMAPPING.html#gadc19460a19f4f0d3ab8b722dca75b047
proc clang_remap_getNumFiles*(remapping: CXRemapping):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__REMAPPING.html#ga17c7dd265fa861d2f7e67223eaae653d
proc clang_remap_getFilenames*(remapping: CXRemapping, index: cuint, original: ptr CXString, transformed: ptr CXString)
  ## https://clang.llvm.org/doxygen/group__CINDEX__REMAPPING.html#ga22fa206f0879f988bac281390063a9d7
proc clang_remap_dispose*(remapping: CXRemapping)
  ## https://clang.llvm.org/doxygen/group__CINDEX__REMAPPING.html#gafbd34560f59e5d3e0f5e746215b12ed7
proc clang_findReferencesInFile*(cursor:CXCursor, file:CXFile, visitor:CXCursorAndRangeVisitor):CXResult
  ## https://clang.llvm.org/doxygen/group__CINDEX__HIGH.html#gaa8524d179bc3668d215d326d332df97b
proc clang_findIncludesInFile*(TU:CXTranslationUnit, file:CXFile, visitor:CXCursorAndRangeVisitor):CXResult
  ## https://clang.llvm.org/doxygen/group__CINDEX__HIGH.html#ga1c3e49cda9a6e2f9c6930881755e0605
proc clang_index_isEntityObjCContainerKind*(kind:CXIdxEntityKind):cint
  ## https://clang.llvm.org/doxygen/group__CINDEX__HIGH.html#gacd31bd2c96a08c185a4d6f63d1133649
proc clang_index_getObjCContainerDeclInfo*(info:ptr CXIdxDeclInfo):ptr CXIdxObjCContainerDeclInfo
  ## https://clang.llvm.org/doxygen/group__CINDEX__HIGH.html#ga78117833cbb1378e373097b4288b8937
proc clang_index_getObjCInterfaceDeclInfo*(info:ptr CXIdxDeclInfo):ptr CXIdxObjCInterfaceDeclInfo
  ## https://clang.llvm.org/doxygen/group__CINDEX__HIGH.html#ga06efe31085488d05c291d2fb4e09edeb
proc clang_index_getObjCCategoryDeclInfo*(info:ptr CXIdxDeclInfo):ptr CXIdxObjCCategoryDeclInfo
  ## https://clang.llvm.org/doxygen/group__CINDEX__HIGH.html#gac5301220677a46afd733eb1cffb2909a
proc clang_index_getObjCProtocolRefListInfo*(info:ptr CXIdxDeclInfo):ptr CXIdxObjCProtocolRefListInfo
  ## https://clang.llvm.org/doxygen/group__CINDEX__HIGH.html#ga5c39608c859456cbc78109d010765415
proc clang_index_getObjCPropertyDeclInfo*(info:ptr CXIdxDeclInfo):ptr CXIdxObjCPropertyDeclInfo
  ## https://clang.llvm.org/doxygen/group__CINDEX__HIGH.html#ga6319eecf732286e2d1c59582bccfad07
proc clang_index_getIBOutletCollectionAttrInfo*(info:ptr CXIdxAttrInfo):ptr CXIdxIBOutletCollectionAttrInfo
  ## https://clang.llvm.org/doxygen/group__CINDEX__HIGH.html#ga56c79b1bd72e70149706933a3112f871
proc clang_index_getCXXClassDeclInfo*(info:ptr CXIdxDeclInfo):ptr CXIdxCXXClassDeclInfo
  ## https://clang.llvm.org/doxygen/group__CINDEX__HIGH.html#gaeba620227e5d19dbe6d23b801c1753a6
proc clang_index_getClientContainer*(info:ptr CXIdxContainerInfo):CXIdxClientContainer
  ## https://clang.llvm.org/doxygen/group__CINDEX__HIGH.html#gaca430242bc5e6f6faaac3aa39105b5c1
proc clang_index_setClientContainer*(info:ptr CXIdxContainerInfo,container:CXIdxClientContainer)
  ## https://clang.llvm.org/doxygen/group__CINDEX__HIGH.html#ga85255b4017399b012f9967125a3a36e8
proc clang_index_getClientEntity*(info:ptr CXIdxEntityInfo):CXIdxClientEntity
  ## https://clang.llvm.org/doxygen/group__CINDEX__HIGH.html#ga1731a531a2a24471cef7288623b9820b
proc clang_index_setClientEntity*(info:ptr CXIdxEntityInfo, entity:CXIdxClientEntity)
  ## https://clang.llvm.org/doxygen/group__CINDEX__HIGH.html#ga3b68cac914a9bf52ad54467cd5dbfbc7
proc clang_IndexAction_create*(CIdx:CXIndex):CXIndexAction
  ## https://clang.llvm.org/doxygen/group__CINDEX__HIGH.html#gaedee4ab7f093fedd27ed6995b1b7c62a
proc clang_IndexAction_dispose*(action:CXIndexAction)
  ## https://clang.llvm.org/doxygen/group__CINDEX__HIGH.html#ga9b648aa6e87ea8d29dd0d4f0f592ffbb
proc clang_indexSourceFile*(action:CXIndexAction,
                            client_data:CXClientData,
                            index_callbacks: ptr IndexerCallbacks,
                            index_callbacks_size:cuint,
                            index_options:cuint,
                            source_filename:cstring,
                            command_line_args:ptr cstring ,
                            num_command_line_args:cint,
                            unsaved_files:ptr CXUnsavedFile,
                            num_unsaved_files:cuint,
                            out_TU:ptr CXTranslationUnit,
                            TU_options:cuint):cint
  ## https://clang.llvm.org/doxygen/group__CINDEX__HIGH.html#gaa5c2ad8979779c401b91110d444e2be6
proc clang_indexSourceFileFullArgv*(action:CXIndexAction,
                                    client_data:CXClientData,
                                    index_callbacks: ptr IndexerCallbacks,
                                    index_callbacks_size:cuint,
                                    index_options:cuint,
                                    source_filename:cstring,
                                    command_line_args:ptr cstring ,
                                    num_command_line_args:cint,
                                    unsaved_files:ptr CXUnsavedFile,
                                    num_unsaved_files:cuint,
                                    out_TU:ptr CXTranslationUnit,
                                    TU_options:cuint):cint
  ## https://clang.llvm.org/doxygen/group__CINDEX__HIGH.html#ga3b08166c97a48146a4a0395876332327
proc clang_indexSourceFileFullArgv*(action:CXIndexAction,
                                    client_data:CXClientData,
                                    index_callbacks: ptr IndexerCallbacks,
                                    index_callbacks_size:cuint,
                                    index_options:cuint,
                                    tu:CXTranslationUnit):cint
  ## https://clang.llvm.org/doxygen/group__CINDEX__HIGH.html#ga3b08166c97a48146a4a0395876332327
proc clang_indexLoc_getFileLocation*(loc:CXIdxLoc,
                                     indexFile: ptr CXIdxClientFile,
                                     file: ptr CXFile,
                                     line: ptr cuint,
                                     column: ptr cuint,
                                     offset: ptr cuint)
  ## https://clang.llvm.org/doxygen/group__CINDEX__HIGH.html#ga340d2dda7a0d3430fe9929034c1b712c
proc clang_indexLoc_getCXSourceLocation*(loc:CXIdxLoc):CXSourceLocation
  ## https://clang.llvm.org/doxygen/group__CINDEX__HIGH.html#ga89d0ff9816ec25f6d68edc5cbc908c20
proc clang_Type_visitFields*(T:CXType,
                            visitor:CXFieldVisitor,
                            client_data:CXClientData):cuint
  ## https://clang.llvm.org/doxygen/group__CINDEX__HIGH.html#ga18285a2cefecf5a069c64e675b627273
{.pop.}
