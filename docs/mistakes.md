# Mistakes made here, and what to do instead

Every one of these cost real time. They are written down so the next session does not pay
for them again. Each entry is: what was done, what happened, and the rule.

## Reading an image

**Assuming class names.** Looked for `Process` and `ProcessorScheduler`. The candle image
calls them `PCProcess` and `PCProcessorScheduler`, so nothing was found and a heap scan
answered zero.
→ **Navigate by slot, and identify by class identity, never by name.** `allReifiedProcesses`
finds processes as instances of the class of the running process, which works on both.

**Assuming the scheduler knows the processes.** Walking the priority queues finds 3 of the 8
processes in a real image; four wait in `Semaphore` queues and one is the running process,
which is in no queue at all.
→ **Scan the heap.** The scheduler is a starting point, not an inventory.

**Assuming the sender slot holds the caller.** For a *married* context it holds that
context's own frame pointer, as a small integer. Following it returned the same context and
the cycle check reported a loop.
→ **Check `isMarriedContext:` first.** In a snapshot there should be none.

**Booting the image instead of reading it.** Opening ran the whole VM startup, including
`loadInitialContext`, which marries the running process' context to a frame. Its stack then
looked one frame deep when the file holds three.
→ **`setUpForResourceMarrying: false`** for stage one. Stage two wants the frames.

**Taking the first `*.sources` in the directory.** The resources directory holds several
images, so a Pharo 11 sources file was handed to a Pharo 10 image. It answers text, just not
the right text: the failure is silent.
→ **Match source and changes files by the image's own name.**

**Resolving names in the host image.** `bindingOf:` fell back to `self class environment`, so
a name in the snapshot's source bound to a class of *our* image that merely shares its name.
→ **Resolve in the image being read.** Its `Smalltalk` is at special objects slot 9, and its
`SystemDictionary` holds the bindings. Answer nil when a name is absent; nil is honest.

**Changing Pharo's semantics while relocating them.** The debugger reads source against the
receiver's class; when patching it for snapshots, the class owning the *method* was used
instead. Both are in the snapshot, but they differ for inherited methods.
→ **Keep the rule, change only which image answers it**: `receiver oopClass`.

**Double reification.** `instancesOop` was assumed to answer raw addresses, and each was
passed to `reifyOop:`, which then did arithmetic on an object.
→ It answers **already reified** objects.

**Following a compiled block's literals.** Collecting the blocks of a method by walking
literals hangs: the **last literal of a compiled block is the code it is installed in**, so
the walk goes block → method → block forever.
→ Drop that last literal, and keep a visited set anyway: a corrupted file owes us nothing.

**Blaming the other side of a comparison.** Mapping a pc to a line needs the method's pc map,
which the file does not carry, so the source was recompiled here against the reified class.
The bytecodes came out different — 42 against 44, differing from the eleventh — and that was
written down as a fact about Pharo: *recompiling does not reproduce the code, so a pc map from
it would point at the wrong line, so stage one cannot highlight anything*. It went into three
documents as settled.

Both halves were **our own bugs**. Globals were wrapped as `LiteralVariable`, so the compiler
pushed them as constants where the image pushes bindings. Each lookup wrapped a *new* binding
object, so a method naming `Smalltalk` twice got two literals where the image has one, and
every literal index after it shifted. And `endPC` counted the method's trailer as code, which
is where the spare bytes came from.

With those fixed, **all 27 method frames of the pinned image recompile byte for byte**.
→ When two things that should agree do not, suspect your own side first, and say what was
checked rather than what it means. "The bytecodes differ" was true; "Pharo's compiler does not
reproduce them" was not, and only the second one got written down.

**Guarding only the corruption you expected.** The process report checked whether a
suspended context *was a context*, inside a rescue — but read the slot **outside** it. Against
an image whose slot was blanked for real, the read raised `KeyNotFound: key 5404`, naming a
class index, from under a walk that was supposed to be reporting damage. Every check that
handled injected corruption passed; the first genuinely damaged file broke three of them.
→ Read every slot of an image you did not write through `readSlot:of:ifUnreadable:`, and make
the unreadable case **a line in the report**. Corruption injected through our own API and put
back in an `ensure:` only ever proves we can read what we just wrote.

