tests
testItStepsAFrameSelectedBelowTheTop

	"Selected in the stack list below where the image's debugger is, a frame steps over its own
	pending send: the frames above it complete and the debugger is at it (#34)."

	| pid session selected |
	pid := self launchSpinningTarget.
	[
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	selected := (session interruptedContext stack select: [ :each | each selector = #DoIt ]) last.
	self assert: session interruptedContext stack size > selected stack size.
	session stepOver: selected.
	self assert: session interruptedContext selector equals: #DoIt.
	self assert: session interruptedContext stack size equals: selected stack size.
	session resume.
	self
		assert: (self waitFor: [ (self spikeDirectory / 'released') exists ])
		description: 'proceeding never let it go' ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
