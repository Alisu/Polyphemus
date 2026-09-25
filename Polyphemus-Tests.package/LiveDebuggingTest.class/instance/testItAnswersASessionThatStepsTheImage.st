tests
testItAnswersASessionThatStepsTheImage

	| pid session before |
	pid := self launchSpinningTarget.
	[
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	before := session interruptedContext selector -> session interruptedContext pc.
	session stepOver: session interruptedContext.
	self deny: session interruptedContext selector -> session interruptedContext pc equals: before.
	session resume.
	self
		assert: (self waitFor: [ (self spikeDirectory / 'released') exists ])
		description: 'proceeding never let it go' ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
