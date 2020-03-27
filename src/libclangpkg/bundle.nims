import "nimscript_utils/downloader.nims"
import "nimscript_utils/extract.nims"
import distros, strutils, strformat, options, system, tables, os

let distroDownload* =
  {
    "Ubuntu-19.04" : "https://releases.llvm.org/9.0.0/clang+llvm-9.0.0-x86_64-pc-linux-gnu.tar.xz",
    "Ubuntu-18.04" : "https://releases.llvm.org/9.0.0/clang+llvm-9.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz",
    "Ubuntu-16.04" : "https://releases.llvm.org/9.0.0/clang+llvm-9.0.0-x86_64-linux-gnu-ubuntu-16.04.tar.xz",
    "Ubuntu-14.04" : "https://releases.llvm.org/9.0.0/clang+llvm-9.0.0-x86_64-linux-gnu-ubuntu-14.04.tar.xz",
    "Suse": "https://releases.llvm.org/9.0.0/clang+llvm-9.0.0-x86_64-linux-sles11.3.tar.xz",
    "macOS" : "https://releases.llvm.org/9.0.0/clang+llvm-9.0.0-x86_64-darwin-apple.tar.xz",
    "windows" : "https://ziglang.org/deps/llvm+clang-9.0.0-win64-msvc-release.tar.xz"
  }.toTable

let genericLinux* = "Ubuntu-19.04"
let libclangDir* = "libclang-9.0.0"
let libclangInclude* = "include" / "clang-c"
let libclangLib* = "lib"
let libclangDynamicLibs* = @[
  "libclang.so",
  "libclang.so.9"
]

let libclangStaticLibs* = @[
  "libclangAST.a",
  "libclangBasic.a",
  "libclangDriver.a",
  "libclangFrontend.a",
  "libclangIndex.a",
  "libclangLex.a",
  "libclangSema.a",
  "libclangSerialization.a",
  "libclangTooling.a"
]

proc downloadLink*():string =
  if defined(windows):
    result = distroDownload["windows"]
  elif defined(macosx):
    result = distroDownload["macOS"]
  elif defined(linux):
    let warnGeneric = proc (os : string) =
      echo fmt("Warning: Could not find a pre-built release for {os}, going with a generic linux build. Hopefully it works!")
    result = distroDownload[genericLinux]
    if system.findExe("lsb_release") != "":
      if detectOs(Ubuntu):
        var release = staticExec("lsb_release -r")
        release.removePrefix("Release:")
        release = release.strip
        let ubuntu = fmt"Ubuntu-{release}"
        if distroDownload.hasKey(ubuntu):
          result = distroDownload[ubuntu]
        else:
          warnGeneric ubuntu
      elif detectOs(OpenSUSE):
        result = distroDownload["Suse"]
      else:
        warnGeneric staticExec("lsb_release -v")
    else:
      echo ("Warning: 'lsb_release' could not be found so your Linux distro and release could not be detected, going with the generic linux build. Hopefully it works!")

let link* = downloadLink()

proc getLibclang*(cache: string, proxy : Option[Proxy] = none[Proxy]()): (string, string) =
  let outfile =  "libclang.tar.xz"
  if not (system.fileExists(cache / "third-party" / libclangDir)):
    if link == "":
      raise newException(Defect, "No prebuilt libclang release found for your operating system.")
    else:
      echo fmt"Downloading from {link}. This will take a while ..."
      download(Config(url: link, proxy: proxy, outfile: cache / outfile, overwrite: true))
      let clangDir = cache / link.splitFile.name.splitFile.name
      echo fmt"Extracting {outfile} to {clangDir}"
      discard extractTarxz(cache / outfile, cache)
      return (cache / outfile, clangDir)

proc cpLibsAndHeaders*(cache, libclangUnarchivedDir: string) =
  mkDir(cache / "third-party" / libclangDir / "include")
  mkDir(cache / "third-party" / libclangDir / "lib")
  let clangDir = cache / link.splitFile.name.splitFile.name
  cpDir(
    libclangUnarchivedDir / "include" / "clang-c",
    cache / "third-party" / libclangDir / "include" / "clang-c"
  )
  for l in libclangDynamicLibs & libclangStaticLibs:
    cpFile(
      libclangUnarchivedDir / "lib" / l,
      cache / "third-party" / libclangDir / "lib" / l
    )
