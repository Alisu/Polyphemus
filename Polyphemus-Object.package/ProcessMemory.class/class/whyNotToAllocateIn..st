holding it still
whyNotToAllocateIn: someVMVariables

	"Why an object made now, or an old one remembered, could be lost: a collection; or the VM in
	its own code and not at rest, where it may be remembering one, the set's size in a register
	(#167). In machine code it is in none of its routines, and nothing is made where the JIT
	makes its own (#137). Registers that do not tell are not machine code."

	(self whyCollectingIn: someVMVariables) ifNotNil: [ :why | ^ why ].
	someVMVariables wasRunningMachineCode == true ifTrue: [ ^ nil ].
	^ someVMVariables isAtRest
		  ifTrue: [ nil ]
		  ifFalse: [ 'in its own code and not at rest, where the VM may be remembering an object' ]
