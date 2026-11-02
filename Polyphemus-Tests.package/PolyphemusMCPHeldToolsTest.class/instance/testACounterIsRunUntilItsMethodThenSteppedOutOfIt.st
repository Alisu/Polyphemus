tests
testACounterIsRunUntilItsMethodThenSteppedOutOfIt

	"run_until holds the image where the method is reached, and step over takes it on from
	there, out of it a few steps later (#128)."

	| pid server handle reached top |
	pid := self launchTargetDefining: 'Counter' thenRunning: (self counterTicking: 'tick: n
	^ n + 1').
	[
	server := PolyphemusMCPServer new.
	handle := (self call: 'hold' with: (Dictionary new at: 'pid' put: pid; at: 'directory' put: self spikeDirectory fullName; yourself) on: server) at: 'handle'.
	reached := self call: 'run_until' with: (Dictionary new at: 'handle' put: handle; at: 'method' put: 'Counter >> #tick:'; yourself) on: server.
	self assert: (reached at: 'reached').
	top := [ :answer | ((answer at: 'frames') first at: 'method') ].
	self assert: ((top value: reached) includesSubstring: 'tick:') description: [ top value: reached ].
	self
		assert: ((1 to: 6) anySatisfy: [ :each |
				 ((top value: (self call: 'step' with: (Dictionary new at: 'handle' put: handle; at: 'how' put: 'over'; yourself) on: server))
					  includesSubstring: 'tick:') not ])
		description: 'stepped over six times, it never left tick:'.
	self call: 'let_go' with: (Dictionary new at: 'handle' put: handle; yourself) on: server ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
