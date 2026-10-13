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

So the macOS counterpart of `bin/pharo-debuggable` is a **debuggable copy of the VM**: the same
binary, ad-hoc re-signed with `get-task-allow`, used to launch targets. It is also what an
attaching reader will need (below).

## Live processes: to measure

The Mach interface (`docs/reading-a-live-process.md`): `task_for_pid`, `mach_vm_read_overwrite`,
`mach_vm_region_recurse`, `thread_get_state`, `task_suspend`, through Pharo's FFI. Not measured
yet: whether a same-user reader may take the task port of a `get-task-allow` VM without root.
**Developer mode is off** on this Mac (`DevToolsSecurity -status`), so lldb asks for an admin
password to attach; enabling it is Théo's decision, not the tool's.

## Next, in order

1. A debuggable copy of the VM (re-signed with `get-task-allow`) to launch targets, and a core of
   one: what it holds, how long it takes, how big.
2. `MachOCoreDump`, answering the memory protocol, and `VMVariables` from Mach-O symbols: the
   dump classes green on macOS.
3. Live reading through the Mach interface, after measuring what it needs.
4. The `bin/` runner without `timeout` and `/proc`.
