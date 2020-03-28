const DLL* =
  when defined(macosx):
    "libclang.dylib"
  elif defined(windows):
    "libclang.dll"
  elif defined(posix):
    "libclang.so"
  else:
    {.error: "These bindings are not supported on your platform".}