**Reading a Spur image header as words.** The first two fields are **32 bit** — version and
header size — and the rest are words. Read as words they come back as one number, `549755881909`,
and every offset derived from it pointed past the end of the file.
→ Version and header size are 4 bytes each, then `dataSize`, `oldBaseAddress` and
`specialObjectsOop` at 8, 16 and 24. See `docs/image-facts.md`.

**Analysing decompiled text.** `sourceCode` falls back to a decompilation when the source is
gone, and the decompiler calls the temporaries `arg1` and `tmp1`. Analysing that names
variables nobody ever wrote.
→ Analyse **real source only** (`getSourceFromFile`), and answer nothing when there is none.

## Reusing what already exists

**Re-deriving the method trailer.** Several probes went into working out how to decode a
method's source pointer. The `hackDebugger` branch already had `oopSize`, raw byte access,
`trailer`, `sourcePointer` and a `sourceCode` covering embedded source, a source pointer and
decompilation. It had to be pointed out twice.
→ **Look at the other branches before deriving anything**, and say plainly when their code
does not fit rather than quietly rewriting it.

**Porting code without checking what it assumed.** The ported context getters read instance
variables that are only filled when a frame is married, so they answered nil for snapshots.
→ Porting means **reading what the code assumes**, not only what it does.

## Borrowing Pharo's own tools

**Scopes are compared by identity.** `LocalVariable>>readInContext:` asks the context for its
scope and compares it with the one the variable came from. Analysing the same source twice
gives two scopes that look identical and are not the same object, so every read walked out
of the scope and answered nil: the names were right and every value was nil.
→ **Analyse once per frame and keep the result**, and read a variable only in the frame whose
own scope declares it. It also has to be kept for speed: an analysis costs about a second,
and a debugger asks once per variable shown.

**Deciding which frame owns a variable by its scope alone.** "Read it in the frame whose scope
declares it" is right for arguments and temporaries and wrong for a captured one: the method's
scope declares it, but a block that reads it is handed a *copy of the vector* it lives in, so
the block's frame is the one holding it — especially when the block was forked and the
declaring frame belongs to another process. The name showed in the list and reading it raised.
→ Ask whether the frame **holds** the variable, not whether it declares it: for a vector
temporary that means looking for the vector under the compiler's own name for it in this
frame's scope.

**Comparing a reified object with an object of this image.** `=` sent `#address` to whatever
it was given, so comparing an oop with anything of ours raised. Reified objects go straight
into this image's tooling, which compares them with whatever it likes — the compiler asks
whether a message node's receiver is `Halt`, an inspector compares against nil. The
doesNotUnderstand surfaced two layers away as semantic analysis failing, which read on screen
as *this method has no temporaries*.
→ `=` answers false for anything that is not an oop, and never raises.

**Being right and looking wrong.** `bindingOf:` answered a `LiteralVariable`, which is the
right binding with the right value. The source pane asks a variable `isGlobalVariable`, which
that class answers false to, so `Semaphore` and `Processor` were painted red — the colour for
a name that resolves to nothing. Nobody reading the screen could tell the difference.
→ Hand the tooling the **class it expects** (`GlobalVariable`), and check what it *shows*, not
only what it answers. The bug was found by a user looking at a screenshot, not by a test.

**A rescue that hid a typo.** `numArgs` sent `oopNumberOfArgs`, which does not exist — the
accessor is `oopNumberOfArguments`. Inside a guard, that turned into "this block does not
match its source", and block frames quietly showed no names at all.
→ When a guarded path answers *no* for everything, **count the reasons** before believing it.
One run that tallied why each of the 20 block frames failed found it immediately.

**Answering nil for "I could not read it".** nil is a value a temporary genuinely holds, so a
debugger cannot tell the two apart.
→ **Raise.** The inspector already catches it and shows `cannot read <name>`.

## Pharo, headless

**Scripts that never end.** The `st` command line handler does not quit by itself, so every
test class looked like it timed out at 150 seconds when the tests had finished in under a
second.
→ End every script with `Smalltalk exitSuccess`, or `Smalltalk snapshot: true andQuit: true`
to save.

