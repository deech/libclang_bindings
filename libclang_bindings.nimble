# Package

version       = "0.1.0"
author        = "Aditya Siram"
description   = "Bindings to LibClang"
license       = "MIT"
srcDir        = "src"
backend       = "c"

requires "nim >= 1.1.1"
requires "nimscript_utils >= 0.1.0"
import "src/libclang_bindings/bundle.nims"
import strformat, os

task sandboxedTest, "Download libclang to a sandbox and use it to run tests":
  bundleLibclang()
  when defined(macosx):
    macosxTestWorkaround(projectDir())
  setCommand "test"
