tests
testADebuggerShowsAWaitingProcessWhole

	"A counter waiting on a Delay, its top context married to a frame: one frame shown until #150."

	| pid |
	pid := self launchTargetDefining: 'Counter' thenRunning: (self counterTicking: 'tick: n
	^ n + 1').
	[
	self assertADebuggerOn: 'counter' in: (Polyphemus readProcess: pid) showsItsFramesThen: [ :debugger | ] ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
