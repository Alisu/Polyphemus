tests
testCodeInAFrameOfAReadingRunsInTheObserverAndSaysSo

	"#150: on the frames of a stack page as on contexts (#126): no image runs it, and an assignment
	to a frame's variable is refused, the reading being no image to change."

	| pid |
	pid := self launchTargetDefining: 'Counter' thenRunning: (self counterTicking: 'tick: n
	^ n + 1').
	[
	self assertADebuggerOn: 'counter' in: (Polyphemus readProcess: pid) showsItsFramesThen: [ :debugger | | result |
		debugger stackTable selectIndex: 1.
		result := debugger code evaluate: '3 + 4' onCompileError: [ nil ] onError: [ :error | error ].
		self assert: result printString equals: '"in the observer" 7'.
		self assert: (debugger window title beginsWith: '[Code runs in the observer]').
		self should: [ debugger stackTable selectedItem tempAt: 1 put: 5 ] raise: NotOnAReading ] ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
