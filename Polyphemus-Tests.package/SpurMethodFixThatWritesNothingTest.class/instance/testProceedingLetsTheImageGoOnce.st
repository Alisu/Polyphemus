tests
testProceedingLetsTheImageGoOnce

	"Proceeding in the debugger lets go of the image that was held, and the window closes
	itself. Once only: a second proceed has nothing left to release."

	| session let |
	let := 0.
	session := ReifiedDebugSession named: 'Polyphemus' on: nil startedAt: nil fixing: nil.
	session releaseWith: [ let := let + 1 ].

	self assert: session resume.
	self assert: let equals: 1.
	self deny: session resume.
	self assert: let equals: 1
