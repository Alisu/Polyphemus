# Patch notes

What changed from one edition to the next. The editions live on one branch (`docs/editions.md`),
so this is where the difference between them is written down. Newest first.

Each edition has three parts: what moved underneath us (Pharo, VMMaker, the VM), what we changed
in answer, and what the edition still does not do.

## Pharo 13: Polyphemus-Pharo13-Linux-x64-for-Pharo13

Host Pharo 13 (build 749, which calls itself 13.1), VMMaker v10.3.11, VM 10.3.11. Done 2026-09-27.
Small: nothing we read in memory changed.

### What moved underneath

- **VM 10.3.11.** On Linux the memory map is Pharo 12's (stack pages 0x300000000, code zone
  0x320000000, new space 0x360000000). On macOS all three moved above 0xD000000000, which the
  Mac edition will meet. The memory manager has one more variable, `maxSlotsForNewSpaceAlloc`.
- **Compiler and AST.** The AST classes are renamed from `RB*` to `OC*`; `RBParser` and
  `RBMethodNode` remain only as aliases, and are gone in Pharo 14. `CompilationContext` is
  `OCCompilationContext`. `SyntaxErrorNotification` no longer exists: a syntax error is a
  `CodeError`.
- **Packages.** `RPackageOrganizer` is `PackageOrganizer`, without `includesPackageNamed:`.
- **Scripts.** A script that names an undeclared variable no longer compiles at all.
- **The pinned image** looks for its sources as `Pharo13.1-64bit-d7c6f76.sources`: a version and
  a sha its download name does not give.

### What we changed

- The edition package: `forThisHost`, `generateWithSource` on `OCMethodNode`, and the dump writer
  wired as Pharo 12's.
- Syntax errors are caught as whatever this host signals (`AbstractReifiedMemory
  class>>syntaxErrors`); the agent's source looks it up in the target it runs in.
- The host's package organizer is asked of `PolyphemusEdition`, and the sync looks it up too.
- The sources names of the pinned images are pinned beside their downloads, not derived.
- Fixed for every edition: a test said the image written from a dump holds fewer objects than
  the dump's old space. New space is tenured into it too, and Pharo 13's dump had more survivors
  than garbage; the bound is now both spaces.

### Not yet

- Pharo 13 images only.

## Pharo 12: Polyphemus-Pharo12-Linux-x64-for-Pharo12

Host Pharo 12 (build 1519), VMMaker v10.3.2, VM 10.3.2. Done 2026-09-27.

### What moved underneath

- **Images.** `CompiledMethod` is no longer among the special objects (slot 17 is nil). A method
  trailer is now 5 bytes: a big-endian source pointer, and nothing else (`CompiledMethodTrailer`
  is gone). A source pointer names its file in its lowest bit, not in bit 24. `Class` has three
  more instance variables.
- **Compiler.** `generateWithSource` is now `generateMethod`. A syntax error no longer stops a
  parse: it leaves a faulty tree. When one is signalled it is a `CodeError`, an `Error`, and no
  longer a `SyntaxErrorNotification`. The compiler asks the class for the method it replaces. A
  statement `x ifTrue: [ ... ]` now leaves a `pushConstant: nil; pop` behind, so Pharo 12 no
  longer compiles Pharo 10's methods into Pharo 10's bytes.
- **Runtime.** Reading an undeclared variable is an error, where it answered nil.
- **Libraries.** Roassal subscribes through `announcer when:do:for:`; `OpalCompiler noPattern:` is
  deprecated.
- **VMMaker v10.3.2.** Images are written through one reader-writer that picks the format (Spur
  or composed). `CogBlockMethodSurrogate64` is gone. Perm space has two remembered sets, one more
  object on load.
- **VM 10.3.2.** The executable is position independent, so it maps above the heap. The fixed
  regions moved: stack pages at 0x300000000, code zone at 0x320000000, new space at 0x360000000.

### What we changed

- The VMMaker hooks for v10.0.4 and later moved to a package of their own,
  `Polyphemus-VMMaker-MemoryMap`, loaded by the Pharo 11 and Pharo 12 editions.
- Method trailers are read per image format (`OOPFixedMethodTrailer`, `OOPVariableMethodTrailer`),
  and so are the source file and position a pointer names.
- `CompiledMethod` is found by name when the special objects do not name it (#57). Before, every
  method of a Pharo 12 image read as a block, and every frame as `unknownSelector`.
- The class name slot is found from `Array`, not assumed.
- The compiler gets what it asks for: a `generateWithSource` shim, no prior method, globals
  answered on the class side too, faulty trees taken as syntax errors.
- The dump writer is wired per VMMaker (`wireWriterOf:`), and the Cogit is built without the
  block surrogate where there is none (#58).
- Fixed for every edition: a top frame whose pc is just past its send highlighted the next
  statement when its code was only matched by sends. It now highlights its own.
- Tests reading the Pharo 10 fixture that need the host to reproduce Pharo 10's code skip on this
  host, saying so.
- Tests that open windows hold Morphic's UI process while they change them: it drew them
  meanwhile, and Pharo 12's Roassal lost its damage rectangle to that (#56).
- Tooling: the sync reports a method that does not compile, where it counted it. The runner no
  longer calls a test that passes on its retry a flake: the retry runs in the same image (#31).

### Not yet

- Pharo 12 images only. Pharo 10 and 11 image files are read, but their code is not reproduced
  here, so temporaries go unnamed and fixes are refused.

## Pharo 11: Polyphemus-Pharo11-Linux-x64-for-Pharo10-11

Host Pharo 11 (build 688), VMMaker v10.0.5, VM 10.0.5. Done 2026-09-27.

### What moved underneath

- **VM 10.** New space has a mapping of its own (0x340000000), old space is far above it
  (0x10000000000), and the VM states where its code zone and stack pages are in `memoryMap`.
  `interruptPending` became a local, so an image can no longer be interrupted by writing it. The
  remembered set sits behind a struct, and `endOfMemory` is gone.
- **VMMaker v10.0.5.** It tells old objects from young ones by address masks that hold only at
  VM 10's addresses. `newInterpreter` is gone. The scavenger has a `1 halt` left in it. Perm
  space's remembered set is made on load.
- **Pharo 11.** Its debugger asks every context where it is as it opens, and asks the method,
  not the frame, where a pc is. It inlines `timesRepeat:` with a literal block.

### What we changed

- An image is held through a semaphore of the watcher's own, on VM 9 and VM 10 alike.
- A reading keeps new space's own mapping, and address tables leave out the gap between the
  spaces. Whether an address is machine code is asked of the memory map.
- Struct fields that moved are read where they now are (`VMVariables>>movedAddressOf:`).
- Writing an image from a dump resumes past VMMaker's halt, as the built VM runs past it.
- A frame whose code cannot be reproduced answers an unknown source node instead of failing.
- Test targets loop with `(1 to: 1000) do:`, a real send in both versions.
- Tooling: caches are per edition (#50), `bin/gate.sh` runs every edition side by side, and the
  Pharo 10 suite went from about 13 minutes to 5.

### Not yet

- Processes and dumps of VM 10 only. VM 9 needs the Pharo 10 edition.
- Nothing is highlighted when stepping in a block whose code cannot be reproduced.

## Pharo 10: Polyphemus-Pharo10-Linux-x64-for-Pharo10

Host Pharo 10, VMMaker v10.0.0, VM 9.0.22. The first edition: stages 1 to 3 as they were built.