**Unhandled errors hang.** There is no debugger to open, so the process sits there. One
`PackageOrganizer` (which is `RPackageOrganizer` in Pharo 10) cost fifteen minutes of
"the tests are hanging".
→ **Wrap every snippet in `on: Error do:`** and print the error.

**Compiling inside a test.** Compiling asks for the author's initials, and the test execution
environment reports that prompt as an error — in *every* test of the run, not just the one
compiling.
→ Never compile from a test or a fixture. Pass values instead: a class instance variable did
what compiling a method was doing.

**Catching `Exception` in a test runner.** That swallows `ProvideAnswerNotification`, which is
resumable and harmless, and every test was reported as failed.
→ Catch `Error`, and `TestFailure` separately. `TestFailure` is not an `Error`.

**The ten second watchdog.** `TestCase>>defaultTimeLimit` fired in the middle of a fixture
that loads an image, and surfaced as `#oop` being sent to `TestTookTooMuchTime` by an
unrelated error handler.
→ Give image-loading tests a real limit (`AbstractInspectorsTest>>defaultTimeLimit`, 5 min).

**Overriding `at:` on a compiled method.** It means "the bytecode at this pc" for the bytecode
tools, and "the nth raw byte" for the trailer decoder. Making it one broke the other; removing
it broke the first.
→ Keep `at:` as the bytecode accessor, add **`rawByteAt:`**, and give the trailer decoder a
byte view object.

**Spec display blocks set too late.** `display:` after `items:`, or from a selection handler,
never reaches the widget: the list renders `printString`.
→ Set display blocks in `initializePresenters`, before the window is built.

**Smalltalk syntax slips that cost a round trip each.** `"text"` is a comment, not a string.
`text: x ifNil: [y]` parses as `text:ifNil:`. `first:thenDo:` does not exist on `Array` in
Pharo 10.

**Reading a block's bytecodes with `at:`.** On a method `at:` answers the bytecode at a pc; on
a compiled block it answers the nth raw byte, so a block's code read that way comes back as its
header and literals. It matched nothing, so every block frame — twenty of forty-seven — lost
its highlight. It never showed a *wrong* one, which is why it looked like "blocks are not
supported" rather than a bug.
→ **`bytecodeAt:`** for code of either kind. And when a whole category of thing silently
answers "no", count the reasons before believing the category is unsupported.

**Believing a test that only shows a symptom is gone.** Turning off the compiler's semantic
warnings was done with a setter that does not exist. The check afterwards was "are the warnings
gone, and is `Undeclared` still empty" — both true, because the analysis was now failing
outright and producing nothing at all. The feature had been switched off, not fixed.
→ Check the **feature**, not the absence of the symptom. The fixture tests caught it a minute
later; the probe never would have.

## Leaving things behind in the image

**A fixture class per reset.** `ImageInterpretedSetup>>currentImage` builds its resource with
`#newSubclass`, so each reset made `Pharo10ImageResource1`, then `2`, then `3`. `resetResource`
forgot the class instead of removing it, and `TestResource` keeps a class-side `current`, so
every one of them held a **loaded 82 MB image** for the life of the image. Ten had piled up:
`dev.image` was **896 MB** where a stock Pharo 10 is 115, and `warm.image` 1.09 GB.
→ Remove what you created, not just the reference to it. Both halves are a test now
(`StackPageFixtureLifecycleTest>>testResettingTheFixtureDoesNotLeaveItsClassBehind`). After the
clean-up: `dev.image` 80 MB, `warm.image` 524 MB — and those numbers are worth watching, since
this kind of growth is silent.

**Resetting a holder while something still points at what it held.** Removing those classes
without first calling `resetResource` left `currentImage` naming a class that no longer
existed, and eight stack-page tests went red for reasons that had nothing to do with them.
→ Let the holder go first, then remove what it was holding.

## The remote loop

**`pkill -f` over ssh kills the ssh session.** The pattern matches the remote shell's own
command line. This happened three times.
→ `pkill -x pharo`, or bracket the pattern: `[p]attern`.

**Heredocs through the local shell.** Quoting mangled Smalltalk repeatedly ("unmatched '").
→ **Write the file with the editor, then `scp` it.**

