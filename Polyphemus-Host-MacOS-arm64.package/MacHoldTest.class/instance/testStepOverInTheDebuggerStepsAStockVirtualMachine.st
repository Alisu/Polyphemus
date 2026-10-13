tests
testStepOverInTheDebuggerStepsAStockVirtualMachine

	"Step Over on a held stock VM's stack: the VM steps, and the debugger is shown where its
	process now is; let go, it runs on."

	| pid dir session before |
	MacProcessMemory isRoot ifFalse: [ ^ self skip: 'reading another process on macOS needs the observer run as root (sudo)' ].
	dir := self emptyDirectoryNamed: 'mac-step'.
	pid := self launchTargetRunning: '[ [ true ] whileTrue: [ (1 to: 1000) do: [ :each | 3 sqrt ] ] ] forkAt: 40.
(Delay forSeconds: 120) wait.
Smalltalk exitSuccess'.
	[
	Polyphemus putAWatcherInto: pid watchedIn: dir.
	session := Polyphemus holdProcess: pid watchedIn: dir.
	before := session interruptedContext selector -> session interruptedContext pc.
	session stepOver: session interruptedContext.
	self deny: session interruptedContext selector -> session interruptedContext pc equals: before.
	session resume.
	self assert: (self waitForFile: 'released' in: dir) description: 'it never let go' ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
