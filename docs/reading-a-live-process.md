# Reading the memory of a process that is still running

A dump is a file and needs no permission. A living process needs the operating system's consent,
and each one grants it differently. This is what the three do, and where that knowledge belongs
in the code.

## The three mechanisms

| | Linux | macOS | Windows |
|---|---|---|---|
| get access | `ptrace(PTRACE_ATTACH)` or `PTRACE_SEIZE` | `task_for_pid()`, answering a task port | `OpenProcess` with `PROCESS_VM_READ`, `_WRITE`, `_OPERATION` |
| read | `process_vm_readv`, or `/proc/<pid>/mem` | `mach_vm_read_overwrite` | `ReadProcessMemory` |
| write | `process_vm_writev`, `PTRACE_POKEDATA`, or `/proc/<pid>/mem` | `mach_vm_write` | `WriteProcessMemory` |
| what is mapped | `/proc/<pid>/maps` | `mach_vm_region_recurse` | `VirtualQueryEx` |
| make a page writable | `mprotect` through ptrace | `mach_vm_protect` | `VirtualProtectEx` |
| registers | `PTRACE_GETREGS` | `thread_get_state` | `GetThreadContext` |
| hold it still | `SIGSTOP`, or a ptrace stop | `task_suspend` | `SuspendThread`, `DebugActiveProcess` |
| who is allowed | Yama `ptrace_scope`, `CAP_SYS_PTRACE` | SIP, code signing, the debugger entitlement | `SeDebugPrivilege`, and not needed for your own processes |

macOS is the one that surprises. `ptrace` exists there but its read and write requests do not do
what they do on Linux; the real interface is Mach ports, which is why a debugger needs
`com.apple.security.cs.debugger` and why System Integrity Protection can refuse regardless. It is
also why lldb can attach to a process it did not start, where gdb on Linux cannot: the gate is a
signed entitlement rather than a parent-child rule.

## On Linux this needs no FFI at all

`/proc/<pid>/maps` is a text file listing every mapped region with its addresses, permissions and
backing file. `/proc/<pid>/mem` is a file whose offsets *are* virtual addresses: seek to the
address, read the bytes.

Pharo reads both with ordinary file streams. So the live path on Linux is the same shape as the
dump path -- one takes its regions from an ELF program header table, the other from a text file,
and both answer *give me N bytes at address A*.

The permission check happens when `/proc/<pid>/mem` is opened, so Yama applies there exactly as
it does to a debugger: with `ptrace_scope` at 1, only an ancestor may open it.

macOS and Windows have no such file interface. Those need calls into `mach_vm_read_overwrite` or
`ReadProcessMemory` through UFFI -- real work, and platform specific, which is a reason to leave
them until something needs them.

## Where the difference belongs in the code

Today there is no operating system knowledge in Polyphemus at all, beyond two guards in test
resources that skip an image download on Windows. This would be the first, so it is worth putting
in one place rather than spreading it.

Everything that reads memory here already goes through three messages:

```smalltalk
hasAddress: anAddress
bytesAt: anAddress count: aCount
unsignedAt: anAddress size: aCount
```

`ElfCoreDump` answers them from a file. `ByteArrayAddressSpace` answers them from bytes in hand.
A `LinuxProcessMemory` would answer them from `/proc/<pid>/mem`, and a Mach or Windows one
through FFI. Nothing above that -- not the heap scanner, not the reified memory, none of stage
one -- ever learns which it is holding.

So: **no strategy layer, no platform classes threaded through the design.** One small protocol,
several implementations, and the operating system stops at the boundary. The only other place it
leaks in is *producing* a dump -- gdb, lldb, procdump -- and that is tooling for `bin/` and for
these notes, not something the object model should know.

## Two things to be careful about

**A running process gives a torn read.** Regions change while you read them, and catching a
collection half way through yields a heap that never existed at any instant. Stopping the process
first costs nothing and makes the reading mean something. For an image that is already wedged it
matters less -- it is not making progress -- but the garbage collector may still have been caught
mid-cycle when it wedged.

**Writing is a different permission from reading, and a different risk.** Reading a stopped
process cannot hurt it. Writing to one can, and writing to a *running* one almost certainly will.

## Noted for later, not now

Perm space holds objects that never move. That makes it the natural place to put something the VM
can be made to reach -- a hook to trap it from outside, rather than waiting for it to arrive at a
safepoint of its own accord. Recorded because it is a good idea and because perm space is the
reason it would work; not pursued, and not part of stage two.

## Reading a process that is still running, from Pharo, with no foreign call

`LinuxProcessMemory` answers the same three messages `ElfCoreDump` does, and the same
`loadableSegments`, so `SpurDumpedMemory` takes one exactly where it takes a core file and
nothing above it learns the difference.

