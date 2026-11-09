tests
testASendCogLinkedSaysToWhat

	"#95: tick: sends abs, which Cog links to the method found once sent; the map says so at the
	send. Its + is inlined: the send for when it overflows is never taken, so never linked."

	| pid text |
	pid := self launchTargetDefining: 'Counter' thenRunning: (self counterTicking: 'tick: n
	^ n abs + 1').
	[
	(Delay forSeconds: 1) wait.
	text := ((Polyphemus readProcess: pid) oopClassNamed: 'Counter') methodNamed: #tick:.
	text := text machineCodeText.
	self assert: (text includesSubstring: 'linked to Number >> #abs') description: [ text ].
	self assert: (text includesSubstring: 'unlinked') description: [ text ] ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
