tests
testAVirtualMachineWithAWindowIsReadAndHeld

	"A stock VM with its window open, as a user starts one: read, then held and let go. Its
	window once made its heap be looked for in another region (#91)."

	| pid dir session |
	MacProcessMemory isRoot ifFalse: [ ^ self skip: 'reading another process on macOS needs the observer run as root (sudo)' ].
	dir := self emptyDirectoryNamed: 'mac-window'.
	pid := self
		       launchTargetRunning: '| written |
written := ' , (dir / 'display.part') fullName printString , ' asFileReference.
written writeStreamDo: [ :s | s nextPutAll: (Smalltalk isHeadless ifTrue: [ ''headless'' ] ifFalse: [ ''window'' ]) ].
written renameTo: ''display''.
(Delay forSeconds: 600) wait.
Smalltalk exitSuccess'
		       withAWindow: true.
	[
	self assert: (self waitForFile: 'display' in: dir) description: 'the target never started'.
	(dir / 'display') contents = 'window' ifFalse: [
		^ self skip: 'the target found no graphical session here (macOS CI) and runs headless (#101): nothing to say of #91' ].
	self assert: (Polyphemus readProcess: pid) allReifiedProcesses notEmpty.
	Polyphemus putAWatcherInto: pid watchedIn: dir.
	session := Polyphemus holdProcess: pid watchedIn: dir.
	session resume.
	self assert: (self waitForFile: 'released' in: dir) description: 'it never let go' ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
