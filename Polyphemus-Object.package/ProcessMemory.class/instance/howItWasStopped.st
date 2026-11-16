testing
howItWasStopped

	"What its VM was doing when stopped: at rest in the kernel or in machine code, where no
	allocation of the VM's own is under way, or in its own code, where one may be (#165)."

	| inMachineCode |
	self isQuiet ifTrue: [ ^ 'at rest in the kernel' ].
	inMachineCode := VMVariables whereTheVMSays: [ { (VMVariables on: self) wasRunningMachineCode } ].
	inMachineCode ifNil: [ ^ 'in a state it does not say' ].
	^ inMachineCode first == true
		  ifTrue: [ 'in machine code' ]
		  ifFalse: [ 'in its own code, not at rest' ]
