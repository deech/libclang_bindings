import "nimscript_utils/download.nims"
import distros, strformat, options, system

const distroDownload =
  {
    "Ubuntu-19.04" : "https://releases.llvm.org/9.0.0/clang+llvm-9.0.0-x86_64-pc-linux-gnu.tar.xz",
    "Ubuntu-18.04" : "https://releases.llvm.org/9.0.0/clang+llvm-9.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz",
    "Ubuntu-16.04" : "https://releases.llvm.org/9.0.0/clang+llvm-9.0.0-x86_64-linux-gnu-ubuntu-16.04.tar.xz",
    "Ubuntu-14.04" : "https://releases.llvm.org/9.0.0/clang+llvm-9.0.0-x86_64-linux-gnu-ubuntu-14.04.tar.xz",
    "Suse": "https://releases.llvm.org/9.0.0/clang+llvm-9.0.0-x86_64-linux-sles11.3.tar.xz",
    "macOS" : "https://releases.llvm.org/9.0.0/clang+llvm-9.0.0-x86_64-darwin-apple.tar.xz",
    "windows" : "https://ziglang.org/deps/llvm+clang-9.0.0-win64-msvc-release.tar.xz"
  }.toTable

const genericLinux = "Ubuntu-19.04"
const libclangDir* = "libclang-9.0.0"
const libclangInclude* = libclangDir / "include"
const libclangLib* = libclangDir / "lib"

proc downloadLink():string =
  if defined(windows):
    result = distroDownload.get("windows")
  elif defined(macosx):
    result = distroDownload.get("macOS")
  elif defined(linux):
    let warnGeneric = proc (os : string) =
      echo fmt("Warning: Could not find a pre-built release for {os}, going with a generic linux build. Hopefully it works!")
    result = distroDownload.get genericLinux
    if findExe("lsb_release") != "":
      if detectOs(Distribution.Ubuntu):
        var release = staticExec("lsb_release -r")
        release.removePrefix("Release:")
        release.strip
        let ubuntu = fmt"Ubuntu-{release}"
        if distroDownload.hasKey(ubuntu):
          result = distroDownload.get(ubuntu)
        else:
          warnGeneric ubuntu
      elif detectOs(Distribution.OpenSUSE):
        result = distroDownload.get("Suse")
      else:
        warnGeneric staticExec("lsb_release -v")
    else:
      echo ("Warning: 'lsb_release' could not be found so your Linux distro and release could not be detected. Going with the generic linux build. Hopefully it works!")

proc getLibclang*(cache: string, proxy : Option[Proxy] = None[Proxy]) =
  if not (fileExists(cache / libclangDir)):
    let link = downloadLink()
    if link == "":
      newException(Defect, "No prebuilt libclang release found for your operating system.")
    else:
      download(Config(url: link, proxy: proxy, outfile: cache / "libclang.tar.xz", overwrite: true))
