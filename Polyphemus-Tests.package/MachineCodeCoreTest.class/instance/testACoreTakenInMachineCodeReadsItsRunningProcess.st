tests
testACoreTakenInMachineCodeReadsItsRunningProcess

	"Read from the registers, not refused (#17). Cog maps only some instructions (sends,
	jumps) to a bytecode, so the newest frame, caught between two, may have no pc; every frame
	under it has one, just after the send of the frame above, and the loop's DoIt is there."

	| core memory stack |
	core := (self machineCodeCoreWhere: #inItsFrame) ifNil: [ ^ self skip: 'no gdb here, or no core caught in machine code' ].
	memory := (SpurDumpedMemory on: (ElfCoreDump on: core)) reifiedMemory.
	stack := memory activationsOfProcess: memory reifiedActiveProcess.

	self assert: stack notEmpty.
	self assert: stack first isMachineCodeFrame.
	self assert: (stack anySatisfy: [ :each | each method selector = #DoIt ]).
	2 to: stack size do: [ :index |
		| frame callee sent |
		frame := stack at: index.
		callee := stack at: index - 1.
		self assert: frame pc notNil.
		(frame isStackFrame and: [ callee isStackFrame ]) ifTrue: [
			sent := self selectorSentJustBefore: frame in: memory.
			self assert: (callee isBlockContext
					 ifTrue: [ sent beginsWith: 'value' ]
					 ifFalse: [ sent = callee selector or: [ sent beginsWith: 'perform' ] ]) ] ]
