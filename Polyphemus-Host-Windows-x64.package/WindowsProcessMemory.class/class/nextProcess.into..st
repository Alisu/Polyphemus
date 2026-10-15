library
nextProcess: aSnapshot into: anEntry

	^ self ffiCall: #( int32 Process32NextW ( uint64 aSnapshot , void * anEntry ) )
