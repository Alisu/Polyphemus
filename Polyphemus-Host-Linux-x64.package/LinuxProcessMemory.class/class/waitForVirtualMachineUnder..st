instance creation
waitForVirtualMachineUnder: aPid

	"Wait for the virtual machine to appear under what the shell started. Whether it can be read
	is not waited for: #on: decides that once, saying what went wrong."

	| found |
	Poll
		until: [
			found := ((self unchecked: aPid) exists and: [ (self unchecked: aPid) isPharoVirtualMachine ])
				         ifTrue: [ aPid ]
				         ifFalse: [ self virtualMachineChildOf: aPid ].
			found notNil ]
		every: 50 milliSeconds
		atMost: 100.
	found ifNil: [
		^ (CannotReadProcess new pid: aPid reason: #noVirtualMachineAppeared) signal ].
	^ self on: found
