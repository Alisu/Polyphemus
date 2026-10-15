# The macOS edition

Polyphemus on macOS, Apple silicon: measured on Théo's MacBook (macOS 15.7, System Integrity
Protection on) on 2026-10-13, on `stage2` since 2026-10-14. No Mac setup is kept: **macOS runs in
CI**, job `macos` of `.github/workflows/editions.yml` (macos-15). Open: #80 (Pharo 10's root
reading), #81 (macOS's own cores), #82 (the MCP server on a Mac).

## Where it runs

`bin/ci-setup.sh` builds each setup from the Darwin-arm64 builds of the VMs Linux pins
(files.pharo.org/vm/pharo-spur64-headless/Darwin-arm64/), with Cog's arm64 JIT. The suite runs,
then the classes that read another process, under `sudo`.

| Pharo | VM | Suite | Root tests (`MacProcessMemoryTest`, `MacStuckReportTest`, `MacHoldTest`, `MacMCPToolsTest`) |
|---|---|---|---|
| 10 | `PharoVM-9.0.22-421845e1` | yes | not yet: VM 9 keeps new space apart from old space here, and its heap does not read as on Linux (#80) |
| 11 | `PharoVM-10.0.5-2757766f` | — | — : this VM does not start on macOS 15 (`allocateStackPages`: its stack wanted at `0x280000000`, taken) |
| 12 | `PharoVM-10.3.2-b8793dd2` | yes | yes |
| 13 | `PharoVM-v10.3.11+0.a585304b1` | yes | yes |
| 14 | `PharoVM-v12.0.5-beta+0.7884d2853` | yes | yes |

The runner has System Integrity Protection **off** (`csrutil status`, printed by the job): root
reads even `/bin/sleep` there, which a Mac with it on refuses to anyone, and
`testASystemProcessIsRefusedEvenToRoot` expects the refusal each case gives.

**The host package.** Metacello offers no attribute for the operating system, so the baseline
adds one (`customProjectAttributes`: `#'macos-arm64'`, `#'linux-x64'`) and loads a
`Polyphemus-Host-*` package by it. `PolyphemusMadeFor current` answers this host's process reader
(`MacProcessMemory`) and stuck report (`MacStuckReport`).

**The `bin/` scripts** run on macOS too: there is no `flock` (the pinned-image fetch does without)
and no `timeout` (`bin/portable.sh` stands in, with perl), and bash is 3.2 (no `mapfile`).

## What reading a stock VM takes

**The target stays stock** (Théo, 2026-10-13): Polyphemus is used on the VM people run, as
downloaded, so nothing may depend on re-signing or otherwise instrumenting it. The right to look
falls on the observer, run as **root**. macOS grants a task port when the target is not hardened,
has `get-task-allow`, or the caller is a declared debugger; the downloaded VM is only ad-hoc
signed (`flags=0x20002(adhoc,linker-signed)`, no hardened runtime, no entitlements), so root
suffices. An ad-hoc `com.apple.security.cs.debugger` entitlement is not honored by AMFI.

`ptrace` exists on macOS but reads neither memory nor registers; those go through Mach, behind
the task port (`task_for_pid`, `mach_vm_read_overwrite`, `mach_vm_region_recurse`,
`thread_get_state`, `thread_info`, `mach_vm_write`).

## What works, and how

- **Memory.** `MacProcessMemory` answers the memory protocol through the task port, in 64 KB
  blocks (one `mach_vm_read` per object header took 12 s to find a 1.3 GB heap). The system's
  shared libraries cache is mapped as submaps (4.7 of 5.5 GB readable in a Pharo process); a core
  leaves it out. A process that ended while read answers no region at all and is refused as such.
- **The VM's variables** come from `libPharoVMCore.dylib`'s Mach-O symbols (`MachOSharedObject`,
  leading `_` stripped; its UUID as build id). The VM states where nil is (`0x10000000000` on
  VM 10.3.11) and new space (`0xF000000000`, not Linux's `0x360000000`); without them the largest
  region was taken for the heap, and held a table that only looked like nil, false and true.
- **New space.** The macOS VM names no `eden` (it does name `pastSpace`, `futureSpace`,
  `freeStart`, `scavengeThreshold`): `VMVariables>>edenBounds` takes eden from where the higher
  survivor space ends to where new space ends (`newSpaceEnd`; VM 9's `newSpaceLimit`), as VMMaker
  lays them out, checked against the stated eden on Linux. Allocating from outside stays below
  `scavengeThreshold`, as the VM's own allocator does.
- **The running process.** Cog on arm64 keeps its frame pointer in x29 and its Smalltalk stack
  pointer in x28 (sp is C's; `CogARMv8Compiler class>>initializeAbstractRegisters`):
  `VMVariables cogPointersIn:` names them by processor, so a VM stopped in machine code reads its
  newest frames from that thread's registers. A machine code pc maps to a bytecode pc through
  Cog's map counted in four-byte instructions (`OOPCogLayout backEndFor:`); with x86-64's bytes,
  every one mapped wrong.
- **Holding still, at a quiet moment.** `SIGSTOP` while read; quiet when the main thread waits in
  the kernel, its pc just after `svc #0x80` (`MacProcessMemory>>isQuiet`); stopped in machine
  code, it is not.
- **Where it is stuck.** `MacStuckReport`: each thread's run state (`thread_info`) and pc; a thread
  waiting in the kernel has its pc in a `libsystem_kernel` stub, named by `dladdr` in the
  observer, since the shared libraries lie at the same addresses in every process. An idle VM's
  main thread waits in `kevent`, its heartbeat in `semaphore_wait_trap`. Signals caught come from
  `sysctl`'s `kinfo_proc` (648 bytes, `p_sigcatch` at 236): SIGHUP SIGQUIT SIGILL SIGTRAP SIGABRT
  SIGEMT SIGFPE SIGBUS SIGSEGV SIGSYS SIGALRM SIGTERM SIGUSR1.
- **Cores of a running VM.** `Polyphemus dumpProcess:to:` writes an ELF core (`ElfCoreWriter`,
  shared with Linux; e_machine AArch64, each thread's registers as `NT_PRSTATUS` notes), which
  `readCoreDump:` reads back.
- **Writing, holding, stepping, fixing.** `mach_vm_write`, refused unless the VM is stopped;
  signalling an external semaphore of a running VM; a watcher put into a stock VM's image (#27),
  then held, stepped (Step Over) and a jitted method fixed as the debugger accepts it. The VM is
  untouched; only the image gains the watcher.

## macOS's own cores (not read, #81)

macOS writes a core only for a process signed with `com.apple.security.get-task-allow`: a stock
Pharo VM killed by `SIGABRT` leaves nothing. A core is about 5 GB even for a tiny program (the
shared libraries are in it), Mach-O (`MH_CORE`: `LC_SEGMENT_64` per region, `LC_THREAD` per
thread). lldb's `process save-core`, after an admin authorizes attaching, would give one of a
stock VM; Apple's `debugserver` speaks GDB's remote protocol and could serve a live reader.

## Measured on these VMs

`value:value:value:value:value:`'s primitive fails on VM 10.3.11 (as on Pharo 14's 12.0.5-beta):
pass five values with `valueWithArguments:`. Calling the VM's own `getOldSpaceStart` through FFI
crashed Pharo 12 to 14, and Pharo 10's `PointerUtils` gives no pinned object's address: the tests
check nil as the special objects array's first slot instead. Pharo 14's macOS VM has no libgit2
and says so before an evaluated answer.
