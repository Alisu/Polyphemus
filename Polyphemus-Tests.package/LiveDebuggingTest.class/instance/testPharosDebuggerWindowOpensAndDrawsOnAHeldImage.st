tests
testPharosDebuggerWindowOpensAndDrawsOnAHeldImage

	"The window of a live session, each frame drawn, then proceeded: the image is let go (#89)."

	| pid debugger |
	pid := self launchSpinningTarget.
	[
	[
	debugger := StDebugger openOn: (Polyphemus holdProcess: pid watchedIn: self spikeDirectory) withFullView: true.
	PolyphemusTestCase drawEachFrameOf: debugger.
	(PolyphemusTestCase actionModelOf: debugger) proceedDebugSession ] ensure: [
		debugger ifNotNil: [ debugger window ifNotNil: [ :window | window close ] ] ].
	self
		assert: (self waitFor: [ (self spikeDirectory / 'released') exists ])
		description: 'proceeding never let it go' ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
