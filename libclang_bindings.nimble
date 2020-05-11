# Package

version       = "0.1.0"
author        = "Aditya Siram"
description   = "Bindings to LibClang"
license       = "MIT"
srcDir        = "src"
backend       = "c"

requires "nim >= 1.3.3"
import os

let libclangBindingsSrc = getCurrentDir() / "src" / "libclang_bindings"
let bundlerGit = "https://github.com/deech/libclang_nim_bundler"
let nimscript_utilsGit = "https://github.com/deech/nimscript_utils"

proc cloneIfNeeded(root: string, repoDir: string, url: string) =
  if (not system.existsDir(root / repoDir)):
    echo "Cloning " & url
    withDir root:
      exec("git clone --depth 1 " & url)

import strformat

let test = getCurrentDir() / "tests" / "test1"

task test, "Run tests against a shared libclang":
  cloneIfNeeded(getCurrentDir(), "libclang_nim_bundler", bundlerGit)
  cloneIfNeeded(getCurrentDir() / "libclang_nim_bundler", "nimscript_utils", nimscript_utilsGit)
  exec(fmt"nim e testBuilder.nims shared {test}")

task testStatic, "Run tests against static libclang":
  cloneIfNeeded(getCurrentDir(), "libclang_nim_bundler", bundlerGit)
  cloneIfNeeded(getCurrentDir() / "libclang_nim_bundler", "nimscript_utils", nimscript_utilsGit)
  exec(fmt"nim e testBuilder.nims static {test}")
