testing
howItWasStopped

	"What its VM was doing when stopped: at rest in the kernel or in machine code, where no
	allocation of the VM's own is under way, or in its own code, where one may be (#165)."

	^ [
	  self isQuiet
		  ifTrue: [ 'at rest in the kernel' ]
		  ifFalse: [
			  (VMVariables on: self) wasRunningMachineCode == true
				  ifTrue: [ 'in machine code' ]
				  ifFalse: [ 'in its own code, not at rest' ] ] ]
		  on: Error
		  do: [ :error | 'in a state it does not say' ]
