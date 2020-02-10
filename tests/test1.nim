import unittest

import libclang_bindings/index
import bitops

test "can create index with some global options":
  var ip = clang_createIndex(0,0)
  defer:
    clang_disposeIndex(ip)
  clang_CXIndex_setGlobalOptions(ip, bitor(ord(CXGlobalOpt_ThreadBackgroundPriorityForIndexing), ord(CXGlobalOpt_ThreadBackgroundPriorityForEditing)))
  check bitand((cuint)ord(CXGlobalOpt_ThreadBackgroundPriorityForEditing), clang_CXIndex_getGlobalOptions(ip)) == (cuint)ord(CXGlobalOpt_ThreadBackgroundPriorityForEditing)
  check clang_CXIndex_getGlobalOptions(ip) == (cuint)bitor(ord CXGlobalOpt_ThreadBackgroundPriorityForAll,
                                                           bitor(ord CXGlobalOpt_ThreadBackgroundPriorityForIndexing,
                                                                 ord CXGlobalOpt_ThreadBackgroundPriorityForEditing))
