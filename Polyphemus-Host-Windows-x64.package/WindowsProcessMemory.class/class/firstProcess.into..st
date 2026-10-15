library
firstProcess: aSnapshot into: anEntry

	^ self ffiCall: #( int32 Process32FirstW ( uint64 aSnapshot , void * anEntry ) )
