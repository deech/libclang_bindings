import nimscript_utils/downloader
import nimscript_utils/extract
import nimscript_utils/env
import nimscript_utils/cmake
import nimscript_utils/programs
import raw/dll
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

when defined(posix):
  let sourceDownloads* =
    {
      "llvm" : "https://releases.llvm.org/9.0.0/llvm-9.0.0.src.tar.xz",
      "clang" : "https://releases.llvm.org/9.0.0/cfe-9.0.0.src.tar.xz"
    }.toTable

  proc downloadSources*(dir: string, proxy: Option[Proxy] = none[Proxy]()) =
    echo dir
    if not (system.existsDir (dir / "third-party")): mkDir(dir / "third-party")
    proc downloadExtract(key:string) =
      let extractDir = sourceDownloads[key].splitFile.name.splitFile.name
      let downloadFile = sourceDownloads[key].extractFilename
      if not (system.existsDir (dir / "third-party" / extractDir)):
        echo(dir / "third-party" / downloadFile)
        echo(dir / "third-party" / extractDir)
        download(Config(
          url: sourceDownloads[key],
          proxy: proxy,
          outfile : dir / "third-party" / downloadFile,
          overwrite : true
        ))
        echo extractTarxz(
          dir / "third-party" / downloadFile,
          dir / "third-party"
        )
    downloadExtract("llvm")
    downloadExtract("clang")

  proc buildFromSource*(proxy: Option[Proxy] = none[Proxy]()) =
    if missingPrograms(@["cmake"]).contains("cmake"):
      raise newException(Defect, "Could not find 'cmake' which is required to build LLVM and libclang from source.")
    let dir = getTempDir()
    downloadSources(dir, proxy)
    let installDir = dir / "third-party" / libclangDir
    let libclangFlags = @[
      fmt"-DCMAKE_INSTALL_PREFIX={installDir}",
      fmt"-DCMAKE_PREFIX_PATH={installDir}",
      "-DCMAKE_BUILD_TYPE=Release",
      "-DLIBCLANG_BUILD_STATIC=ON"
    ]
    let llvmFlags = libclangFlags & @["-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=\"AVR\"",  "-DLLVM_ENABLE_LIBXML2=OFF"]
    proc buildIt(key:string,flags:seq[string]) =
      runCmake(
        dir / "third-party" / sourceDownloads[key].splitFile.name.splitFile.name,
        flags
      )
    buildIt("llvm",llvmFlags)
    pushEnv("PATH",installDir / "bin")
    buildIt("clang",libclangFlags)

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
let tempDownloadLocation* = getTempDir() / "nim"

proc includePath*(cache: string) : string = cache / "third-party" / libclangDir / "include"
proc libraryPath*(cache: string) : string = cache / "third-party" / libclangDir / "lib"

proc getLibclang*(outDir: string, proxy : Option[Proxy] = none[Proxy]()): (string, string) =
  let outfile = link.extractFilename
  let clangDir = outDir / link.splitFile.name.splitFile.name
  if not (system.dirExists(clangDir)):
    if link == "":
      raise newException(Defect, "No prebuilt libclang release found for your operating system.")
    else:
      if not (system.dirExists clangDir):
        if not (system.fileExists outDir / outFile):
          echo fmt"Downloading from {link}. It's 380MB so it will take a while ..."
          download(Config(url: link, proxy: proxy, outfile: outDir / outfile, overwrite: true))
      echo fmt"Extracting {outfile} to {clangDir}"
      echo extractTarxz(outDir / outfile, outDir)
  return (outDir / outfile, clangDir)

proc cpLibsAndHeaders*(cache, libclangUnarchivedDir: string) =
  mkDir includePath(cache)
  mkDir libraryPath(cache)
  let clangDir = cache / link.splitFile.name.splitFile.name
  cpDir(
    libclangUnarchivedDir / "include" / "clang-c",
    includePath(cache) / "clang-c"
  )
  cpDir(
    libclangUnarchivedDir / "lib",
    libraryPath(cache)
  )
  for l in libclangDynamicLibs:
    cpFile(
     libclangUnarchivedDir / "lib" / l,
     libraryPath(cache) / l
    )

proc bundleLibclang*() =
  mkdir nimCacheDir()
  mkdir tempDownloadLocation
  let (_, tempExtracted) = getLibclang(tempDownloadLocation)
  cpLibsAndHeaders(nimCacheDir(), tempExtracted)
  for e in @["CPATH", "C_INCLUDE_PATH", "CPLUS_INCLUDE_PATH"]:
    pushEnv(e, includePath(nimCacheDir()))
  when defined(windows):
    pushEnv("PATH", libraryPath(nimCacheDir()))
  elif defined(macosx):
    for e in @["LIBRARY_PATH", "DYLD_LIBRARY_PATH"]:
      pushEnv(e,libraryPath(nimCacheDir()))
  else:
    for e in @["LIBRARY_PATH", "LD_LIBRARY_PATH"]:
      pushEnv(e, libraryPath(nimCacheDir()))

proc macosxTestWorkaround*(projectDir: string) =
  for l in libclangDynamicLibs:
    cpFile(
     libraryPath(nimCacheDir()) / l,
     projectDir / l
    )
