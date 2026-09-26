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

| edition | host setup on the box | VMMaker | suite |
|---|---|---|---|
| Polyphemus-Pharo10-Linux-x64-for-Pharo10 | `~/polyphemus` (Pharo 10, VM 9.0.22) | v10.0.0 | full |
| Polyphemus-Pharo11-Linux-x64-for-Pharo10 | `~/polyphemus/pharo11` (Pharo 11 build 688, VM 10.0.5) | v10.0.0 | full |

The Pharo 11 edition reads what the Pharo 10 one reads: the same Pharo 10 targets, on their own
VM 9.0.22. VMMaker v10.0.0 was itself developed on a Pharo 11 image (pharo-vm's
`cmake/vmmaker.cmake`), which is why it loads there unchanged.

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

## Next: VM 10 as a target

VM 10.0.5 no longer has five of the symbols stages 2 and 3 read: `interruptPending`,
`endOfMemory`, `rememberedSet`, `rememberedSetSize`, `rememberedSetLimit`. The remembered set is
now behind pointers to structs (`fromOldSpaceRememberedSet`, `fromPermSpaceRememberedSet`), made
ready for perm space. Reading a VM 10 process needs the variables named per VM build, and those
structs' layouts; then Pharo 11 images as targets, then VMMaker v10.2.1.
