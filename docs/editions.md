# Editions

Polyphemus runs on one host and reads some versions of Pharo. An **edition** says which, by its
name and by refusing the rest:

    Polyphemus-<host Pharo>-<host OS>-<host CPU>-for-<target Pharos>
    Polyphemus-Pharo10-Linux-x64-for-Pharo10

`PolyphemusEdition current` is the edition the loaded code is. Its name is made from what it checks,
so the two cannot drift apart.

## One branch, editions as packages

All editions live on one branch. What every edition shares -- reading Spur, the debugger, the
inspector, editing -- is written once; what differs is kept in packages of its own (per host Pharo,
per operating system), and the baseline loads the ones for its host (`spec for: #'pharo11.x'`), each
with its own VMMaker pin. A fix to shared code is made once and every edition has it.

Chosen over a branch per edition, which would keep each simple but make every shared fix a merge
into every branch -- and the branches multiply: host Pharo versions times operating systems.

## What an edition refuses

| | when | how |
|---|---|---|
| another host | loading (`BaselineOfPolyphemus>>postLoad`) | `checkHost`: Pharo major, OS, CPU |
| a running image of another Pharo | holding it (`HeldImage>>holdWithin:`) | asks `SystemVersion current major`, lets it go, refuses |
| an image file of another format | reading it | the readers' own checks (Spur 64 only) |
| a VM of another build | stages 2 and 3 | `VMVariables>>checkBuild` |

An image file's Pharo version is not checked: its format is, and the test fixtures (Candle) have no
`SystemVersion` to ask.

## Editions, and what checks them

| edition | host setup on the box | VMMaker | reads | suite |
|---|---|---|---|---|
| Polyphemus-Pharo10-Linux-x64-for-Pharo10 | `~/polyphemus` (Pharo 10, VM 9.0.22) | v10.0.0 | image files; processes and dumps of **VM 9** | full, green |
| Polyphemus-Pharo11-Linux-x64-for-Pharo10 | `~/polyphemus/pharo11` (Pharo 11 build 688, VM 10.0.5) | v10.0.5 | image files; processes and dumps of **VM 10** | full, green |

Each edition reads processes and dumps with the VMMaker its VM was generated from. VMMaker v10.0.4
and later tell old from young objects by address masks that hold only at VM 10's fixed addresses,
so v10.0.5 cannot read a VM 9 heap where it lies, and v10.0.0 does not know VM 10's split memory.
Image files are relocated when loaded, and both read them.

`bin/gate.sh` runs every edition's suite side by side (~15 min for both).

## A host setup

One directory per host, run with `WORK=<dir>` by `bin/tdd.sh` and `bin/run-tests.sh`:

1. the Pharo image and its VM, a `pharo` launcher and a `pharo-vm` link to the VM;
2. `Polyphemus` linked to the one working copy;
3. `dev.image`: the image with Polyphemus loaded by Metacello from the working copy
   (`filetree:///home/observant/polyphemus/Polyphemus`), then the repository registered in
   Iceberg (`register-repo.st`) -- the sync and the fixtures find the working copy through it;
4. `polyphemus.env`, which the runner reads: `POLYPHEMUS_TARGET_VM`, the VM target images run
   on (else the host's own), and `POLYPHEMUS_CORE`, the dump (else `pharo.core` beside the image).

Targets are explicit because they need not be the host's: the first Pharo 11 run launched its
Pharo 10 targets on VM 10.0.5 by accident, and every live test failed for a reason that was
not the host at all.

Caches are the edition's own (`/tmp/polyphemus-cache/<edition>/`, #50).

## What moving the host to Pharo 11 changed

- Pharo 11's debugger asks every context's `sourceNodeExecuted` for its `scope` as it opens, and
  asks the *method* where a pc is (`compiledCode sourceNodeForPC:`): a frame whose code cannot be
  reproduced answers an `OOPUnknownSourceNode`, and a method answers through itself compiled
  here. A block's code still answers unknown: nothing is highlighted when stepping in a block.

## VM 10 as a target: done (2026-09-27)

| | VM 10.0.5 | how |
|---|---|---|
| interrupting from outside | `interruptPending` made a local (Slang) | the watcher's own external semaphore, both VMs (`docs/reading-a-live-process.md`) |
| remembered set | behind `fromOldSpaceRememberedSet`, a `struct _VMRememberedSet` | `VMVariables>>movedAddressOf:`; in a reading, `VMRememberedSet` (`rememberedSetOf:`) |
| `endOfMemory` | gone | the memory map's `oldSpaceEnd`, or the heap walk's end |
| memory layout | new space in a mapping of its own (0x340000000), old space far above (0x10000000000), code zone and stack pages stated in `memoryMap` | `SpurRawHeap` keeps new space's own mapping, `OOPAddressTable`/`OOPSparseAddressTable` keep no gap, `isMachineCodeAddress:` asks the map |
| VMMaker | v10.0.5 builds from its memory map, with the VM's own masks | `placeSpacesIn:freeLists:` per edition |
| writing an image from a dump | v10.0.5's scavenger has a `1 halt` left in (`scavengeUnfiredEphemeronsInRememberedSet`) | resumed, as the built VM runs past it |

Every layout above was read from the libraries' DWARF debug information (`gdb -batch -ex "ptype /o
..."` on the library file, nothing run). Next: Pharo 11 images as live targets (the edition's name
will say `for-Pharo10-11` once its suite checks them).
