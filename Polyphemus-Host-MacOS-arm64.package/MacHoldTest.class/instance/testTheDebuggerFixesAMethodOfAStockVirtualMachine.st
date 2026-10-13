tests
testTheDebuggerFixesAMethodOfAStockVirtualMachine

	"A user's loop on SmallInteger>>#even, which the machine compiled: held through a watcher
	put in, run until #even, fixed as the debugger accepts it (#20), it stops once let go."

	| pid dir session |
	MacProcessMemory isRoot ifFalse: [ ^ self skip: 'reading another process on macOS needs the observer run as root (sudo)' ].
	dir := self emptyDirectoryNamed: 'mac-edit'.
	pid := self launchTargetRunning: '| dir |
dir := ' , dir fullName printString , ' asFileReference.
200000 timesRepeat: [ 4 even ].
[ [ 4 even ] whileTrue: [ (1 to: 1000) do: [ :each | 3 sqrt ] ].
  (dir / ''answer'') writeStreamDo: [ :stream | stream nextPutAll: 4 even printString ] ] forkAt: 40.
(Delay forSeconds: 120) wait.
Smalltalk exitSuccess'.
	[
	Polyphemus putAWatcherInto: pid watchedIn: dir.
	session := Polyphemus holdProcess: pid watchedIn: dir.
	session runUntil: 'SmallInteger >> #even'.
	self assert: session interruptedContext selector equals: #even.
	self assert: (session recompileMethodTo: 'even ^ false' inContext: session interruptedContext notifying: nil).
	session resume.
	self assert: (self waitForFile: 'answer' in: dir) description: 'the loop never ended'.
	self assert: (dir / 'answer') contents trimBoth equals: 'false' ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