It needs no debugger, no ptrace, and **no FFI**:

- `/proc/<pid>/maps` is a text file listing every mapped region. Pharo reads it with
  `#contents`.
- `/proc/<pid>/mem` is a file whose offsets **are** virtual addresses. Seek to the address,
  read the bytes.

```smalltalk
SpurDumpedMemory on: (LinuxProcessMemory on: somePid)
```

**Tried on this very image**, which is the strongest form of the demonstration: the tool found
the heap of the virtual machine it was itself running on, walked **2,914,229 objects**, found the
special objects array and named the class of the first object -- while running.

And the ladder reported something true about that: the `freeSpace` rung **failed**. The heap was
being allocated into while it was read, so the allocator's lists and a walk over the objects do
not add up to the same free space. That is a torn read, it is exactly what the checks exist to
notice, and it is why anything serious stops the process first.

Two things the operating system decides, not us. Yama's `ptrace_scope` is 1 on most machines, so
`/proc/<pid>/mem` may only be opened by an **ancestor** of the process: read your own, or read
one you started. And `[vvar]` and `[vsyscall]` are mapped and look readable but refuse to be
read, so they are left out of the map rather than reported later as damage that is not there.

### What this means for taking dumps

`bin/take-dump.sh` exists because a dump had to be produced by gdb from outside. For a process
we can open, that step is no longer needed at all -- the heap can be read where it lies, and
`SpurDumpedMemory` does not care which it was given. The script stays for the case it was
written for: a virtual machine that has already died, whose core the kernel wrote.

Spawning a target from Pharo, so that Yama's ancestor rule is satisfied, needs only `LibC`
`system:`, which this image already has; getting the child's process id back is the one awkward
part, since without a subprocess library it has to come through a file.

## Choosing a process, and being told why you cannot have it

`LinuxProcessMemory on: aPid` either answers a reader or refuses, and the refusal says which of
three different things was wrong:

| Reason | What it means |
|---|---|
| `#noSuchProcess` | nothing is running under that number |
| `#notAPharoVirtualMachine` | something is, but it is not a Pharo virtual machine |
| `#theOperatingSystemRefused` | it is, and the kernel will not let us look at it |

The last two matter more than they look. Reading some other program's memory as though it held a
Spur heap finds nothing at best and something at worst, so a process that is not a virtual machine
is refused before anything is read. And **Pharo reports a refused open of `/proc/<pid>/mem` as the
file not existing** -- it does exist; we are simply not allowed it -- so told the truth you look
for a permission, and told Pharo's version you look for a process that is right in front of you.

Whether it is a virtual machine is asked of `/proc/<pid>/cmdline`, which can be read even when the
memory cannot, so a process we may not touch is still refused for the right reason. A command line
is a name and names can lie; the honest confirmation is that a Spur heap is found inside, which is
what `SpurDumpedMemory` does next and what this whole tool is for.

`LinuxProcessMemory pharoProcesses` lists what is available as pid -> command line, because
someone choosing a number needs something to choose from.

## Yama, and why starting the target does not get round it

`ptrace_scope` is 1 on this box and on most machines: only an **ancestor** may read another
process. `LinuxProcessMemory ptraceScope` answers it.

The documented way round that is to start the target yourself, which is exactly why
`bin/take-dump.sh` runs the virtual machine under gdb instead of attaching to one already going.
From Pharo it does not work, and the reason was measured rather than guessed:

> `LibC` can only run a command through a shell. A command backgrounded with `&` outlives that
> shell, and the moment the shell exits the child is **reparented to init**. We stop being its
> ancestor, and the kernel refuses its memory. A `sleep` started this way reads as unreadable a
> moment later.

Keeping a child a child needs a real fork and exec: OSSubprocess, or a foreign call to
`posix_spawn`. Neither is in this image, and neither is needed for *reading* -- that is the part
that needs nothing at all.

So, to read an image that is already running, one of:

- **`sudo sysctl kernel.yama.ptrace_scope=0`** on a machine you own, which is what debuggers ask
  for anyway, and then any process of the same user can be read;
- run the reading image as root;
- load OSSubprocess, and start the target from Pharo so that it really is a child.

## Taking a dump from Pharo

`#writeDumpTo:` writes what it can read as an **ELF core** -- the same thing `gcore` produces, and
what `ElfCoreDump` already reads. So a dump can be taken without a debugger, of any process we are
allowed to read, and read back by the reader we already had. There is a round-trip test: bytes out
and bytes back have to agree.

What it does not write is the notes. A real core carries every thread's registers in a `PT_NOTE`
segment, and those are not ours to read out of `/proc`. Nothing in stage two needs them yet; the
frame pointer of the running thread is the obvious thing that will.
