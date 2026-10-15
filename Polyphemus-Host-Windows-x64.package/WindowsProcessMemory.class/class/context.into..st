library
context: aThread into: aContext

	^ self ffiCall: #( int32 GetThreadContext ( uint64 aThread , void * aContext ) )
