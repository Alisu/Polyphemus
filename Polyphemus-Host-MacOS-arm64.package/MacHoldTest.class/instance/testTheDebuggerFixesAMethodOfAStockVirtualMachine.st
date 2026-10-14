tests
testTheDebuggerFixesAMethodOfAStockVirtualMachine

	"A user's loop on a method of its own, which the machine compiled: held through a watcher
	put in, run until that method, fixed as the debugger accepts it (#20), it stops once let go.
	Not SmallInteger>>#even, which the whole image sends: fixed to false, the VM died (#79)."

	| pid dir session |
	MacProcessMemory isRoot ifFalse: [ ^ self skip: 'reading another process on macOS needs the observer run as root (sudo)' ].
	dir := self emptyDirectoryNamed: 'mac-edit'.
	pid := self launchTargetRunning: '| dir |
dir := ' , dir fullName printString , ' asFileReference.
Object compile: ''polyphemusLoopsOn ^ true'' classified: ''polyphemus-target''.
200000 timesRepeat: [ 4 polyphemusLoopsOn ].
[ [ 4 polyphemusLoopsOn ] whileTrue: [ (1 to: 1000) do: [ :each | 3 sqrt ] ].
  (dir / ''answer'') writeStreamDo: [ :stream | stream nextPutAll: 4 polyphemusLoopsOn printString ] ] forkAt: 40.
(Delay forSeconds: 600) wait.
Smalltalk exitSuccess'.
	[
	Polyphemus putAWatcherInto: pid watchedIn: dir.
	session := Polyphemus holdProcess: pid watchedIn: dir.
	session runUntil: 'Object >> #polyphemusLoopsOn'.
	self assert: session interruptedContext selector equals: #polyphemusLoopsOn.
	self assert:
		(session recompileMethodTo: 'polyphemusLoopsOn ^ false' inContext: session interruptedContext notifying: nil).
	session resume.
	self assert: (self waitForFile: 'answer' in: dir) description: 'the loop never ended'.
	self assert: (dir / 'answer') contents trimBoth equals: 'false' ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
