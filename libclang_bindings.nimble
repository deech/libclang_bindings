# Package

version       = "0.1.0"
author        = "Aditya Siram"
description   = "Bindings to LibClang"
license       = "MIT"
srcDir        = "src"
backend       = "c"

requires "nim >= 1.1.1"
requires "nimscript_utils >= 0.1.0"
import "libclangpkg/bundle.nims"

task getLibclang, "":
  mkdir nimCacheDir()
  let (clangArchive, unarchivedDir) = getLibclang(nimCacheDir())
  cpLibsAndHeaders(nimCacheDir(), unarchivedDir)
  rmFile clangArchive
  rmDir unarchivedDir
