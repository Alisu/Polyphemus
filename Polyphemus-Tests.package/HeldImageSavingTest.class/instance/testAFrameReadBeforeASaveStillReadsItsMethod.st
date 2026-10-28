tests
testAFrameReadBeforeASaveStillReadsItsMethod

	"Pharo 12's debugger reads the saved frame's method again after the save, from the reading made
	before it, while the save had the image drop its machine code (#122, #123)."

	| pid session frame |
	pid := self launchTargetDefining: 'Counter' thenRunning: (self counterTicking: 'tick: n
	^ (n \\ 7 + 2) ** 3').
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	self assert: (session runUntil: 'Number >> #raisedToInteger:').
	[
	#( '1 even.' '1 even. ' ) do: [ :each |
		frame := session interruptedContext.
		self assert: (session
				 recompileMethodTo: (frame method sourceCode copyReplaceAll: '^result' with: each , '
	^result')
				 inContext: frame
				 notifying: nil).
		self shouldnt: [ frame home compiledCode sourceNodeForPC: frame home pc ] raise: SpurCannotRead ] ]
		ensure: [ session resume ] ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
