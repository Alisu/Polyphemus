tests
testStackShowsTheSourceOfEachMethod

	"Source comes from the target image's own .sources file, read through its methods'
	trailers. A block activation has no source of its own and borrows its home
	method's, which here is the snapshot code that wrote this very image."

	| stack top block |
	stack := reifiedMemory contextsOfProcess: reifiedMemory reifiedActiveProcess.
	top := reifiedMemory sourceOfContext: stack first.
	block := reifiedMemory sourceOfContext: stack second.

	self assert: (top beginsWith: 'launchSnapshot: save andQuit: quit').
	self assert: (top includesSubstring: 'ChangesLog default logSnapshot:').
	self assert: (block beginsWith: 'snapshot: save andQuit: quit')
