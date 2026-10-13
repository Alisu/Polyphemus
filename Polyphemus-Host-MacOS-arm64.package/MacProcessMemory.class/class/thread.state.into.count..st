library
thread: aThread state: aFlavor into: aBuffer count: aCountBuffer

	^ self ffiCall: #( int thread_get_state ( uint32 aThread , int aFlavor , void * aBuffer , void * aCountBuffer ) )
