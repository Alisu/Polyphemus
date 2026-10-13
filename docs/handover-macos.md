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

- **An observer run as root.** macOS gives root the task port of a process that is not hardened,
  which the downloaded VM is not. If it holds, a live reader (through FFI) and a core written by
  Polyphemus itself follow from it.
- **Apple's lldb** (it carries the debugger entitlement) attaching once Théo authorizes it (an
  admin password; developer mode is off on this Mac, `DevToolsSecurity -status`), then
  `process save-core`: a Mach-O core of a stock VM for Polyphemus to read.

## Next, in order

1. The `bin/` runner without `timeout`, `/proc` or `flock`, so a Mac runs the suite with the same
   tools as the box.
2. With Théo: whether root gets a stock VM's task port, and whether lldb saves a core of one.
3. `MachOCoreDump`, answering the memory protocol, and `VMVariables` from Mach-O symbols: the
   dump classes green on macOS.
4. Live reading through the Mach interface.
