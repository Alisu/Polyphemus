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

| edition | status | suite runs on |
|---|---|---|
| Polyphemus-Pharo10-Linux-x64-for-Pharo10 | the one there is | the Ubuntu box |

Next, in order: a Pharo 11 host (VMMaker from the v10 line, #33), then other operating systems.
