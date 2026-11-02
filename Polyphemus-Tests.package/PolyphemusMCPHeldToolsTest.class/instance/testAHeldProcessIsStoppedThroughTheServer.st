tests
testAHeldProcessIsStoppedThroughTheServer

	"stop ends the process held, its ensure blocks run, and lets the image go, which runs on
	without it; the handle is forgotten (#125)."

	| pid server handle |
	pid := self launchCounterWithAnEnsure.
	[
	server := PolyphemusMCPServer new.
	handle := (self call: 'hold' with: (Dictionary new at: 'pid' put: pid; at: 'directory' put: self spikeDirectory fullName; yourself) on: server) at: 'handle'.
	self call: 'run_until' with: (Dictionary new at: 'handle' put: handle; at: 'method' put: 'Counter >> #tick:'; yourself) on: server.
	self call: 'stop' with: (Dictionary new at: 'handle' put: handle; yourself) on: server.
	self assert: (self waitFor: [ (self spikeDirectory / 'released') exists ]) description: 'the image was never let go'.
	self assert: (self waitFor: [ (self spikeDirectory / 'ensured') exists ]) description: 'its ensure block never ran'.
	self assert: ((self answerOf: 'step' with: (Dictionary new at: 'handle' put: handle; yourself) on: server) at: 'isError').
	self assert: (LibC system: 'kill -0 ' , pid printString) equals: 0 ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
