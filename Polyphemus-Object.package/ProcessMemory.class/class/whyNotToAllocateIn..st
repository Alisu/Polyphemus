holding it still
whyNotToAllocateIn: someVMVariables

	"Why an object made now, or an old one remembered, could be lost: a collection, or the VM in its
	own code and not at rest, where it may be remembering one itself (#167). nil in machine code or
	at rest; registers that do not tell are not machine code."

	(self whyCollectingIn: someVMVariables) ifNotNil: [ :why | ^ why ].
	someVMVariables wasRunningMachineCode == true ifTrue: [ ^ nil ].
	^ someVMVariables isAtRest
		  ifTrue: [ nil ]
		  ifFalse: [ 'in its own code and not at rest, where the VM may be remembering an object' ]
