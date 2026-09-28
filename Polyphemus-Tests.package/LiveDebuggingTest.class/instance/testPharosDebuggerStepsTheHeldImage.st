tests
testPharosDebuggerStepsTheHeldImage

	"Its own actions, as its buttons send them: step into, over and through, then proceed,
	which lets the image go (#41)."

	| pid debugger where |
	pid := self launchSpinningTarget.
	where := [ debugger session interruptedContext selector -> debugger session interruptedContext pc ].
	[
	debugger := StDebugger on: (Polyphemus holdProcess: pid watchedIn: self spikeDirectory).
	#( #stepInto: #stepOver: #stepThrough: ) do: [ :each |
		| before |
		before := where value.
		(PolyphemusTestCase actionModelOf: debugger) perform: each with: debugger session interruptedContext.
		self deny: where value = before description: each , ' did not move' ].
	(PolyphemusTestCase actionModelOf: debugger) proceedDebugSession.
	self
		assert: (self waitFor: [ (self spikeDirectory / 'released') exists ])
		description: 'proceeding never let it go' ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
