tests
testACounterSavedThroughTheServerCountsByItsNewSource

	"save puts a method's new source into the held image and restarts its frame in it: let go,
	the counter counts by it (#128)."

	| pid server handle saved |
	pid := self launchTargetDefining: 'Counter' thenRunning: (self counterTicking: 'tick: n
	^ n + 1' from: 0 after: (self writing: 'n' as: 'n')).
	[
	server := PolyphemusMCPServer new.
	handle := (self call: 'hold' with: (Dictionary new at: 'pid' put: pid; at: 'directory' put: self spikeDirectory fullName; yourself) on: server) at: 'handle'.
	self call: 'run_until' with: (Dictionary new at: 'handle' put: handle; at: 'method' put: 'Counter >> #tick:'; yourself) on: server.
	saved := self call: 'save' with: (Dictionary new at: 'handle' put: handle; at: 'source' put: 'tick: n
	^ n + 1000000'; yourself) on: server.
	self assert: (saved at: 'saved').
	self call: 'let_go' with: (Dictionary new at: 'handle' put: handle; yourself) on: server.
	self
		assert: (self waitFor: [ ((self valueIn: 'n') ifNil: [ 0 ]) > 1000000 ])
		description: 'let go, it does not count by the saved source' ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
