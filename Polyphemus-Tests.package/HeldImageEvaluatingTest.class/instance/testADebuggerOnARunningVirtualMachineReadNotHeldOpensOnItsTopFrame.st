tests
testADebuggerOnARunningVirtualMachineReadNotHeldOpensOnItsTopFrame

	"A running VM read without holding it: the debugger opens on the top frame of the process, and
	says its stack is cut where the VM still holds frames. Pharo 10's failed to open (#149)."

	| pid memory debugger |
	pid := self launchCounter.
	[
	memory := Polyphemus readProcess: pid.
	debugger := Polyphemus debugProcessNamed: 'counter' in: memory.
	[
	PolyphemusTestCase drawWindowOf: debugger.
	self assert: debugger stackTable selection selectedItem notNil.
	self assert: (debugger window title includesSubstring: 'hold the image') description: [ debugger window title ] ] ensure: [
		debugger window ifNotNil: [ :window | window close ] ] ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