**Timeouts that truncate a save.** `Smalltalk snapshot:` was killed mid-write by a short
timeout, so the image silently kept the old code and the next run "made no sense".
→ Give image-saving runs 900s and **verify the change survived** in a fresh process.

**Warming only one fixture.** Every test process reloaded the 60 MB Pharo 10 image: 39s per
test instead of 17s.
→ Warm **every** fixture into `warm.image`.

**Optimising what was measured instead of what was slow.** `SchedulerOnRealImageTest` took
seven minutes, and the measurements said a full heap scan ran on every call. Caching it saved
66 seconds of 422 and left the puzzle standing: 16 seconds a test, which is suspiciously
exactly one image load.

It was neither loading nor scanning. `AbstractInspectorsTest>>mutatesResource` defaults to
**true**, and a class that does not override it gets `stackBuilder veryDeepCopy` — the whole
interpreter and a 59 MB heap — **per test**. The class only ever reads. One line:

    mutatesResource ^ false

**476 seconds to 6.** The whole suite went from about twenty-five minutes to eighty seconds.
→ When a number does not add up, chase the part that does not add up. "16 seconds a test" was
visible for hours and was the answer.

**Reading a smaller test total as a regression.** The fast tier is whatever ran in under
eight seconds *last time*, so the total moves on its own: 280, then 247, then 194, with
nothing broken and nothing removed. Ten minutes went into hunting a regression that was a
class crossing the threshold.
→ The number only means something against the same tier. Run `--all` before believing it.

**Treating parallel flakes as failures.** Single-test errors under load that do not reproduce
alone: `VMObjectIndexableLayoutTest` and `QueryWidgetTest` at `-j 8`, and
`OOPBuilderTest>>testBuildDefaultObjectIsNotImmutable` at `-j 6` once a third image-loading
class joined the suite. Each was green on its own immediately after.
→ Re-run before believing a failure. Three classes now load a 59 MB image, so a full run wants
`-j 4`.

`ReifiedMemoryTest>>testFreezeMemory` joined the list on 2026-09-15: twice during or right
after a full `-j 4` run, then clean through 25 suite runs in one process, 6 fresh processes and
6 runs through the runner. **Unexplained**, not just unreproduced.

**Committing on a green-looking pipe.** The commit after it was chained on the test command
*running*, not on it being green, so a red suite went in anyway. Gate on the result.

**A loader that removed methods a trait provides.** It walked every selector of a class and
removed those without a matching file, printing alarming `REMOVED OOPString>>asString` lines.
Nothing was lost, because the trait re-provides them, but it was luck.
→ Iterate `localSelectors`, handle `.trait` directories, and skip packages the image has not
loaded.

## Searching

**A negative result is only as good as the scope of the search.** Hunting the special objects
array, a walk was capped at the first 4000 objects and came back empty, which read as "it is
not there". The heap has 1,106,303 objects: the search had covered 0.4% of it, and the array
was found immediately once the cap was lifted.
→ When a search answers nothing, check the search before believing the answer. Say what was
covered when reporting an absence — "not in the first 4000 objects" is a fact; "not in the
heap" was not.

**Guessing the API of our own class, then reading the silence as evidence.** The same empty
result was first blamed on wrong method names invented from memory. They happened to be right,
but the wrongness was never checked, so a real explanation (the cap) was almost skipped for an
imaginary one.
→ One `ls` on the class directory settles it in a second.

**A guard added for prudence, never measured.** The search first required the array to have
between 20 and 200 slots, on the grounds that a fixed VM structure is never tiny. Measuring
afterwards showed the shape alone matched in exactly one place among 1.1 million objects: the
guard did nothing except encode a version-specific number that would have been believed later.
→ Add a check when something *needs* it, and put the measurement in the comment.

**Documentation drifting away from the code it describes.** `spur-heap-shape.md` said the first
three objects were "nil, true and false … 8 bytes apart", while the code below it had used
nil, false, true at 16 for weeks, and the same file said so correctly two sections further
down. Nobody was misled, this time.
→ When a fact is confirmed against the image, grep the docs for the old version of it.

## Listening

**Building the wrong thing.** Asked for a screenshot of the debugger on a process; a read-only
browser was built instead, because it was cheaper and seemed close enough. It was not what was
asked.
→ Build what was asked, or say why not **before** building something else.
