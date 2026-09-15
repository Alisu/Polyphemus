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
