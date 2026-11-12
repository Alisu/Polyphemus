tests
testADebuggerOnARunningVirtualMachineReadNotHeldOpensOnItsTopFrame

	"A running VM read without holding it: the debugger opens on the top frame of the process.
	Pharo 10's failed to open (#149)."

	| pid memory debugger |
	pid := self launchCounter.
	[
	memory := Polyphemus readProcess: pid.
	debugger := PolyphemusTestCase inUIProcess: [ Polyphemus debugProcessNamed: 'counter' in: memory ].
	[
	PolyphemusTestCase inUIProcess: [ PolyphemusTestCase drawWindowOf: debugger ].
	self assert: debugger stackTable selection selectedItem notNil ] ensure: [
		PolyphemusTestCase closeWindowOf: debugger ] ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
