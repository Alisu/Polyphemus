holding it still
whyNotToAllocateIn: someVMVariables

	"Why objects made in eden now could be written over: a collection, or the JIT's own allocation
	in flight, freeStart in a register, which a stop in machine code may cut (#163, #167)."

	(self whyCollectingIn: someVMVariables) ifNotNil: [ :why | ^ why ].
	^ someVMVariables wasRunningMachineCode == true
		  ifTrue: [ 'running machine code, where the JIT may be making an object' ]
		  ifFalse: [ nil ]
