holding it still
stop

	"Every thread suspended at once (NtSuspendProcess), and the map and blocks read before
	forgotten: running, it may have committed or freed any of them since."

	self class suspendProcess: self handle.
	segments := nil.
	blocks := nil.
	^ self isStopped
