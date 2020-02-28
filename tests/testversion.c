#include "clang-c/Index.h"

int main(int argc, char** argv) {
  printf("%d.%d\n", CINDEX_VERSION_MAJOR,CINDEX_VERSION_MINOR);
  return 0;
}
