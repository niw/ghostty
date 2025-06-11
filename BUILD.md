Build v1.1.3 on macOS 15.5
==========================

It requires zig 0.13.
As of 6/10/2025, zig from Homebrew is 0.14.1,
thus need to download 0.13 from zig website.

It also requires to patch code to deal with
compatiblity issue in `mach_types.h` header in macOS SDK 15.5.

This branch has the patch.
