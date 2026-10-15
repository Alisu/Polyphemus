instance creation
on: aPid

	"A reader through its process handle, or CannotReadProcess saying why, as on Linux and
	macOS: no such process, the system refused it, or not a Pharo VM."

	| handle reader |
	(self processExists: aPid) ifFalse: [ ^ (CannotReadProcess new pid: aPid reason: #noSuchProcess) signal ].
	"QUERY_INFORMATION, VM_READ, VM_WRITE, VM_OPERATION, SUSPEND_RESUME."
	handle := self openProcess: 16r0C38 inherit: 0 pid: aPid.
	handle = 0 ifTrue: [ ^ (CannotReadProcess new pid: aPid reason: #theOperatingSystemRefused) signal ].
	reader := self new setHandle: handle pid: aPid.
	reader isPharoVirtualMachine ifFalse: [
		reader close.
		^ (CannotReadProcess new pid: aPid reason: #notAPharoVirtualMachine) signal ].
	^ reader
