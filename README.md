Steps
1. Install using cmake - https://github.com/google/brotli#autotools-style-cmake
	
  a) Run ../configure-cmake --disable-debug (to generate Release Makefile)
  
  b) For local I wanted to install in `~/.local/` and not `usr/local` as it requires sudo permissions. For this I needed to update the file cmake_install.cmake file for the variable CMAKE_INSTALL_PREFIX and multiple other updates where it attempted to install or copy files to `/usr/local`

To run this example

```
CGO_CFLAGS='-I /home/ds/.local/include' CGO_LDFLAGS='-L /home/ds/.local/lib' go run main.go
```