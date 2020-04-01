{.push importc, header:"clang-c/CXString.h".}
type
  CXString* {. final.} = object
    ## http://clang.llvm.org/doxygen/structCXString.html
    data*: pointer
    private_flags*: int
  CXStringSet* {. final.} = object
    ## http://clang.llvm.org/doxygen/structCXStringSet.html
    Strings*: ptr UncheckedArray[CXString]
    Count*: int

proc clang_getCString*(cxString: CXString):cstring
  ## http://clang.llvm.org/doxygen/group__CINDEX__STRING.html#gafd043aa189e990b9e327e9f95a1da8a5
proc clang_disposeString*(cxString: CXString)
  ## http://clang.llvm.org/doxygen/group__CINDEX__STRING.html#gaeff715b329ded18188959fab3066048f
proc clang_disposeStringSet*(cxStringSet: ptr CXStringSet)
  ## http://clang.llvm.org/doxygen/group__CINDEX__STRING.html#gabece1342b7aeba281b56edadced65ac9
{.pop.}
