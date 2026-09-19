tests
testItReadsAnotherImageLaunchedAsObservable

	"The whole architecture, end to end: one Pharo reading a different Pharo's heap, held
	still while it is read.

	The target is launched through `bin/pharo-debuggable`, which grants the permission and
	then becomes the virtual machine, so it is in place before the image starts loading. It
	is backgrounded, so the shell that started it exits and the target is reparented to init:
	it is emphatically *not* a descendant of this process, which is the arrangement that
	would otherwise make it readable. `ptrace_scope` stays at 1 throughout.

	Whether a *running* image reads torn is not asserted, because this one is asleep in a
	delay and its heap is not changing -- a torn read needs a busy target. What is asserted
	is the other half: held still, every rung of the ladder passes, the free lists and a walk
	over the objects agreeing about the free space."

	| shim target bang pidFile pid reader dumped waited |
	"Nothing here is particular to one machine: the launcher is found in this repository, the
	 virtual machine is the one running these tests, and the image launched is the pinned
	 Pharo 10 fixture the other tests already use. It is told to wait rather than handed a
	 script, so no file has to be anywhere in particular either."
	shim := self repositoryDirectory / 'bin' / 'pharo-debuggable'.
	shim exists ifFalse: [
		^ self skip: 'build bin/pharo-debuggable first: cc -O2 -o bin/pharo-debuggable bin/pharo-debuggable.c' ].
	target := PharoImageAccessor pathToPharo10 asFileReference.
	target exists ifFalse: [ ^ self skip: 'the pinned Pharo 10 image has not been downloaded' ].

	bang := String with: (Character value: 33).
	pidFile := FileLocator temp / 'polyphemus-observable-target.pid'.
	pidFile ensureDelete.
	LibC system: 'POLYPHEMUS_OBSERVER=any ' , shim fullName , ' ' , Smalltalk vm fullPath
		, ' --headless ' , target fullName
		, ' eval "(Delay forSeconds: 120) wait" > /dev/null 2>&1 & echo $' , bang , ' > '
		, pidFile fullName.
	"Wait for it to be there and readable, rather than for a fixed number of seconds. A
	 sixty megabyte image takes as long as the machine is busy, and a suite running six
	 test images at once is a busy machine -- guessing twelve seconds passed here and
	 failed under load, which is the sort of test that wastes an afternoon later."
	waited := 0.
	[ pidFile exists and: [ pidFile contents trimBoth notEmpty ] ] whileFalse: [
		(waited := waited + 1) > 200 ifTrue: [ ^ self fail: 'nothing was started' ].
		(Delay forMilliseconds: 100) wait ].
	pid := pidFile contents trimBoth asNumber.
	pidFile ensureDelete.
	"Readable is not the same as ready. The permission is granted before the virtual machine
	 even starts, so the process reads as readable while its image is still being loaded and
	 there is no heap in it yet. What says the image is there is that the memory it was given
	 has appeared -- sixty megabytes of it."
	waited := 0.
	[
	(LinuxProcessMemory unchecked: pid) canBeRead and: [
		((LinuxProcessMemory unchecked: pid) loadableSegments
			 inject: 0
			 into: [ :most :each | most max: each sizeInFile ]) > 40000000 ] ] whileFalse: [
		(waited := waited + 1) > 900 ifTrue: [
			LibC system: 'kill ' , pid printString.
			^ self fail: 'the target never finished loading its image' ].
		(Delay forMilliseconds: 100) wait ].

	[
	self assert: LinuxProcessMemory ptraceScope equals: 1.
	self assert: (LinuxProcessMemory unchecked: pid) canBeRead.
	reader := LinuxProcessMemory on: pid.

	reader whileStopped: [
		self assert: reader isStopped.
		dumped := SpurDumpedMemory on: reader.
		self assert: dumped heapWalk objectCount > 100000.
		self
			assert: (dumped reifiedMemory reifyOop: dumped heapStart) oopClass name
			equals: 'UndefinedObject'.

		"held still, the two accounts of the free space agree"
		self assert: dumped freeListsAreIntact.
		self assert: dumped readability refusals asArray equals: #(  ).
		self assert: dumped readability isFullyReadable ].

	self deny: reader isStopped ] ensure: [
		LibC system: 'kill ' , pid printString.
		reader ifNotNil: [ reader close ] ]
