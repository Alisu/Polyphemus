holding it still
stop

	"Every thread suspended at once (NtSuspendProcess)."

	self class suspendProcess: handle.
	^ self isStopped
