# The macOS edition: where it stands

Measured on Théo's MacBook (Apple silicon, macOS 15.7, System Integrity Protection on) on
2026-10-13, branch `macos`. The setup was removed at the end of the day; everything learned is
here. Like Windows (`docs/handover-windows.md`): commit on `macos`, gated on the Mac's suite;
before `macos` reaches `stage2`, every Linux edition passes on the box.

## The edition

`Polyphemus-Pharo13-MacOS-arm64-for-Pharo13`: Pharo 13 (build 749, the image Linux pins) on
`PharoVM-v10.3.11+0.a585304b1-Darwin-arm64` (files.pharo.org/vm/pharo-spur64-headless/
Darwin-arm64/), the same VM version as Linux, with Cog's arm64 JIT. Loading Polyphemus and
VMMaker from a clone took 7 min 17 s.

- **Metacello offers no attribute for the operating system** (`#squeakCommon #pharo #'pharo13.x'
  #'pharo13.0.x'` on the Mac). The baseline adds one (`customProjectAttributes`: `#'macos-arm64'`,
  `#'linux-x64'`) and picks a `Polyphemus-Host-*` package by it; each edition's `forThisHost` asks
  `PolyphemusMadeFor` which host it is made for. Windows will need `Polyphemus-Host-Windows-x64`.
- The VM is only ad-hoc signed (`flags=0x20002(adhoc,linker-signed)`, no hardened runtime, no
  entitlements).

## The suite on macOS

98 classes, 778 tests: **0 failures, 0 errors, 139 skipped**, in 6 minutes (one class at a time;
a two-edition gate takes ~40 min on the box). Everything that reads image files works unchanged:
stage 1, the debugger on image files, the census, packages, the MCP server's image tools.

What skips, and why:

| Classes | Skipped | Why |
|---|---|---|
| `LinuxProcessMemoryTest`, `StuckReportTest`, the `Live*` classes, `WatcherInjectionTest`, `LinuxObservationPermissionTest`, `PolyphemusMCPLiveToolsTest` | all | no `/proc` |
| `SpurDumpedMemoryTest`, `StackOfADumpTest`, `SpurImageFromDumpTest`, `MachineCodeCoreTest`, one each of `PolyphemusTest` and `PolyphemusMCPProcessToolsTest` | all | no core; Linux cores are ELF |
| `VMVariablesTest` | all | reads the VM's ELF symbols |
| 5 of `SchedulerOnRealImageTest`, 2 of `ProcessStackOnRealImageTest` | 7 | as on Linux Pharo 12+: the host does not reproduce Pharo 10's code |

Two things the first run found, fixed on `macos`: there is **no `flock`** (the pinned-image fetch
of #74 died at once) and **no `timeout`** (the `bin/` scripts use it; a Mac runner bounded runs
with `perl -e 'alarm N; exec @ARGV'`). A failed fetch also retried forever; it now fails once,
naming the image.

## Cores: only for debuggable processes, and big

