let libclangDynamicLibs* {.compileTime.} =
  when defined(macosx): @["libclang.dylib"]
  elif defined(posix): @["libclang.so", "libclang.so.9"]
  else: @[]
