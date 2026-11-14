tests
testAStackThatCannotBeReadFurtherSaysWhyAndAWholeOneSaysNothing

	"A stack cut by damage looked whole: the reading says why it ends, per process. Three of the
	eight are cut: by a sender that points nowhere, by one that is no context, and one not read
	at all, its suspended context pointing nowhere. Damage that cuts no stack is no reason."

	| stacks why unread |
	stacks := reifiedMemory stacks.
	why := [ :description |
	       stacks whyTheStackEndsOfProcess: (DamagedPharoImageResource process: description in: reifiedMemory) ].

	self assert: ((why value: 'MorphicRenderLoop>>doOneCycleWhile:') includesSubstring: 'is no address of this memory').
	self assert: ((why value: 'AtomicSharedQueue>>waitForNewItems') includesSubstring: 'is no context').
	self assert: (why value: 'Process>>resume') isNil.
	self assert: (why value: 'WeakArray class>>finalizationProcess') isNil.
	unread := reifiedMemory allReifiedProcesses select: [ :each | (stacks activationsOfProcess: each) isEmpty ].
	self assert: unread size equals: 1.
	self assert: ((stacks whyTheStackEndsOfProcess: unread first) beginsWith:
			 'the suspended context of the process does not read: ').
	self
		assert: (reifiedMemory allReifiedProcesses count: [ :each | (stacks whyTheStackEndsOfProcess: each) notNil ])
		equals: 3
