const DLL* =
  when defined(linux):
    "libclang.so"
  elif defined(windows):
    "libclang.dll"
  elif defined(macos):
    "libclang.dylib"
