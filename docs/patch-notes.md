# Patch notes

What changed from one edition to the next. The editions live on one branch (`docs/editions.md`),
so this is where the difference between them is written down. Newest first.

Each edition has three parts: what moved underneath us (Pharo, VMMaker, the VM), what we changed
in answer, and what the edition still does not do.

## Since the Pharo 14 edition (all editions)

Changes to every edition at once, after `edition/pharo14`.

- **Speed pass (#44).** The fix, install and edit tests read the pinned image of the Pharo the
  edition targets, where every edition read Pharo 10's: on Pharo 11, 218 s → 169 s for those four
  classes. Pharo 11's image is pinned (build 750, then 688, its host's: see Skips). Running them there found three things: a held
  target stopped outside `do:` (`flagIn:`), Pharo 14 refusing a written image without its
  `.changes`, and a swap that changed no bytecode on Pharo 12's image.
- **Shared directories (#72).** Made until they exist, so runs side by side no longer lose the race
  after `/tmp` is emptied.
- **Memory map (#68).** A tab of the inspector drawing old space by address from raw headers:
  ~7 s to the first picture and 6 ms a pan, where the old space tab takes ~37 s and 10 s.
- **CI.** Every edition's suite runs on GitHub Actions, side by side, on each push
  (`.github/workflows/editions.yml`, `bin/ci-setup.sh`). Its first fresh clones found the
  `.filetree` of five packages ignored by git, and two runs fetching one pinned image at once
  (#74).
- **Memory map, more (#68, closed).** New space above old space at the same scale; a click undoes
  the zoom and the pan; a dump's VMMaker memory holds new space as the VM had it, where it was
  declared empty (58,012 young objects on the box's core).
- **Where a process is stuck (#36, first layer).** `Polyphemus whereIsStuck: pid`: each thread's
  system call, pc (machine code, or the library and the function holding it), and the signals
  the VM catches, from `/proc`; a running process is stopped a moment to look, and let go.
- **Intermittents.** #62 fixed: a jitted top frame of the running process lost its pc
  (`isInstructionPointer:inMethodOf:` refused machine code addresses). #31 worked around: a VM 9
  target that cannot map its heap is started once more, with a NOTE; each class's log is kept.
  #73: a written image's special objects array may move when the snapshot compacts. Two tests
  asserted where a held loop was (flagIn:, the watcher injection).
- **Skips.** The tests that name temporaries, skipped on Pharo 12 and later for the Pharo 10
  fixture, have counterparts on the edition's own image, where they run. `bin/tdd.sh` now reads
  the setup's `polyphemus.env` as `bin/run-tests.sh` does, so `warm.image` prepares the target's
  image, not Pharo 10's. A method fix test that looked for one Pharo 10 method runs on any.
  Pharo 11 now targets build 688, the build its host is made from, where it targeted 750: its
  host could not reproduce 750's methods, so the counterparts skipped there.
- **Fresh checkouts.** The blanked-context copy is built under a name of its own and renamed into
  place, so two classes building it at once both leave it whole; `SpurImageFileTest` asks for it
  rather than skipping when it is absent. A class whose own image VM 9 cannot start (#31) is
  started once more by `bin/run-tests.sh`, with a NOTE.
- **What an image is made of (#69).** `HeapCensus of: anObjectMemory`: instances and bytes per
  class, read from raw headers in one walk (the Pharo 10 image in ~2 s). Its counts match an
  independent reader of the file, whose measures of all five editions are on #69.
- **What each package owns (#69).** `PackageFootprint of: anObjectMemory`: per package, its classes
  and metaclasses, method dictionaries, methods, blocks and method state, each object counted once
  (extension methods with the class's package; what class variables keep alive is not counted). A
  class's package is read from the image: its PackageTag from Pharo 12, the longest RPackage name
  its category starts with before. Packages own 20.6 MB of Pharo 10's 57.5 MB; the 242–264 test
  packages own 6.3 MB on Pharo 11 and 6.6 MB on Pharo 14, ~11% of each image.
- **A frame being built (#17).** A core whose newest frame's method field still held stale stack
  contents (below the heap, outside the code zone) raised an MNU; that frame is now refused. The
  code zone of a VM 9 dump is codeBase to limitAddress, where it was anything below the heap.

## Pharo 14: Polyphemus-Pharo14-Linux-x64-for-Pharo14

Host Pharo 14 (build 771, not yet released), VMMaker v12.0.5-beta, VM 12.0.5-beta. Done
2026-09-28. The first new VM line since Pharo 11: a real port.

### What moved underneath

- **VM 12: frames.** Frame unification: the plain interpreter now builds base frames as Cog does,
  its caller context at the base of the stack page, and `FoxCallerContext` is gone. Its frame
  constants are renamed (`FrameSlots` is `IFrameSlots`) and only set when VMMaker initialises.
- **VM 12: Cog methods.** `picHasMNUCaseOrCMIsFullBlock` left the header bits for a word of its
  own after `selector`, and every bit after it moved down one (`gdb ptype /o CogMethod`).
  **VMMaker v12.0.5-beta's own surrogates still read the old layout**: an upstream inconsistency.
  The map of a method is walked from its `stackCheckOffset`, which they misread.
- **VM 12: symbols.** The C global `imageName` is `_imageName`. The Linux memory map is VM
  10.3's, and the W^X code zone is off on Linux.
- **The image.** Its class table is ordered differently: nil, false and true have class indexes
  2051, 2053 and 2055, where earlier images had 3075, 3077 and 3079. `Process` has two more
  instance variables, at the end. Method trailers are Pharo 12's.
- **The host.** A send's selector goes through its class's package
  (`visibleSelectorForSymbol:`). `SourceFile on:potentialLocations:` is
  `lookupFileNamed:potentialLocations:`, and an empty file is refused. `SourceFileArray` is
  `FilesSourcesManager` (still aliased in build 771, as `RBParser` is). `Smalltalk os` and its
  `environment` are deprecated for `OSPlatform current` and `OSEnvironment current`. The
  debugger asks contexts for `temporaryVariableNames`, reads them through their method's
  `debugInfo`, and has a `debuggerClientModel` for an action model. Classes are defined only with
  the fluid syntax, and categories are package tags.
- **A bug in build 771 on VM 12.0.5-beta:** any `value:value:value:value:value:` fails.

### What we changed

- The edition package: `forThisHost`, `generateWithSource` on `OCMethodNode`, the dump writer.
- `OOPStackInterpreterLayout` finds a base frame's caller where VMMaker's interpreter keeps it:
  asked of VMMaker (`FoxCallerContext` defined or not), Cog's rule otherwise.
- `OOPCogMethodSurrogate64` reads CogMethod as VM 12 lays it out, chosen where VMMaker declares
  the moved field; the Cogit takes the VM's own entry offsets from the dump.
- A heap is found by its shape, not by Pharo 10's class indexes (#61).
- Reified classes answer a package whose selectors mean what they say; compiled code answers a
  `debugInfo` reading through our contexts; contexts answer `temporaryVariableNames`.
- Lookups where the names differ: the parser (`OCParser`, `RBParser` before Pharo 13), the
  source file constructor, `_imageName`, the frame-slot constant, `OSPlatform current` and
  `OSEnvironment current`, the debugger's model.
- The stand-in `.changes` (#16) now holds one chunk, since an empty file is refused.
- The sync defines classes with the fluid syntax where the old message is gone, tags them
  there, and avoids five-argument blocks.
- Fixed for every edition: two dump tests assumed nil's class index (now: an object's class
  index is its class's hash), and the jitted-frame check's minimum is set per dump.

### Not yet

- Pharo 14 images only. A package-private selector in a target method is taken as written.
- Build 771 still has `RBParser` and `SourceFileArray` as aliases; we no longer rely on them.

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
