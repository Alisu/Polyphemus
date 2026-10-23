instance creation
on: aPid

	"A reader through its task port, or CannotReadProcess saying why, as on Linux: no such
	process, the system refused (not root, or a hardened VM), or not a Pharo VM."

	| reader port |
	self refuseItsOwn: aPid.
	reader := self new setTask: nil pid: aPid.
	reader exists ifFalse: [ ^ (CannotReadProcess new pid: aPid reason: #noSuchProcess) signal ].
	port := self pinned: 4.
	(self taskForPid: aPid from: self selfTask into: port) = 0 ifFalse: [
		^ (CannotReadProcess new pid: aPid reason: #theOperatingSystemRefused) signal ].
	reader setTask: (port unsignedLongAt: 1) pid: aPid.
	reader isPharoVirtualMachine ifFalse: [
		^ (CannotReadProcess new pid: aPid reason: #notAPharoVirtualMachine) signal ].
	^ reader