- **macOS writes a core only for a process signed with `com.apple.security.get-task-allow`.**
  Measured with a three-line C program that aborts: built plain, no core; the same binary
  ad-hoc re-signed with that entitlement, a core in `/cores/core.<pid>`
  (`kern.coredump=1`, `kern.corefile=/cores/core.%P`, `/cores` writable by group admin,
  `ulimit -c unlimited` in the target's shell). The downloaded Pharo VM has no entitlement: a
  `SIGABRT` killed it and left nothing (no `crash.dmp`, no report).
- **A core is about 5 GB even for that tiny program** (4,923,719,696 bytes): macOS includes the
  shared libraries. A reader must seek in it, never load it.
- The core is Mach-O (`MH_CORE`): `LC_SEGMENT_64` per region (the memory protocol's regions) and
  `LC_THREAD` per thread (arm64 registers, for #17).
- **The VM keeps its symbols**: `libPharoVMCore.dylib` has `_stackPage`, `_framePointer`,
  `_stackPointer`, `_instructionPointer`, `_specialObjectsOop` in its symbol table, so
  `VMVariables` can find them as it does from ELF. `codeZoneStart` is not under that name: to
  look up.

**The target stays stock** (Théo, 2026-10-13): Polyphemus is used on the VM people run, as
downloaded, so nothing may depend on re-signing or otherwise instrumenting it. What reading one
needs falls on the observer: the person using Polyphemus grants it the right to look, as on
Linux, where reading another user's VM with `ptrace_scope` at 1 also takes privilege
(`bin/pharo-debuggable` is the tests' way round that, not the users').

## Live processes and cores of a stock VM: to measure, with Théo's password

`ptrace` exists on macOS but cannot read memory or registers: those go through Mach, behind the
task port (`task_for_pid`, `mach_vm_read_overwrite`, `mach_vm_region_recurse`,
`thread_get_state`, `task_suspend`; `docs/reading-a-live-process.md`). `ptrace` attach is gated
the same way, and a process may refuse it (`PT_DENY_ATTACH`). Two ways to a stock VM, both to
measure, both needing Théo:

- **An observer run as root: measured, it works** (2026-10-13). A small C probe, run with `sudo`
  on a stock, idle Pharo 13 VM (the download, not re-signed): `task_for_pid` succeeded; 124
  regions (112 readable; 390 GB mapped, most of it reserved address space); a word read from the
  biggest writable region (128 MB at `0x110000000`); 3 threads. macOS's task policy grants the
  port when the target is not hardened, has `get-task-allow`, or the caller is a declared
  debugger; the downloaded VM is not hardened, so root suffices. The probe carried an ad-hoc
  `com.apple.security.cs.debugger` entitlement, which AMFI says it does not honor ("adhoc signed
  or signed by an unknown certificate chain"), so it is not what got the port. Two earlier runs
  answered `(os/kern) failure (5)` only because their targets had already exited.
- **Apple's lldb** (it carries the debugger entitlement) attaching once Théo authorizes it (an
  admin password; developer mode is off on this Mac, `DevToolsSecurity -status`), then
  `process save-core`: a Mach-O core of a stock VM for Polyphemus to read.
- **Apple's `debugserver`**, the helper lldb attaches through, is Apple-signed as a debugger and
  speaks GDB's remote protocol (memory, registers, threads): a live reader could ask it, with no
  certificate of ours. To try after lldb.

## Reading a live VM: done (2026-10-13)

`MacProcessMemory` (`Polyphemus-Host-MacOS-arm64`) answers the memory protocol through the task
port; `VMVariables` reads the VM's variables from `libPharoVMCore.dylib`'s Mach-O symbols
(`MachOSharedObject`), so the VM states where nil (`0x10000000000`) and new space
(`0xF000000000`, not Linux's `0x360000000`) are. As root, a stock Pharo 13 VM is read as
`Polyphemus readProcess:` reads one on Linux: everything reified in 7 s, 17 processes with their
states and frames (`MacProcessMemoryTest`, all green as root, the root test skipped otherwise).

Learned on the way: without the VM's variables the largest region was taken for the heap, and
held a table that only looked like nil, false and true; one `mach_vm_read` per header took 12 s
to find a 1.3 GB heap (now 64 KB blocks); listing processes needs everything reified first, as
`readProcess:` does; reading Pharo's own memory is no test of a live reader, since it changes
while read.

## Next, in order

1. ~~The running process's newest frames, from its thread's registers~~ **Done**: Cog keeps
   its frame pointer in x29 and its Smalltalk stack pointer in x28 on arm64 (sp is C's;
   `CogARMv8Compiler class>>initializeAbstractRegisters`), so `VMVariables cogPointersIn:` names
   them by processor. A spinning stock VM stopped in machine code reads its running process
   from them, as root. Found on the way: the cogit was x86-64's, whose map counts bytes; arm64's
   counts four-byte instructions, so every machine code pc mapped wrong. Each reader now says
   its `processor` and the cogit takes that back end (`OOPCogLayout backEndFor:`); the tests
   failed with x86-64's, measured. An idle VM's processes hold no machine code frame.
2. ~~`Polyphemus readProcess:` and the MCP's `open_process` choosing the reader by host~~ **Done**
   (`PolyphemusMadeFor current processMemoryClass`; held still with `SIGSTOP` while read).
   Whether a VM is quiet when stopped is not measured on macOS yet. Measured: macOS refuses
   even root the task port of its own binaries (`/bin/sleep`).
3. `where_stuck` on macOS: each thread's state and pc (`task_threads`, `thread_get_state`).
4. ~~A core of a stock VM~~ **Done**: `Polyphemus dumpProcess:to:` writes one through the task
   port as an ELF core (`ElfCoreWriter`, shared with Linux; e_machine AArch64), and
   `readCoreDump:` reads it back with its processes, as root. It leaves out what lies in
   submaps: macOS maps the shared libraries cache there, 4.7 of 5.5 GB readable in a Pharo
   process. Each thread's registers go in as `NT_PRSTATUS` notes (aarch64 layout; read back by
   `ElfCoreDump>>threadRegisters`, every stack pointer inside the core, as root). Then the hold,
   stepping and editing.

Measured on this VM (v10.3.11, Darwin arm64): `value:value:value:value:value:`'s primitive
fails, as on Pharo 14's VM 12.0.5-beta: pass five values with `valueWithArguments:`.
