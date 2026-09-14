tests
testEveryProcessHasAStackOfContexts

	"Every process of a real snapshot carries its whole stack as contexts, and some
	of them are many frames deep. The exception is the running process, whose context
	the loader married back to a frame."

	| deepest married |
	married := reifiedMemory marriedContexts.
	deepest := 0.
	reifiedMemory allReifiedProcesses do: [ :process |
		| stack |
		stack := reifiedMemory contextsOfProcess: process.
		self deny: stack isEmpty.
		stack do: [ :context | self assert: context isContextOop ].
		deepest := deepest max: stack size ].

	self assert: deepest > 5.
	self assert: married size equals: 1.
	self assert: (reifiedMemory contextsOfProcess: reifiedMemory reifiedActiveProcess) first
		equals: married first
