tests
testADebuggerOnACoreShowsAProcessWhole

	"A core cannot be held to bring its frames into contexts."

	| pid core |
	pid := self launchTargetDefining: 'Counter' thenRunning: (self counterTicking: 'tick: n
	^ n + 1').
	core := self spikeDirectory / 'read-whole.core'.
	[
	Polyphemus dumpProcess: pid to: core.
	self assertADebuggerOn: 'counter' in: (Polyphemus readCoreDump: core fullName) showsItsFramesThen: [ :debugger | ] ] ensure: [
		LibC system: 'kill -9 ' , pid printString.
		core ensureDelete ]
