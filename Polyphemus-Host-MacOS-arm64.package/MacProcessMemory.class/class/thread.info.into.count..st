library
thread: aThreadPort info: aFlavor into: aBuffer count: aCount

	^ self ffiCall: #( int thread_info ( uint32 aThreadPort , int aFlavor , void * aBuffer , void * aCount ) )
