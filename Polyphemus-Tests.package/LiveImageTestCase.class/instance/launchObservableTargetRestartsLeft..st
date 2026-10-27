helpers
launchObservableTargetRestartsLeft: aCount

	"Launch the pinned target image through bin/pharo-debuggable, not as our descendant,
	waiting on a delay, and answer its pid once its image is loaded and it is idle: stopped
	while it still starts up, it is in machine code or changing its heap."

	| shim target bang pidFile pid waited log |
	"Nothing here is particular to one machine: the launcher is in this repository, the VM the
	 one running these tests, the image the pinned target (pathToTargetImage), told to wait
	 rather than handed a script."
	shim := self repositoryDirectory / 'bin' / 'pharo-debuggable'.
	shim exists ifFalse: [
		^ self skip: 'build bin/pharo-debuggable first: cc -O2 -o bin/pharo-debuggable bin/pharo-debuggable.c' ].
	target := PharoImageAccessor pathToTargetImage asFileReference.
	target exists ifFalse: [ ^ self skip: 'the pinned target image has not been downloaded' ].

	bang := String with: (Character value: 33).
	pidFile := self observablePidFile.
	pidFile ensureDelete.
	log := pidFile withExtension: 'log'.
	log ensureDelete.
	LibC system: 'POLYPHEMUS_OBSERVER=any ' , shim fullName , ' ' , PharoImageAccessor pathToTargetVM
		, ' --headless ' , target fullName , ' --no-default-preferences'
		, ' eval "(Delay forSeconds: ' , self targetLifetime printString , ') wait" > ' , log fullName , ' 2>&1 & echo $' , bang , ' > '
		, pidFile fullName.
	"Waited for, not a fixed number of seconds: a sixty megabyte image loads as slowly as the
	 machine is busy, and twelve seconds guessed here passed alone and failed under load."
	waited := 0.
	[ pidFile exists and: [ pidFile contents trimBoth notEmpty ] ] whileFalse: [
		(waited := waited + 1) > 200 ifTrue: [ ^ self fail: 'nothing was started' ].
		(Delay forMilliseconds: 100) wait ].
	pid := pidFile contents trimBoth asNumber.
	pidFile ensureDelete.
	"Readable is not ready: the permission comes before the VM starts, while its image is still
	 loading and it has no heap. The image is there once the memory it was given has appeared,
	 sixty megabytes of it."
	waited := 0.
	[
	(LinuxProcessMemory unchecked: pid) canBeRead and: [
		((LinuxProcessMemory unchecked: pid) loadableSegments
			 inject: 0
			 into: [ :most :each | most max: each sizeInFile ]) > 40000000 ] ] whileFalse: [
		(self class vm9CouldNotMapItsHeapIn: (self targetLogIn: log)) ifTrue: [
			aCount > 0 ifFalse: [ ^ self fail: 'the target could not map its heap, twice (#31)' ].
			self noteRestartOfTheTarget.
			^ self launchObservableTargetRestartsLeft: aCount - 1 ].
		(waited := waited + 1) > 900 ifTrue: [
			LibC system: 'kill ' , pid printString.
			^ self fail: 'the target never finished loading its image' ].
		(Delay forMilliseconds: 100) wait ].

	waited := 0.
	[ (LinuxProcessMemory unchecked: pid) isQuiet ] whileFalse: [
		(waited := waited + 1) > 900 ifTrue: [
			LibC system: 'kill ' , pid printString.
			^ self fail: 'the target never went idle' ].
		(Delay forMilliseconds: 100) wait ].
	^ pid
