tests
testTheRunningProcessWhoseFramePointerIsOffItsPagesSaysWhyItShowsNoStack

	"The process that was running has no context: its frames are found from what the VM saved
	on leaving for C. With that frame pointer damaged it shows no stack, as a process that ended
	does, and the reading says why; the other stacks read whole."

	| active others |
	memory vmLayout raw vmVariables wasRunningMachineCode == false ifFalse: [
		^ self skip: 'a thread of this core was in machine code: its frames are in its registers, not in what the VM saved' ].
	active := memory reifiedActiveProcess.
	others := memory allReifiedProcesses reject: [ :each | each address = active address ].

	self assert: (memory activationsOfProcess: active) isEmpty.
	self
		assert: (memory stacks whyTheStackEndsOfProcess: active)
		equals: 'cannot read frame: itsFramePointerIsNotOnItsActivePage'.
	self assert: (others allSatisfy: [ :each | (memory stacks whyTheStackEndsOfProcess: each) isNil ]).
	self assert: (others anySatisfy: [ :each | (memory activationsOfProcess: each) size > 5 ])
