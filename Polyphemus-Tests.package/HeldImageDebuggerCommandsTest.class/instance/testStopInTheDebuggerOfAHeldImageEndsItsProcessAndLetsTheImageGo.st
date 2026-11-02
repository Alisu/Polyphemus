tests
testStopInTheDebuggerOfAHeldImageEndsItsProcessAndLetsTheImageGo

	"The debugger of a held image has Stop beside Proceed: it ends the process held, its ensure
	blocks run, and lets the image go, which runs on without it (#125)."

	| pid session debugger stop |
	pid := self launchCounterWithAnEnsure.
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	self assert: (session runUntil: 'Counter >> #tick:').
	debugger := StDebugger openOn: session withFullView: true.
	[
	PolyphemusTestCase drawWindowOf: debugger.
	stop := debugger rootCommandsGroup allCommands
		        detect: [ :each | each name = 'Stop' ]
		        ifNone: [ self fail: 'no Stop in the debugger of a held image' ].
	stop execute ] ensure: [ debugger window ifNotNil: [ :window | window close ] ].
	self assert: (self waitFor: [ (self spikeDirectory / 'released') exists ]) description: 'the image was never let go'.
	self assert: (self waitFor: [ (self spikeDirectory / 'ensured') exists ]) description: 'its ensure block never ran' ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
