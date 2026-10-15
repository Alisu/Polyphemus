library
currentThreadId

	^ self ffiCall: #( uint32 GetCurrentThreadId ( ) )
