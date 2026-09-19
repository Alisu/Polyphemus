instance creation
waitForVirtualMachineUnder: aPid

	"Wait for the virtual machine to appear under what the shell started. Whether it can be read
	is not waited for: #on: decides that once, saying what went wrong."

	| waited found |
	waited := 0.
	found := nil.
	[ found isNil and: [ waited < 100 ] ] whileTrue: [
		found := ((self unchecked: aPid) exists and: [
			          (self unchecked: aPid) isPharoVirtualMachine ])
			         ifTrue: [ aPid ]
			         ifFalse: [ self virtualMachineChildOf: aPid ].
		found ifNil: [
			waited := waited + 1.
			(Delay forMilliseconds: 50) wait ] ].
	found ifNil: [
		^ (CannotReadProcess new pid: aPid reason: #noVirtualMachineAppeared) signal ].
	^ self on: found
