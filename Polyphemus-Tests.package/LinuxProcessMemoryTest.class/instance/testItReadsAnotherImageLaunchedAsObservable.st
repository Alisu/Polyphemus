tests
testItReadsAnotherImageLaunchedAsObservable

	"The whole architecture, end to end: one Pharo reading a different Pharo's heap.

	The target is launched through `bin/pharo-debuggable`, which grants the permission and
	then becomes the virtual machine -- so the permission is in place before the image starts
	loading. It is backgrounded, so the shell that started it exits and the target is
	reparented to init: it is emphatically *not* a descendant of this process, which is the
	arrangement that would otherwise make this readable.

	`ptrace_scope` stays at 1 throughout. Nothing on the machine is weakened; one image was
	launched willing to be read."

	| shim bang work pidFile pid reader dumped |
	shim := FileLocator home / 'polyphemus' / 'Polyphemus' / 'bin' / 'pharo-debuggable'.
	work := FileLocator home / 'polyphemus'.
	(shim exists and: [ (work / 'idle.st') exists ]) ifFalse: [
		^ self skip: 'build bin/pharo-debuggable first: cc -O2 -o pharo-debuggable pharo-debuggable.c' ].

	bang := String with: (Character value: 33).
	pidFile := FileLocator temp / 'polyphemus-observable-target.pid'.
	pidFile ensureDelete.
	LibC system: 'cd ' , work fullName , ' && POLYPHEMUS_OBSERVER=any ' , shim fullName
		, ' ' , work fullName
		, '/pharo-vm/lib/pharo --headless dev.image st idle.st > /dev/null 2>&1 & echo $'
		, bang , ' > ' , pidFile fullName.
	(Delay forSeconds: 12) wait.
	pid := pidFile contents trimBoth asNumber.
	pidFile ensureDelete.

	[
	self assert: LinuxProcessMemory ptraceScope equals: 1.
	self assert: (LinuxProcessMemory unchecked: pid) canBeRead.

	reader := LinuxProcessMemory on: pid.
	dumped := SpurDumpedMemory on: reader.
	self assert: dumped heapStart isNotNil.
	self assert: dumped heapWalk objectCount > 100000.
	self
		assert: (dumped reifiedMemory reifyOop: dumped heapStart) oopClass name
		equals: 'UndefinedObject' ] ensure: [
		LibC system: 'kill ' , pid printString.
		reader ifNotNil: [ reader close ] ]
