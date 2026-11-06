tests
testADebuggerOnARunningVirtualMachineReadNotHeldOpensOnItsTopFrame

	"A running VM read without holding it: the debugger opens on the top frame of the process.
	Pharo 10's failed to open (#149)."

	| pid memory debugger |
	pid := self launchCounter.
	[
	memory := Polyphemus readProcess: pid.
	debugger := Polyphemus debugProcessNamed: 'counter' in: memory.
	[
	PolyphemusTestCase drawWindowOf: debugger.
	self assert: debugger stackTable selection selectedItem notNil ] ensure: [
		debugger window ifNotNil: [ :window | window close ] ] ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
