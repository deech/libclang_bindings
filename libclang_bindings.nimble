# Package

version       = "0.1.0"
author        = "Aditya Siram"
description   = "Bindings to LibClang"
license       = "MIT"
srcDir        = "src"
backend       = "c"

requires "nim >= 1.1.1"
requires "nimscript_utils >= 0.1.0"
import src/libclang_bindings/bundle
import strutils
import strformat
import os

let test = getCurrentDir() / "tests" / "test1"

task sandboxedTest, "Build libclang locally and use it to run tests statically linked":
  bundle.build()
  exec(fmt"nim c -d:sandboxStatic -d:sandboxIncludeFlags={bundle.includePath} -d:sandboxLibDir={bundle.libraryPath} -r {test}")
  rmFile test

task sandboxedSharedTest, "Build libclang locally and ust it to run tests with dynamically linked":
  bundle.build()
  exec(fmt"nim c -d:sandbox -d:sandboxIncludeFlags={bundle.includePath} -d:sandboxLibDir={bundle.libraryPath} {test}")
  when defined(macosx):
    bundle.macosLibZ3Adjustment test
  rmFile test
