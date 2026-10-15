library
resumeThread: aThread

	^ self ffiCall: #( uint32 ResumeThread ( uint64 aThread ) )
