# Core dump formats, enough to read one

Written so the code in `Polyphemus-Object-dump` can be understood without learning ELF first,
and so it can be understood on a train. Everything here is fact about a published format --
field names, offsets, sizes, constants -- described in our own words. The sources are listed at
the end for checking, not because anything here is copied from them.

## What a core dump is

A file holding pieces of a process's address space, plus a note of what the machine was doing.
It is produced by the kernel when a process dies badly, or on demand by a debugger. It is not a
memory image in the Pharo sense: nothing in it knows what an object is.

Reading one means answering a single question -- *what were the bytes at address A?* -- which is
the same question we answer for image files, and almost the same arithmetic.

## ELF (Linux, the BSDs, Solaris)

### The header: 64 bytes at the start

| Offset | Size | Field | What it says | We use it |
|---:|---:|---|---|:-:|
| 0 | 4 | magic | `0x7F` `'E'` `'L'` `'F'` | ✓ |
| 4 | 1 | EI_CLASS | 1 = 32 bit, 2 = 64 bit | ✓ |
| 5 | 1 | EI_DATA | 1 = little endian, 2 = big | ✓ |
| 6 | 1 | EI_VERSION | 1 | |
| 7 | 1 | EI_OSABI | 0 = System V, 3 = Linux | |
| 8 | 8 | padding | zeros | |
| 16 | 2 | e_type | 1 object, 2 executable, 3 shared/PIE, **4 core** | ✓ |
| 18 | 2 | e_machine | 62 = x86-64, 183 = AArch64 | |
| 20 | 4 | e_version | 1 | |
| 24 | 8 | e_entry | entry point; 0 in a core | |
| 32 | 8 | e_phoff | **where the program header table starts** | ✓ |
| 40 | 8 | e_shoff | section headers; a core has essentially none | |
| 48 | 4 | e_flags | | |
| 52 | 2 | e_ehsize | 64 | |
| 54 | 2 | e_phentsize | **size of one table entry: 56** | ✓ |
| 56 | 2 | e_phnum | **how many entries** | ✓ |
| 58 | 2 | e_shentsize | | |
| 60 | 2 | e_shnum | | |
| 62 | 2 | e_shstrndx | | |

Sections are for linkers and are not where the memory is. **Program headers** are.

### The program header table: 56 bytes per entry

| Offset | Size | Field | What it says |
|---:|---:|---|---|
| 0 | 4 | p_type | 1 = LOAD (memory), 4 = NOTE (machine state) |
| 4 | 4 | p_flags | 1 executable, 2 writable, 4 readable |
| 8 | 8 | p_offset | where these bytes are **in the file** |
| 16 | 8 | p_vaddr | where they were **in the process** |
| 24 | 8 | p_paddr | physical address; meaningless here |
| 32 | 8 | p_filesz | how many bytes were **written to the file** |
| 40 | 8 | p_memsz | how large the region was **in memory** |
| 48 | 8 | p_align | page alignment |

### Finding a byte

```
find the PT_LOAD entry with p_vaddr <= A < p_vaddr + p_filesz
offset in file = p_offset + (A - p_vaddr)
```

Compare with an image file, where it is `headerSize + A - oldBaseAddress` against one flat
region. A dump has several regions and a lookup to choose between them. That is the whole
difference.

### Holes: p_filesz can be less than p_memsz

Nothing is compressed. The file simply does not contain that part of the region.

- In executables this is `.bss`: memory that starts as zeros, so storing it would store zeros.
- In core dumps the kernel skipped it, following `/proc/<pid>/coredump_filter`, a bitmask
  choosing which kinds of mapping to write. File-backed pages are the usual omission, because
  they are already on disk in the file they came from; such regions appear with `p_filesz` of
  zero.

**An address in the missing part was there, and the dump does not say what it held.** It is not
zero and it is not the next region's byte. Reading it has to answer *absent* -- the same rule
as everywhere else here, for the same reason: this tool reads memory nobody can be asked about
any more.

For us the practical consequence is good. A Spur heap is anonymous private memory, which is
dumped by default; the VM's own code often is not, which costs nothing unless you wanted to read
its symbols out of the dump rather than off disk.

### PT_NOTE: what the machine was doing

An ordinary entry in the same table, whose bytes are a sequence of notes:

```
namesz (4) | descsz (4) | type (4) | name, padded to 4 | descriptor, padded to 4
```

The interesting ones in a Linux core carry the name `CORE`:

| type | name | what is in it |
|---:|---|---|
| 1 | NT_PRSTATUS | registers -- instruction pointer, stack pointer -- and the signal, one per thread |
| 2 | NT_FPREGSET | floating point registers |
| 3 | NT_PRPSINFO | pid, state, the command line |
| 6 | NT_AUXV | the auxiliary vector the loader was given |
| 0x46494C45 | NT_FILE | **every file-backed mapping, with its path** |

Two matter here. `NT_FILE` says which region is the VM binary and which is the image file, so
the right binary can be found for symbols and the right image identified. `NT_PRSTATUS` gives
the register state of whichever thread was stuck.

## The same idea elsewhere

| | Linux / BSD | macOS | Windows |
|---|---|---|---|
| executables | ELF | Mach-O | PE/COFF |
| dumps | ELF, `e_type` 4 | Mach-O core | Minidump (`.dmp`) |
| a region | `PT_LOAD` entry | `LC_SEGMENT_64` command | memory range in a stream |
| where it lived | `p_vaddr` | `vmaddr` | range start |
| where the bytes are | `p_offset` | `fileoff` | offset in the stream |
| how much was written | `p_filesz` | `filesize` | range size |
| region size | `p_memsz` | `vmsize` | -- |
| machine state | `PT_NOTE` | `LC_THREAD` | thread list stream |

Different parsing, same shape. That is why the reader here is split in two: a segment -- an
address, a file offset, a size written and a size in memory -- and a parser that produces them.
A Mach-O reader can produce the same segments and everything above it is unchanged.

## Getting a dump on Linux

The kernel writes one on a fatal signal, where `/proc/sys/kernel/core_pattern` says. On Ubuntu
that is usually a pipe into apport rather than a file next to the binary.

On demand, from a debugger: `gcore`, or `gdb -ex "gcore out.core"`. Yama restricts who may:
`/proc/sys/kernel/yama/ptrace_scope` of 1 -- the common default, and what is set on the work box
-- means a process may only be traced by one of its ancestors, so a debugger must have started
the VM rather than attaching to it afterwards. Zero allows attaching to anything of the same
user, and needs root to set.

macOS gates the equivalent (`task_for_pid`) through code signing, entitlements and SIP instead,
which is why lldb can attach to your own unhardened process without having started it.

## Where to check any of this

- The System V ABI, and the TIS ELF specification, for the header and program header layouts.
- `elf(5)` and `core(5)` on any Linux machine, for the same in manual page form.
- `/proc/<pid>/coredump_filter`, documented in `core(5)`, for what the kernel writes.
- `<elf.h>` on any Linux machine, for the constants as C.
- Apple's `loader.h` for Mach-O load commands; Microsoft's minidump documentation for `.dmp`.
