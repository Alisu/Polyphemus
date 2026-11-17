tests
testItReadsALiveProcessAfresh

	"#26: one reader must not answer the bytes it read a moment ago -- a process changes while
	it is read. The VM's count of its own interrupt checks climbs about seventy times a second,
	idle, so it moves while this waits."

	| address first waited |
	address := (VMVariables on: memory) addressOf: 'statCheckForEvents'.
	first := memory unsignedAt: address size: 8.
	waited := 0.
	[ (memory unsignedAt: address size: 8) > first or: [ waited > 100 ] ] whileFalse: [
		waited := waited + 1.
		(Delay forMilliseconds: 100) wait ].

	self assert: (memory unsignedAt: address size: 8) > first
