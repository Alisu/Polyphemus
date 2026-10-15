library
nextThread: aSnapshot into: anEntry

	^ self ffiCall: #( int32 Thread32Next ( uint64 aSnapshot , void * anEntry ) )
