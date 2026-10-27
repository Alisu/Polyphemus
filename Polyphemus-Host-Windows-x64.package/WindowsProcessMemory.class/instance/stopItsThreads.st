holding it still
stopItsThreads

	"Every thread suspended at once (NtSuspendProcess)."

	self class suspendProcess: self handle.
	^ self isStopped
