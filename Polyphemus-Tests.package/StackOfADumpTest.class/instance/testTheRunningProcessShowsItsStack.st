tests
testTheRunningProcessShowsItsStack

	"The process that was running has no context: its stack is where the VM saved its
	registers on leaving for C. Its newest frame is where the VM's instructionPointer says."

	| stack newest |
	stack := memory activationsOfProcess: memory reifiedActiveProcess.
	newest := stack first.

	self assert: newest isStackFrame.
	self assert: (stack anySatisfy: [ :each | each isBaseFrame ]).
	stack do: [ :each |
		self assert: (each compiledCode isCompiledMethodOop or: [ each compiledCode isCompiledBlockOop ]) ].
	self assert: newest pc notNil.
	self
		assert: (newest pc - (memory firstBytecodePCOf: newest compiledCode)
			 between: 0
			 and: newest compiledCode endPC)
