type
  CXErrorCode* = enum
    ## https://clang.llvm.org/doxygen/CXErrorCode_8h.html#adba17f287f8184fc266f2db4e669bf0f
    CXError_Success = 0,
    CXError_Failure = 1,
    CXError_Crashed = 2,
    CXError_InvalidArguments = 3,
    CXError_ASTReadError = 4
