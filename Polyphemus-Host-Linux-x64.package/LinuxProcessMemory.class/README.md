The memory of a process that is still running, read as a file.

On Linux this needs no foreign call and no debugger. `/proc/<pid>/maps` is a text file listing
every mapped region; `/proc/<pid>/mem` is a file whose offsets *are* virtual addresses. Seek to
an address and read.

So it answers the same three messages `ElfCoreDump` does -- `hasAddress:`, `bytesAt:count:`,
`unsignedAt:size:` -- and the same `loadableSegments`, which means `SpurDumpedMemory` takes one
of these exactly where it takes a core file, and nothing above learns the difference.

Two things the operating system decides, not us. Yama's `ptrace_scope` is 1 on most machines,
so `/proc/<pid>/mem` may only be opened by an ancestor of that process: read your own, or read
one you started. And a running process is a moving target -- stop it first, or read a heap that
never existed at any single instant.
