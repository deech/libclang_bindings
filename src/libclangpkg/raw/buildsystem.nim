import dll
import cxerrorcode

{.push importc,header:"clang-c/BuildSystem.h"}
type
  CXVirtualFileOverlay* = distinct pointer
    ## https://clang.llvm.org/doxygen/group__BUILD__SYSTEM.html#ga8d7eea7855a8d1118218c7661469b3db
  CXModuleMapDescriptor* = distinct pointer
    ## https://clang.llvm.org/doxygen/group__BUILD__SYSTEM.html#gae854e36ceb0a02071e557e19f908772d
{.pop.}

{.push importc, dynlib: DLL .}
proc clang_VirtualFileOverlay_create*(options: int):CXVirtualFileOverlay
  ## https://clang.llvm.org/doxygen/group__BUILD__SYSTEM.html#gac0fc5753287609c4087155c3bab1ba1b
proc clang_VirtualFileOverlay_addFileMapping*(overlay: CXVirtualFileOverlay, virtualPath: cstring, realPath: cstring): CXErrorCode
  ## https://clang.llvm.org/doxygen/group__BUILD__SYSTEM.html#gac0fc5753287609c4087155c3bab1ba1b
proc clang_VirtualFileOverlay_setCaseSensitivity*(overlay: CXVirtualFileOverlay, caseSensitive: cint)
  ## https://clang.llvm.org/doxygen/group__BUILD__SYSTEM.html#ga00ca3247ef5f5e3ac504ce13623939e3
proc clang_VirtualFileOverlay_writeToBuffer*(overlay: CXVirtualFileOverlay, options: cuint, out_buffer_ptr: ptr cstring, out_buffer_size: ptr cuint)
  ## https://clang.llvm.org/doxygen/group__BUILD__SYSTEM.html#ga10434b45b006d39f861d7b2a04d3e31e
proc clang_free*(buffer: pointer)
  ## https://clang.llvm.org/doxygen/group__BUILD__SYSTEM.html#ga3d7fcaba04ff8fcc4882e1bab6dcbee8
proc clang_VirtualFileOverlay_dispose*(overlay: CXVirtualFileOverlay)
  ## https://clang.llvm.org/doxygen/group__BUILD__SYSTEM.html#ga118f45b2f96f989fc1f39f3f95973deb
proc clang_ModuleMapDescriptor_create*(options:cuint):CXModuleMapDescriptor
  ## https://clang.llvm.org/doxygen/group__BUILD__SYSTEM.html#ga41bcb2ce427f6892d48bc21117b22274
proc clang_ModuleMapDescriptor_setFrameworkModuleName*(moduleMapDescriptor:CXModuleMapDescriptor, name:cstring):CXErrorCode
  ## https://clang.llvm.org/doxygen/group__BUILD__SYSTEM.html#gaaad31887de3a3856891a846e96f59802
proc clang_ModuleMapDescriptor_setUmbrellaHeader*(moduleMapDescriptor: CXModuleMapDescriptor, name:cstring):CXErrorCode
  ## https://clang.llvm.org/doxygen/group__BUILD__SYSTEM.html#ga63b8b9689c04f6b0c292d1226652a74b
proc clang_ModuleMapDescriptor_writeToBuffer*(moduleMapDescriptor: CXModuleMapDescriptor, options: cuint, out_buffer_ptr: ptr cstring, out_buffer_size: ptr cuint)
  ## https://clang.llvm.org/doxygen/group__BUILD__SYSTEM.html#gacaeaf475a29b16a041641b6ebe9a012d
proc clang_ModuleMapDescriptor_dispose*(moduleMapDescriptor: CXModuleMapDescriptor)
  ## https://clang.llvm.org/doxygen/group__BUILD__SYSTEM.html#gad905d6dc860716f1a35d2b87f46b81f9
{.pop.}
