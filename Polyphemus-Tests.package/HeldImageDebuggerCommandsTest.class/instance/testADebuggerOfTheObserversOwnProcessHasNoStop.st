tests
testADebuggerOfTheObserversOwnProcessHasNoStop

	"Stop is for a held image's process: Pharo's debugger on one of the observer's own processes
	opens as it did, without it (#125)."

	| process session debugger |
	process := [ Semaphore new wait ] newProcess.
	session := process newDebugSessionNamed: 'observer' startedAt: process suspendedContext.
	session exception: (OupsNullException fromSignallerContext: process suspendedContext).
	debugger := PolyphemusTestCase inUIProcess: [ StDebugger openOn: session withFullView: true ].
	[
	PolyphemusTestCase inUIProcess: [ PolyphemusTestCase drawWindowOf: debugger ].
	self deny: (debugger rootCommandsGroup allCommands anySatisfy: [ :each | each name = 'Stop' ]) ] ensure: [
		PolyphemusTestCase closeWindowOf: debugger.
		process terminate ]
