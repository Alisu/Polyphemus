instance creation
on: aPid

	"Its task port, which macOS gives a root observer when the target is not hardened."

	| port result |
	port := self pinned: 4.
	result := self taskForPid: aPid from: self selfTask into: port.
	result = 0 ifFalse: [
		self error: 'macOS refused the task port of process ' , aPid printString , ' (kern_return '
			, result printString , '): run the observer as root; a hardened VM refuses even root' ].
	^ self new setTask: (port unsignedLongAt: 1) pid: aPid
