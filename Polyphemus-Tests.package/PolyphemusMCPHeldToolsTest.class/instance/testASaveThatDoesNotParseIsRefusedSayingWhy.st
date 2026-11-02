tests
testASaveThatDoesNotParseIsRefusedSayingWhy

	"A source that does not parse is not saved: the answer is a failure saying why, and the image
	stays held, to be saved again or let go (#128)."

	| pid server handle refused |
	pid := self launchTargetDefining: 'Counter' thenRunning: (self counterTicking: 'tick: n
	^ n + 1').
	[
	server := PolyphemusMCPServer new.
	handle := (self call: 'hold' with: (Dictionary new at: 'pid' put: pid; at: 'directory' put: self spikeDirectory fullName; yourself) on: server) at: 'handle'.
	self call: 'run_until' with: (Dictionary new at: 'handle' put: handle; at: 'method' put: 'Counter >> #tick:'; yourself) on: server.
	refused := self answerOf: 'save' with: (Dictionary new at: 'handle' put: handle; at: 'source' put: 'tick: n
	^ n +'; yourself) on: server.
	self assert: (refused at: 'isError').
	self assert: (((refused at: 'content') first at: 'text') includesSubstring: 'Not saved').
	self call: 'let_go' with: (Dictionary new at: 'handle' put: handle; yourself) on: server ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
