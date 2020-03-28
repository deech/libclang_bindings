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

task getLibclang, "":
  bundleLibclang()
  echo getEnv("C_INCLUDE_PATH")

task sandboxedTest, "Download libclang to a sandbox and run tests with that":
  bundleLibclang()
  echo getEnv("C_INCLUDE_PATH")
  echo getEnv("LD_LIBRARY_PATH")
  echo staticExec("nimble test")
