library
suspendThread: aThread

	^ self ffiCall: #( uint32 SuspendThread ( uint64 aThread ) )
