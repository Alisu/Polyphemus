instance creation
waitForVirtualMachineUnder: aPid

	"What the shell started may be the virtual machine or a script that starts one, and an
	image takes a moment to load before its memory is worth anything.

	The wait is only for it to *appear*. Whether we are then allowed to read it is not
	something waiting will change, so that is decided once, by `#on:`, which says which of
	the three things went wrong."

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
