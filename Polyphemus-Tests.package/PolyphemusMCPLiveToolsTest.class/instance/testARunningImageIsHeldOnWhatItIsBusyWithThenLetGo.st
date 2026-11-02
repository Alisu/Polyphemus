tests
testARunningImageIsHeldOnWhatItIsBusyWithThenLetGo

	"hold puts a watcher into an image that has none and holds it on its busy process; let_go
	lets it run on (#128)."

	| pid server held frames gone |
	pid := self launchStockSpinningTarget.
	[
	server := PolyphemusMCPServer new.
	held := self call: 'hold' with: (Dictionary new at: 'pid' put: pid; at: 'directory' put: self spikeDirectory fullName; yourself) on: server.
	self deny: (held at: 'isError') description: [ ((held at: 'content') first at: 'text') ].
	frames := (held at: 'structuredContent') at: 'frames'.
	self assert: frames notEmpty.
	gone := self call: 'let_go' with: (Dictionary new at: 'handle' put: ((held at: 'structuredContent') at: 'handle'); yourself) on: server.
	self deny: (gone at: 'isError') description: [ ((gone at: 'content') first at: 'text') ].
	self
		assert: (self waitFor: [ (self spikeDirectory / 'released') exists ])
		description: 'it never let go'.
	self assert: (LibC system: 'kill -0 ' , pid printString) equals: 0 ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
