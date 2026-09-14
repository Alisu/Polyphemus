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

**Trusting recompiled code.** Mapping a pc to a line needs the method's pc map, which the
file does not carry, so the source was recompiled here against the reified class. It
compiles — and the bytecodes are not the same code: 42 bytes against the 44 in the file,
differing from the eleventh onwards.
→ **Compare the bytecodes before believing any correspondence.** A pc map taken from
recompiled code points at the wrong line. Stage one names temporaries, which needs only
parsing and semantic analysis, and highlights nothing.

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

**A loader that removed methods a trait provides.** It walked every selector of a class and
removed those without a matching file, printing alarming `REMOVED OOPString>>asString` lines.
Nothing was lost, because the trait re-provides them, but it was luck.
→ Iterate `localSelectors`, handle `.trait` directories, and skip packages the image has not
loaded.

## Listening

**Building the wrong thing.** Asked for a screenshot of the debugger on a process; a read-only
browser was built instead, because it was cheaper and seemed close enough. It was not what was
asked.
→ Build what was asked, or say why not **before** building something else.
