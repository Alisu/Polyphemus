tests
testPharosDebuggerWindowOpensAndDrawsOnAHeldImage

	"The window of a live session, each frame drawn, then proceeded: the image is let go (#89).
	Opened, proceeded and closed by the UI process, which draws the window meanwhile (#31)."

	| pid session debugger |
	pid := self launchSpinningTarget.
	[
	[
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	debugger := PolyphemusTestCase inUIProcess: [ StDebugger openOn: session withFullView: true ].
	PolyphemusTestCase drawEachFrameOf: debugger.
	PolyphemusTestCase inUIProcess: [ (PolyphemusTestCase actionModelOf: debugger) proceedDebugSession ] ] ensure: [
		debugger ifNotNil: [ PolyphemusTestCase closeWindowOf: debugger ] ].
	self
		assert: (self waitFor: [ (self spikeDirectory / 'released') exists ])
		description: 'proceeding never let it go' ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
