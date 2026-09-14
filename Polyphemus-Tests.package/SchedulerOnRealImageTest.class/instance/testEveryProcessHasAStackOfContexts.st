tests
testEveryProcessHasAStackOfContexts

	"A snapshot carries every stack as contexts, the running process included: read
	as a snapshot rather than started, nothing is married and no stack is cut short."

	| deepest |
	deepest := 0.
	reifiedMemory allReifiedProcesses do: [ :process |
		| stack |
		stack := reifiedMemory contextsOfProcess: process.
		self deny: stack isEmpty.
		stack do: [ :context | self assert: context isContextOop ].
		deepest := deepest max: stack size ].

	self assert: deepest > 5.
	self assert: reifiedMemory marriedContexts isEmpty.
	self assert: (reifiedMemory contextsOfProcess: reifiedMemory reifiedActiveProcess) size > 1
